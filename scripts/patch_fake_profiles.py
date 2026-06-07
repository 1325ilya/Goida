import os
import sys
import plistlib
import subprocess
import tempfile
import base64

# 1. Load target bundle_id and team_id from config JSON
config_path = "upstream/Telegram-iOS/build-system/template_minimal_development_configuration.json"
if not os.path.exists(config_path):
    print(f"Error: {config_path} not found")
    sys.exit(1)

with open(config_path, "r", encoding="utf-8") as f:
    import json
    config = json.load(f)

target_bundle_id = config["bundle_id"]
target_team_id = config["team_id"]
print(f"Patching fake profiles for Bundle ID: {target_bundle_id}, Team ID: {target_team_id}")

# 2. Extract signing identity from SelfSigned.p12
p12_path = "upstream/Telegram-iOS/build-system/fake-codesigning/certs/SelfSigned.p12"
p12_password = ""

def run_cmd(cmd, check=True):
    res = subprocess.run(cmd, capture_output=True, text=True, errors="ignore")
    if check and res.returncode != 0:
        print(f"Command failed: {' '.join(cmd)}")
        print("Stdout:", res.stdout)
        print("Stderr:", res.stderr)
        sys.exit(1)
    return res.stdout

# Extract cert in PEM format
proc = subprocess.Popen(
    ['openssl', 'pkcs12', '-in', p12_path, '-passin', 'pass:' + p12_password, '-nokeys', '-legacy'],
    stdout=subprocess.PIPE, stderr=subprocess.PIPE
)
cert_pem, _ = proc.communicate()

proc2 = subprocess.Popen(
    ['openssl', 'x509', '-noout', '-subject', '-nameopt', 'oneline,-esc_msb'],
    stdin=subprocess.PIPE, stdout=subprocess.PIPE, stderr=subprocess.PIPE
)
subject, _ = proc2.communicate(cert_pem)
subject = subject.decode('utf-8').strip()

signing_identity = None
if 'CN = ' in subject:
    signing_identity = subject.split('CN = ')[-1].split(',')[0].strip()

if not signing_identity:
    print("Error: Could not extract signing identity")
    sys.exit(1)

print(f"Using signing identity: {signing_identity}")

# Extract base64 cert
proc3 = subprocess.Popen(
    ['openssl', 'x509', '-outform', 'DER'],
    stdin=subprocess.PIPE, stdout=subprocess.PIPE, stderr=subprocess.PIPE
)
cert_der, _ = proc3.communicate(cert_pem)
cert_base64 = base64.b64encode(cert_der).decode('utf-8')

# 3. Patch each profile
profiles_dir = "upstream/Telegram-iOS/build-system/fake-codesigning/profiles"
keychain_name = "temp.keychain" # Created by ImportCertificates.py

for file_name in os.listdir(profiles_dir):
    if not file_name.endswith('.mobileprovision'):
        continue
    
    file_path = os.path.join(profiles_dir, file_name)
    print(f"Patching profile: {file_name}")
    
    # Decrypt plist
    plist_str = run_cmd(['security', 'cms', '-D', '-i', file_path])
    plist_file = tempfile.mktemp()
    with open(plist_file, 'w+', encoding='utf-8') as f:
        f.write(plist_str)
        
    # Remove developer certificates
    while True:
        res = subprocess.run(['plutil', '-remove', 'DeveloperCertificates.0', plist_file], capture_output=True)
        if res.returncode != 0:
            break
            
    # Insert new certificate data
    run_cmd(['plutil', '-insert', 'DeveloperCertificates.0', '-data', cert_base64, plist_file])
    
    # Remove signature key
    subprocess.run(['plutil', '-remove', 'DER-Encoded-Profile', plist_file])
    
    # Load and modify plist contents
    with open(plist_file, 'rb') as f:
        plist = plistlib.load(f)
        
    # Modify bundle ID and team ID
    entitlements = plist.get('Entitlements', {})
    
    # application-identifier: C67CF9S4VU.ph.telegra.Telegraph -> target_team_id.target_bundle_id
    app_id = entitlements.get('application-identifier', '')
    if app_id:
        # Check if it has an extension suffix
        prefix = "C67CF9S4VU.ph.telegra.Telegraph"
        if app_id.startswith(prefix):
            suffix = app_id[len(prefix):]
            entitlements['application-identifier'] = f"{target_team_id}.{target_bundle_id}{suffix}"
            
    # com.apple.developer.team-identifier
    if 'com.apple.developer.team-identifier' in entitlements:
        entitlements['com.apple.developer.team-identifier'] = target_team_id
        
    # com.apple.security.application-groups
    if 'com.apple.security.application-groups' in entitlements:
        groups = entitlements['com.apple.security.application-groups']
        new_groups = []
        for g in groups:
            if g.startswith("group.ph.telegra.Telegraph"):
                suffix = g[len("group.ph.telegra.Telegraph"):]
                new_groups.append(f"group.{target_bundle_id}{suffix}")
            else:
                new_groups.append(g)
        entitlements['com.apple.security.application-groups'] = new_groups
        
    # iCloud container IDs
    for key in ['com.apple.developer.icloud-container-identifiers', 'com.apple.developer.ubiquity-container-identifiers']:
        if key in entitlements:
            containers = entitlements[key]
            new_containers = []
            for c in containers:
                if c.startswith("iCloud.ph.telegra.Telegraph"):
                    suffix = c[len("iCloud.ph.telegra.Telegraph"):]
                    new_containers.append(f"iCloud.{target_bundle_id}{suffix}")
                else:
                    new_containers.append(c)
            entitlements[key] = new_containers
            
    # TeamIdentifier
    plist['TeamIdentifier'] = [target_team_id]
    
    # Name
    name = plist.get('Name', '')
    if "ph.telegra.Telegraph" in name:
        plist['Name'] = name.replace("ph.telegra.Telegraph", target_bundle_id)
        
    # Write back plist
    with open(plist_file, 'wb') as f:
        plistlib.dump(plist, f)
        
    # Sign again using security cms
    run_cmd([
        'security', 'cms', '-S',
        '-k', keychain_name,
        '-N', signing_identity,
        '-i', plist_file,
        '-o', file_path
    ])
    
    os.unlink(plist_file)

print("Successfully patched all fake provisioning profiles!")
