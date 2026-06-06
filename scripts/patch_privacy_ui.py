import sys
import os

target_file = sys.argv[1]

with open(target_file, "r", encoding="utf8") as f:
    content = f.read()

if "sosuzagramHeader" in content:
    print("Already patched.")
    sys.exit(0)

# Replace 1
content = content.replace(
"""    case dataSettings
    case loginEmail
}""",
"""    case dataSettings
    case loginEmail
    case sosuzagram
}""")

# Replace 2
content = content.replace(
"""    case dataSettingsInfo(PresentationTheme, String)
    
    var section: ItemListSectionId {""",
"""    case dataSettingsInfo(PresentationTheme, String)
    case sosuzagramHeader(PresentationTheme, String)
    case sosuzagramHistoryToggle(PresentationTheme, String, Bool)
    case sosuzagramHistoryInfo(PresentationTheme, String)
    
    var section: ItemListSectionId {""")

# Replace 3
content = content.replace(
"""        case .dataSettings, .dataSettingsInfo:
            return PrivacyAndSecuritySection.dataSettings.rawValue
        }
    }""",
"""        case .dataSettings, .dataSettingsInfo:
            return PrivacyAndSecuritySection.dataSettings.rawValue
        case .sosuzagramHeader, .sosuzagramHistoryToggle, .sosuzagramHistoryInfo:
            return PrivacyAndSecuritySection.sosuzagram.rawValue
        }
    }""")

# Replace 4
content = content.replace(
"""            case .dataSettingsInfo:
                return 32
        }
    }""",
"""            case .dataSettingsInfo:
                return 32
            case .sosuzagramHeader:
                return 33
            case .sosuzagramHistoryToggle:
                return 34
            case .sosuzagramHistoryInfo:
                return 35
        }
    }""")

# Replace 5
content = content.replace(
"""            case let .dataSettingsInfo(lhsTheme, lhsText):
                if case let .dataSettingsInfo(rhsTheme, rhsText) = rhs, lhsTheme === rhsTheme, lhsText == rhsText {
                    return true
                } else {
                    return false
                }
        }
    }""",
"""            case let .dataSettingsInfo(lhsTheme, lhsText):
                if case let .dataSettingsInfo(rhsTheme, rhsText) = rhs, lhsTheme === rhsTheme, lhsText == rhsText {
                    return true
                } else {
                    return false
                }
            case let .sosuzagramHeader(lhsTheme, lhsText):
                if case let .sosuzagramHeader(rhsTheme, rhsText) = rhs, lhsTheme === rhsTheme, lhsText == rhsText {
                    return true
                } else {
                    return false
                }
            case let .sosuzagramHistoryToggle(lhsTheme, lhsText, lhsValue):
                if case let .sosuzagramHistoryToggle(rhsTheme, rhsText, rhsValue) = rhs, lhsTheme === rhsTheme, lhsText == rhsText, lhsValue == rhsValue {
                    return true
                } else {
                    return false
                }
            case let .sosuzagramHistoryInfo(lhsTheme, lhsText):
                if case let .sosuzagramHistoryInfo(rhsTheme, rhsText) = rhs, lhsTheme === rhsTheme, lhsText == rhsText {
                    return true
                } else {
                    return false
                }
        }
    }""")

# Replace 6
content = content.replace(
"""            case let .dataSettingsInfo(_, text):
                return ItemListTextItem(presentationData: presentationData, text: .plain(text), sectionId: self.section)
        }
    }
}""",
"""            case let .dataSettingsInfo(_, text):
                return ItemListTextItem(presentationData: presentationData, text: .plain(text), sectionId: self.section)
            case let .sosuzagramHeader(_, text):
                return ItemListSectionHeaderItem(presentationData: presentationData, text: text, sectionId: self.section)
            case let .sosuzagramHistoryToggle(_, text, value):
                return ItemListSwitchItem(presentationData: presentationData, systemStyle: .glass, title: text, value: value, sectionId: self.section, style: .blocks, updated: { value in
                    UserDefaults.standard.set(value, forKey: "sosuzagram_local_history")
                })
            case let .sosuzagramHistoryInfo(_, text):
                return ItemListTextItem(presentationData: presentationData, text: .plain(text), sectionId: self.section)
        }
    }
}""")

# Replace 7
content = content.replace(
"""    entries.append(.dataSettings(presentationData.theme, presentationData.strings.PrivacySettings_DataSettings))
    entries.append(.dataSettingsInfo(presentationData.theme, presentationData.strings.PrivacySettings_DataSettingsHelp))
    
    return entries
}""",
"""    entries.append(.dataSettings(presentationData.theme, presentationData.strings.PrivacySettings_DataSettings))
    entries.append(.dataSettingsInfo(presentationData.theme, presentationData.strings.PrivacySettings_DataSettingsHelp))
    
    entries.append(.sosuzagramHeader(presentationData.theme, "SOSUZAGRAM SETTINGS"))
    let localHistoryValue = UserDefaults.standard.object(forKey: "sosuzagram_local_history") as? Bool ?? true
    entries.append(.sosuzagramHistoryToggle(presentationData.theme, "Save Deleted Messages", localHistoryValue))
    entries.append(.sosuzagramHistoryInfo(presentationData.theme, "If enabled, messages deleted by the other party will be saved locally in Sosuzagram."))
    
    return entries
}""")

with open(target_file, "w", encoding="utf8") as f:
    f.write(content)

if "sosuzagramHeader" not in content:
    print("Error: Failed to patch PrivacyAndSecurityController.swift!")
    sys.exit(1)

print("Patch applied successfully.")
