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
                    if text == "Save Deleted Messages" {
                        UserDefaults.standard.set(value, forKey: "sosuzagram_local_history")
                    } else if text == "Show Deletion Marker" {
                        UserDefaults.standard.set(value, forKey: "sosuzagram_show_marker")
                    } else if text == "Ghost Mode (Read without marking)" {
                        arguments.toggleSkipReadHistory(value)
                    }
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
    let showMarkerValue = UserDefaults.standard.object(forKey: "sosuzagram_show_marker") as? Bool ?? true
    entries.append(.sosuzagramHistoryToggle(presentationData.theme, "Show Deletion Marker", showMarkerValue))
    entries.append(.sosuzagramHistoryToggle(presentationData.theme, "Ghost Mode (Read without marking)", skipReadHistory))
    entries.append(.sosuzagramHistoryInfo(presentationData.theme, "If enabled, messages deleted by the other party will be saved locally in Sosuzagram. Deletion marker will show a trash icon next to deleted messages. Ghost Mode lets you read messages without sending read receipts."))
    
    return entries
}""")

# Replace 8 (Add to Arguments class)
content = content.replace(
"""    let openGiftsPrivacy: () -> Void
    
    init(account: Account, openBlockedUsers: @escaping () -> Void, openLastSeenPrivacy: @escaping () -> Void, openGroupsPrivacy: @escaping () -> Void, openVoiceCallPrivacy: @escaping () -> Void, openProfilePhotoPrivacy: @escaping () -> Void, openForwardPrivacy: @escaping () -> Void, openPhoneNumberPrivacy: @escaping () -> Void, openVoiceMessagePrivacy: @escaping () -> Void, openBioPrivacy: @escaping () -> Void, openBirthdayPrivacy: @escaping () -> Void, openSavedMusicPrivacy: @escaping () -> Void, openPasscode: @escaping () -> Void, openTwoStepVerification: @escaping (TwoStepVerificationAccessConfiguration?) -> Void, openPasskeys: @escaping () -> Void, openActiveSessions: @escaping () -> Void, toggleArchiveAndMuteNonContacts: @escaping (Bool) -> Void, setupAccountAutoremove: @escaping () -> Void, setupMessageAutoremove: @escaping () -> Void, openDataSettings: @escaping () -> Void, openEmailSettings: @escaping (String?) -> Void, openMessagePrivacy: @escaping () -> Void, openGiftsPrivacy: @escaping () -> Void) {""",
"""    let openGiftsPrivacy: () -> Void
    let toggleSkipReadHistory: (Bool) -> Void
    
    init(account: Account, openBlockedUsers: @escaping () -> Void, openLastSeenPrivacy: @escaping () -> Void, openGroupsPrivacy: @escaping () -> Void, openVoiceCallPrivacy: @escaping () -> Void, openProfilePhotoPrivacy: @escaping () -> Void, openForwardPrivacy: @escaping () -> Void, openPhoneNumberPrivacy: @escaping () -> Void, openVoiceMessagePrivacy: @escaping () -> Void, openBioPrivacy: @escaping () -> Void, openBirthdayPrivacy: @escaping () -> Void, openSavedMusicPrivacy: @escaping () -> Void, openPasscode: @escaping () -> Void, openTwoStepVerification: @escaping (TwoStepVerificationAccessConfiguration?) -> Void, openPasskeys: @escaping () -> Void, openActiveSessions: @escaping () -> Void, toggleArchiveAndMuteNonContacts: @escaping (Bool) -> Void, setupAccountAutoremove: @escaping () -> Void, setupMessageAutoremove: @escaping () -> Void, openDataSettings: @escaping () -> Void, openEmailSettings: @escaping (String?) -> Void, openMessagePrivacy: @escaping () -> Void, openGiftsPrivacy: @escaping () -> Void, toggleSkipReadHistory: @escaping (Bool) -> Void) {""")

content = content.replace(
"""        self.openMessagePrivacy = openMessagePrivacy
        self.openGiftsPrivacy = openGiftsPrivacy
    }""",
"""        self.openMessagePrivacy = openMessagePrivacy
        self.openGiftsPrivacy = openGiftsPrivacy
        self.toggleSkipReadHistory = toggleSkipReadHistory
    }""")

# Replace 9 (Add callback initialization)
content = content.replace(
"""        }))
    })
    
    actionsDisposable.add(context.engine.peers.managedUpdatedRecentPeers().start())""",
"""        }))
    }, toggleSkipReadHistory: { value in
        let _ = updateExperimentalUISettingsInteractively(accountManager: context.sharedContext.accountManager, { settings in
            var settings = settings
            settings.skipReadHistory = value
            return settings
        }).start()
    })
    
    actionsDisposable.add(context.engine.peers.managedUpdatedRecentPeers().start())""")

# Replace 10 (Add sharedData query key)
content = content.replace(
"""        context.sharedContext.accountManager.noticeEntry(key: ApplicationSpecificNotice.secretChatLinkPreviewsKey()),
        context.sharedContext.accountManager.sharedData(keys: [ApplicationSpecificSharedDataKeys.contactSynchronizationSettings]),""",
"""        context.sharedContext.accountManager.noticeEntry(key: ApplicationSpecificNotice.secretChatLinkPreviewsKey()),
        context.sharedContext.accountManager.sharedData(keys: [ApplicationSpecificSharedDataKeys.contactSynchronizationSettings, ApplicationSpecificSharedDataKeys.experimentalUISettings]),""")

# Replace 11 (Extract skipReadHistory and pass to entries signature)
content = content.replace(
"""        let isPremium = accountPeer?.isPremium ?? false
        let isPremiumDisabled = PremiumConfiguration.with(appConfiguration: context.currentAppConfiguration.with { $0 }).isPremiumDisabled
        
        let listState = ItemListNodeState(presentationData: ItemListPresentationData(presentationData), entries: privacyAndSecurityControllerEntries(presentationData: presentationData, state: state, privacySettings: privacySettings, accessChallengeData: accessChallengeData.data, blockedPeerCount: blockedPeersState.totalCount, activeWebsitesCount: activeWebsitesState.sessions.count, hasTwoStepAuth: twoStepAuth.0, twoStepAuthData: twoStepAuth.1, hasPasskeys: passkeys.0, displayPasskeys: displayPasskeys, canAutoarchive: canAutoarchive, isPremiumDisabled: isPremiumDisabled, isPremium: isPremium, loginEmail: loginEmail, accountPeer: accountPeer, appConfiguration: appConfiguration), style: .blocks, ensureVisibleItemTag: focusOnItemTag, animateChanges: false)""",
"""        let isPremium = accountPeer?.isPremium ?? false
        let isPremiumDisabled = PremiumConfiguration.with(appConfiguration: context.currentAppConfiguration.with { $0 }).isPremiumDisabled
        
        let experimentalSettings = sharedData.entries[ApplicationSpecificSharedDataKeys.experimentalUISettings]?.get(ExperimentalUISettings.self) ?? ExperimentalUISettings.defaultSettings
        let skipReadHistory = experimentalSettings.skipReadHistory
        
        let listState = ItemListNodeState(presentationData: ItemListPresentationData(presentationData), entries: privacyAndSecurityControllerEntries(presentationData: presentationData, state: state, privacySettings: privacySettings, accessChallengeData: accessChallengeData.data, blockedPeerCount: blockedPeersState.totalCount, activeWebsitesCount: activeWebsitesState.sessions.count, hasTwoStepAuth: twoStepAuth.0, twoStepAuthData: twoStepAuth.1, hasPasskeys: passkeys.0, displayPasskeys: displayPasskeys, canAutoarchive: canAutoarchive, isPremiumDisabled: isPremiumDisabled, isPremium: isPremium, loginEmail: loginEmail, accountPeer: accountPeer, appConfiguration: appConfiguration, skipReadHistory: skipReadHistory), style: .blocks, ensureVisibleItemTag: focusOnItemTag, animateChanges: false)""")

# Replace 12 (Update entries signature)
content = content.replace(
"""private func privacyAndSecurityControllerEntries(
    presentationData: PresentationData,
    state: PrivacyAndSecurityControllerState,
    privacySettings: AccountPrivacySettings?,
    accessChallengeData: PostboxAccessChallengeData,
    blockedPeerCount: Int?,
    activeWebsitesCount: Int,
    hasTwoStepAuth: Bool?,
    twoStepAuthData: TwoStepVerificationAccessConfiguration?,
    hasPasskeys: Bool?,
    displayPasskeys: Bool,
    canAutoarchive: Bool,
    isPremiumDisabled: Bool,
    isPremium: Bool,
    loginEmail: String?,
    accountPeer: EnginePeer?,
    appConfiguration: AppConfiguration
) -> [PrivacyAndSecurityEntry] {""",
"""private func privacyAndSecurityControllerEntries(
    presentationData: PresentationData,
    state: PrivacyAndSecurityControllerState,
    privacySettings: AccountPrivacySettings?,
    accessChallengeData: PostboxAccessChallengeData,
    blockedPeerCount: Int?,
    activeWebsitesCount: Int,
    hasTwoStepAuth: Bool?,
    twoStepAuthData: TwoStepVerificationAccessConfiguration?,
    hasPasskeys: Bool?,
    displayPasskeys: Bool,
    canAutoarchive: Bool,
    isPremiumDisabled: Bool,
    isPremium: Bool,
    loginEmail: String?,
    accountPeer: EnginePeer?,
    appConfiguration: AppConfiguration,
    skipReadHistory: Bool
) -> [PrivacyAndSecurityEntry] {""")

with open(target_file, "w", encoding="utf8") as f:
    f.write(content)

if "sosuzagramHeader" not in content:
    print("Error: Failed to patch PrivacyAndSecurityController.swift!")
    sys.exit(1)

print("Patch applied successfully.")
