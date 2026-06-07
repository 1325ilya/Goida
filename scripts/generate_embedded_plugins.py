import os
import base64

def main():
    root_dir = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
    imp_plug_dir = os.path.join(root_dir, "imp_plug")
    output_swift_path = os.path.join(root_dir, "Sources", "SosuzagramIOSCore", "EmbeddedPlugins.swift")
    
    print(f"Generating EmbeddedPlugins.swift from: {imp_plug_dir}")
    
    if not os.path.exists(imp_plug_dir):
        print(f"Error: {imp_plug_dir} does not exist.")
        return
        
    plugins = []
    for filename in sorted(os.listdir(imp_plug_dir)):
        if filename.endswith(".plugin") or filename.endswith(".sosuzagramplugin"):
            file_path = os.path.join(imp_plug_dir, filename)
            with open(file_path, "rb") as f:
                content = f.read()
            # We rename it to .sosuzagramplugin on deployment
            target_name = os.path.splitext(filename)[0] + ".sosuzagramplugin"
            encoded = base64.b64encode(content).decode("utf-8")
            plugins.append((target_name, encoded))
            print(f"Loaded {filename} -> {target_name} ({len(content)} bytes)")
            
    swift_content = """import Foundation

public struct EmbeddedPlugin {
    public let filename: String
    public let contentBase64: String
}

public let embeddedPlugins: [EmbeddedPlugin] = [
"""
    for name, encoded in plugins:
        # Split base64 into multiline string to avoid Swift compiler constraints on extremely long single-line strings
        chunk_size = 16000
        chunks = [encoded[i:i+chunk_size] for i in range(0, len(encoded), chunk_size)]
        chunks_str = "\\n        + ".join(f'"{chunk}"' for chunk in chunks)
        
        swift_content += f"""    EmbeddedPlugin(
        filename: "{name}",
        contentBase64: {chunks_str}
    ),
"""
    swift_content += """]

public func deployEmbeddedPluginsIfNeeded() {
    let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    let dir = paths[0].appendingPathComponent("SosuzagramPlugins")
    try? FileManager.default.createDirectory(at: dir, withIntermediateDirectories: true, attributes: nil)
    
    for plugin in embeddedPlugins {
        let fileURL = dir.appendingPathComponent(plugin.filename)
        if !FileManager.default.fileExists(atPath: fileURL.path) {
            if let data = Data(base64Encoded: plugin.contentBase64) {
                try? data.write(to: fileURL)
                
                // Set default plugin value to true
                // We need to parse metadata to get the plugin ID
                if let p = parsePlugin(at: fileURL) {
                    UserDefaults.standard.set(true, forKey: "sosuzagram_plugin_enabled_\\(p.id)")
                }
            }
        }
    }
}
"""
    
    os.makedirs(os.path.dirname(output_swift_path), exist_ok=True)
    with open(output_swift_path, "w", encoding="utf-8") as f:
        f.write(swift_content)
        
    print(f"Successfully generated: {output_swift_path}")

if __name__ == "__main__":
    main()
