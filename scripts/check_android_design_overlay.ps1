$ErrorActionPreference = "Stop"

$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$rootDir = Split-Path -Parent $scriptDir
$checkDir = Join-Path $rootDir "upstream\Telegram-iOS-android-check"
$sourceCoreDir = Join-Path $rootDir "Sources\SosuzagramIOSCore"
$targetCoreDir = Join-Path $checkDir "submodules\SosuzagramIOSCore"
$patch1 = Join-Path $rootDir "overlay\Sosuzagram\Patches\0001-sosuzagram-all-changes.patch"
$patch2 = Join-Path $rootDir "overlay\Sosuzagram\Patches\0002-sosuzagram-android-design.patch"

function Invoke-GitChecked {
    param(
        [string]$Repo,
        [string[]]$Arguments
    )

    & git -C $Repo @Arguments
    if ($LASTEXITCODE -ne 0) {
        throw "git -C `"$Repo`" $($Arguments -join ' ') failed with exit code $LASTEXITCODE"
    }
}

function Assert-Contains {
    param(
        [string]$Path,
        [string]$Pattern
    )

    if (-not (Select-String -Path $Path -Pattern $Pattern -SimpleMatch -Quiet)) {
        throw "Expected pattern not found in ${Path}: $Pattern"
    }
}

if (-not (Test-Path $sourceCoreDir)) {
    throw "Missing source core directory: $sourceCoreDir"
}
if (-not (Test-Path $patch1)) {
    throw "Missing patch: $patch1"
}
if (-not (Test-Path $patch2)) {
    throw "Missing patch: $patch2"
}

Invoke-GitChecked -Repo $checkDir -Arguments @("reset", "--hard", "HEAD")
Invoke-GitChecked -Repo $checkDir -Arguments @("clean", "-fd")

New-Item -ItemType Directory -Path $targetCoreDir -Force | Out-Null
Copy-Item (Join-Path $sourceCoreDir "*") $targetCoreDir -Recurse -Force

$buildContent = @'
load("@build_bazel_rules_swift//swift:swift.bzl", "swift_library")

swift_library(
    name = "SosuzagramIOSCore",
    srcs = glob([
        "**/*.swift",
    ]),
    module_name = "SosuzagramIOSCore",
    deps = [
        "//submodules/Display:Display",
        "//submodules/SSignalKit/SwiftSignalKit:SwiftSignalKit",
        "//submodules/Postbox:Postbox",
        "//submodules/TelegramCore:TelegramCore",
        "//submodules/TelegramPresentationData:TelegramPresentationData",
        "//submodules/ItemListUI:ItemListUI",
        "//submodules/AccountContext:AccountContext",
        "//submodules/PresentationDataUtils:PresentationDataUtils",
        "//submodules/TelegramUIPreferences:TelegramUIPreferences",
        "//submodules/LegacyMediaPickerUI:LegacyMediaPickerUI",
        "//submodules/AlertUI:AlertUI",
    ],
    visibility = ["//visibility:public"],
)
'@
[System.IO.File]::WriteAllText((Join-Path $targetCoreDir "BUILD"), $buildContent, (New-Object System.Text.UTF8Encoding($false)))

Invoke-GitChecked -Repo $checkDir -Arguments @("apply", "--whitespace=nowarn", "--check", $patch1)
Invoke-GitChecked -Repo $checkDir -Arguments @("apply", "--whitespace=nowarn", $patch1)
Invoke-GitChecked -Repo $checkDir -Arguments @("apply", "--whitespace=nowarn", "--check", $patch2)
Invoke-GitChecked -Repo $checkDir -Arguments @("apply", "--whitespace=nowarn", $patch2)

$checks = @(
    @{ Path = (Join-Path $checkDir "submodules\ChatListUI\Sources\Node\ChatListItem.swift"); Pattern = 'conversation cards' },
    @{ Path = (Join-Path $checkDir "submodules\TelegramUI\Components\Chat\ReplyAccessoryPanelNode\BUILD"); Pattern = '//submodules/SosuzagramIOSCore:SosuzagramIOSCore' },
    @{ Path = (Join-Path $checkDir "submodules\TelegramUI\Components\Chat\ReplyAccessoryPanelNode\Sources\ReplyAccessoryPanelNode.swift"); Pattern = 'reply accessory panel' },
    @{ Path = (Join-Path $checkDir "submodules\TelegramUI\Components\ChatList\ChatListFilterTabContainerNode\Sources\ChatListFilterTabContainerNode.swift"); Pattern = 'filter chips' },
    @{ Path = (Join-Path $checkDir "submodules\TelegramUI\Components\ChatListHeaderComponent\Sources\ChatListNavigationBar.swift"); Pattern = 'sosuzagramMaterialDesignLevelForCurrentMode()' },
    @{ Path = (Join-Path $checkDir "submodules\TelegramPresentationData\Sources\SosuzagramMaterial3Manager.swift"); Pattern = 'public func sosuzagramMaterialDesignLevelForCurrentMode() -> Int' },
    @{ Path = (Join-Path $checkDir "submodules\SosuzagramIOSCore\SosuzagramSettingsController.swift"); Pattern = 'sosuzagramApplyAndroidDesignPreset(value)' }
)

foreach ($check in $checks) {
    Assert-Contains -Path $check.Path -Pattern $check.Pattern
}

Write-Host "ANDROID_DESIGN_OVERLAY_OK"
