import Foundation
import UIKit
import UniformTypeIdentifiers
import Display
import SwiftSignalKit
import Postbox
import TelegramCore
import TelegramPresentationData
import ItemListUI
import AccountContext
import PresentationDataUtils
import TelegramUIPreferences
import LegacyMediaPickerUI
import AlertUI

private struct SosuzagramSettingsControllerArguments {
    let context: AccountContext
    let openCategory: (SosuzagramSettingsCategory) -> Void
    let toggleSkipReadHistory: (Bool) -> Void
    let toggleHideStoryViews: (Bool) -> Void
    let toggleHideTyping: (Bool) -> Void
    let toggleKeepLocalHistory: (Bool) -> Void
    let toggleShowMarker: (Bool) -> Void
    let toggleHideStories: (Bool) -> Void
    let toggleConfirmCalls: (Bool) -> Void
    let toggleConfirmVoiceMessages: (Bool) -> Void
    let toggleHideShareButton: (Bool) -> Void
    let togglePollResultsBeforeVoting: (Bool) -> Void
    let toggleMessageMenuEnabled: (Bool) -> Void
    let toggleGroupMessageMenu: (Bool) -> Void
    let toggleHideKeyboardOnScroll: (Bool) -> Void
    let toggleHideSendAsButton: (Bool) -> Void
    let toggleReplaceEditedWithIcon: (Bool) -> Void
    let toggleHideFloatingButton: (Bool) -> Void
    let toggleHideAllChatsTab: (Bool) -> Void
    let toggleHideGreetingSticker: (Bool) -> Void
    let toggleHideStickerTimestamp: (Bool) -> Void
    let toggleDisableCompactNumericCounts: (Bool) -> Void
    let toggleFormatTimeWithSeconds: (Bool) -> Void
    let toggleCommaAfterMention: (Bool) -> Void
    let toggleShowOnlineIndicator: (Bool) -> Void
    let toggleHideMessageTail: (Bool) -> Void
    let toggleCenterChatListTitle: (Bool) -> Void
    let toggleUseYandexMaps: (Bool) -> Void
    let toggleHideChatListStatus: (Bool) -> Void
    let toggleHideArchiveFromList: (Bool) -> Void
    let toggleOpenArchiveOnPull: (Bool) -> Void
    let toggleDisableArchiveReturnGesture: (Bool) -> Void
    let toggleRelativeOnlineTime: (Bool) -> Void
    let toggleHidePhoneNumber: (Bool) -> Void
    let toggleShowIdDc: (Bool) -> Void
    let toggleFilterZalgo: (Bool) -> Void
    let toggleAppVibration: (Bool) -> Void
    let toggleShowTranslateMessages: (Bool) -> Void
    let toggleTranslateEntireChats: (Bool) -> Void
    let openTranslationProvider: () -> Void
    let openTranslationTarget: () -> Void
    let openVoiceRecognitionLocale: () -> Void
    let toggleVoiceRecognitionOnDevice: (Bool) -> Void
    let toggleHideReactions: (Bool) -> Void
    let openDownloadAcceleration: () -> Void
    let toggleUploadAcceleration: (Bool) -> Void
    let toggleAlwaysSendHd: (Bool) -> Void
    let toggleHidePhotoCounter: (Bool) -> Void
    let toggleHideCameraTile: (Bool) -> Void
    let toggleEnableSoundWithVolumeButtons: (Bool) -> Void
    let togglePreferOriginalQuality: (Bool) -> Void
    let togglePictureInPictureSwipe: (Bool) -> Void
    let toggleStaticZoom: (Bool) -> Void
    let toggleRememberLastCamera: (Bool) -> Void
    let toggleUnifiedRounding: (Bool) -> Void
    let toggleMiniAvatars: (Bool) -> Void
    let toggleDisableSeparators: (Bool) -> Void
    let toggleSeparateHeaders: (Bool) -> Void
    let toggleChatThemes: (Bool) -> Void
    let toggleGlassHighlights: (Bool) -> Void
    let toggleForceBlur: (Bool) -> Void
    let toggleAndroidDesign: (Bool) -> Void
    let toggleSmoothAnimations: (Bool) -> Void
    let toggleSystemFonts: (Bool) -> Void
    let toggleSystemEmoji: (Bool) -> Void
    let toggleStickyAvatarAnimation: (Bool) -> Void
    let toggleShowFolderBadges: (Bool) -> Void
    let toggleForceSnow: (Bool) -> Void
    let toggleDoubleTapSeek: (Bool) -> Void
    let toggleInfiniteRecentStickers: (Bool) -> Void
    let toggleLowerNavigationButton: (Bool) -> Void
    let toggleQuickAdminActions: (Bool) -> Void
    let toggleAdvancedCameraSettings: (Bool) -> Void
    let openReplyStyle: () -> Void
    let openMessageMenuSettings: () -> Void
    let openPillStackMode: () -> Void
    let openNavigationInApp: () -> Void
    let openIconPacks: () -> Void
    let openIncomingDoubleTapAction: () -> Void
    let openOutgoingDoubleTapAction: () -> Void
    let openStickerSizePreset: () -> Void
    let openStickerShape: () -> Void
    let openCameraType: () -> Void
    let openVideoMessageCamera: () -> Void
    let openAvatarShape: () -> Void
    let openMaterialDesignLevel: () -> Void
    let openChatListTitleText: () -> Void
    let openFolderTabTitles: () -> Void
    let openDoNotTranslateLanguages: () -> Void
    let openLocalizationSettings: () -> Void
    let openThemeSettings: () -> Void
    let openChatFoldersSettings: () -> Void
    let selectIcon: (String) -> Void
    let openPlugin: (String) -> Void
    let importPlugin: () -> Void
}

private enum SosuzagramSettingsSection: Int32 {
    case ghost
    case antiDelete
    case translation
    case ui
    case icons
    case plugins
}

private struct SosuzagramSettingsEntry: ItemListNodeEntry {
    let section: ItemListSectionId
    let stableId: UInt64
    let sortId: Int32
    let signature: String
    let buildItem: (ItemListPresentationData, SosuzagramSettingsControllerArguments) -> ListViewItem

    static func == (lhs: SosuzagramSettingsEntry, rhs: SosuzagramSettingsEntry) -> Bool {
        return lhs.section == rhs.section
            && lhs.stableId == rhs.stableId
            && lhs.sortId == rhs.sortId
            && lhs.signature == rhs.signature
    }

    static func < (lhs: SosuzagramSettingsEntry, rhs: SosuzagramSettingsEntry) -> Bool {
        return lhs.sortId < rhs.sortId
    }

    func item(presentationData: ItemListPresentationData, arguments: Any) -> ListViewItem {
        return self.buildItem(presentationData, arguments as! SosuzagramSettingsControllerArguments)
    }
}

private enum SosuzagramSettingsCategory: CaseIterable {
    case basics
    case appearance
    case chats
    case plugins
    case other

    var title: String {
        switch self {
        case .basics:
            return "ÃÅ¾Ã‘ÂÃÂ½ÃÂ¾ÃÂ²ÃÂ½Ã‘â€¹ÃÂµ"
        case .appearance:
            return "ÃÅ¾Ã‘â€žÃÂ¾Ã‘â‚¬ÃÂ¼ÃÂ»ÃÂµÃÂ½ÃÂ¸ÃÂµ"
        case .chats:
            return "ÃÂ§ÃÂ°Ã‘â€šÃ‘â€¹"
        case .plugins:
            return "ÃÅ¸ÃÂ»ÃÂ°ÃÂ³ÃÂ¸ÃÂ½Ã‘â€¹"
        case .other:
            return "Ãâ€Ã‘â‚¬Ã‘Æ’ÃÂ³ÃÂ¾ÃÂµ"
        }
    }

    var subtitle: String {
        switch self {
        case .basics:
            return "ÃÅ¸ÃÂµÃ‘â‚¬ÃÂµÃÂ²ÃÂ¾ÃÂ´, ÃÂ°Ã‘â‚¬Ã‘â€¦ÃÂ¸ÃÂ², Ã‘â€žÃÂ¾Ã‘â‚¬ÃÂ¼ÃÂ°Ã‘â€šÃÂ¸Ã‘â‚¬ÃÂ¾ÃÂ²ÃÂ°ÃÂ½ÃÂ¸ÃÂµ, ÃÂ¿Ã‘â‚¬ÃÂ¸ÃÂ²ÃÂ°Ã‘â€šÃÂ½ÃÂ¾Ã‘ÂÃ‘â€šÃ‘Å’ ÃÂ¿Ã‘â‚¬ÃÂ¾Ã‘â€žÃÂ¸ÃÂ»Ã‘Â, ÃÂºÃÂ°Ã‘â‚¬Ã‘â€šÃ‘â€¹ ÃÂ¸ ÃÂ¾ÃÂ±Ã‘â€°ÃÂ¸ÃÂµ Ã‘â€šÃÂ²ÃÂ¸ÃÂºÃÂ¸."
        case .appearance:
            return "ÃËœÃÂºÃÂ¾ÃÂ½ÃÂºÃÂ¸, ÃÂ¸Ã‘ÂÃ‘â€šÃÂ¾Ã‘â‚¬ÃÂ¸ÃÂ¸, ÃÂ²ÃÂºÃÂ»ÃÂ°ÃÂ´ÃÂºÃÂ¸, ÃÂ·ÃÂ°ÃÂ³ÃÂ¾ÃÂ»ÃÂ¾ÃÂ²ÃÂ¾ÃÂº ÃÂ¸ ÃÂ²ÃÂ¸ÃÂ·Ã‘Æ’ÃÂ°ÃÂ»Ã‘Å’ÃÂ½Ã‘â€¹ÃÂµ ÃÂ½ÃÂ°Ã‘ÂÃ‘â€šÃ‘â‚¬ÃÂ¾ÃÂ¹ÃÂºÃÂ¸ Ã‘ÂÃÂ¿ÃÂ¸Ã‘ÂÃÂºÃÂ° Ã‘â€¡ÃÂ°Ã‘â€šÃÂ¾ÃÂ²."
        case .chats:
            return "ÃÂ¡ÃÂ¾ÃÂ¾ÃÂ±Ã‘â€°ÃÂµÃÂ½ÃÂ¸Ã‘Â, Ã‘â‚¬ÃÂµÃÂ°ÃÂºÃ‘â€ ÃÂ¸ÃÂ¸, Ã‘ÂÃ‘â€šÃÂ¸ÃÂºÃÂµÃ‘â‚¬Ã‘â€¹, ÃÂ¿ÃÂ¾ÃÂ´Ã‘â€šÃÂ²ÃÂµÃ‘â‚¬ÃÂ¶ÃÂ´ÃÂµÃÂ½ÃÂ¸Ã‘Â ÃÂ¸ ÃÂ¿ÃÂ¾ÃÂ²ÃÂµÃÂ´ÃÂµÃÂ½ÃÂ¸ÃÂµ ÃÂ²ÃÂ½Ã‘Æ’Ã‘â€šÃ‘â‚¬ÃÂ¸ Ã‘â€¡ÃÂ°Ã‘â€šÃÂ¾ÃÂ²."
        case .plugins:
            return "Ãâ€™Ã‘ÂÃ‘â€šÃ‘â‚¬ÃÂ¾ÃÂµÃÂ½ÃÂ½Ã‘â€¹ÃÂµ ÃÂ¿ÃÂ»ÃÂ°ÃÂ³ÃÂ¸ÃÂ½Ã‘â€¹ Extera ÃÂ¸ ÃÂ¸ÃÂ¼ÃÂ¿ÃÂ¾Ã‘â‚¬Ã‘â€š .plugin Ã‘â€žÃÂ°ÃÂ¹ÃÂ»ÃÂ¾ÃÂ²."
        case .other:
            return "Ghost mode, ÃÂ°ÃÂ½Ã‘â€šÃÂ¸Ã‘Æ’ÃÂ´ÃÂ°ÃÂ»ÃÂµÃÂ½ÃÂ¸ÃÂµ ÃÂ¸ ÃÂ¿Ã‘â‚¬ÃÂ¾Ã‘â€¡ÃÂ¸ÃÂµ ÃÂ´ÃÂ¾ÃÂ¿ÃÂ¾ÃÂ»ÃÂ½ÃÂ¸Ã‘â€šÃÂµÃÂ»Ã‘Å’ÃÂ½Ã‘â€¹ÃÂµ ÃÂ²ÃÂ¾ÃÂ·ÃÂ¼ÃÂ¾ÃÂ¶ÃÂ½ÃÂ¾Ã‘ÂÃ‘â€šÃÂ¸."
        }
    }

    var symbolName: String {
        switch self {
        case .basics:
            return "switch.2"
        case .appearance:
            return "paintpalette.fill"
        case .chats:
            return "bubble.left.and.bubble.right.fill"
        case .plugins:
            return "puzzlepiece.extension.fill"
        case .other:
            return "square.grid.2x2.fill"
        }
    }

    var gradientColors: (UIColor, UIColor) {
        switch self {
        case .basics:
            return (UIColor(red: 0.15, green: 0.53, blue: 0.98, alpha: 1.0), UIColor(red: 0.10, green: 0.81, blue: 0.86, alpha: 1.0))
        case .appearance:
            return (UIColor(red: 0.99, green: 0.49, blue: 0.32, alpha: 1.0), UIColor(red: 0.96, green: 0.24, blue: 0.48, alpha: 1.0))
        case .chats:
            return (UIColor(red: 0.36, green: 0.71, blue: 0.34, alpha: 1.0), UIColor(red: 0.14, green: 0.63, blue: 0.58, alpha: 1.0))
        case .plugins:
            return (UIColor(red: 0.55, green: 0.36, blue: 0.96, alpha: 1.0), UIColor(red: 0.34, green: 0.54, blue: 0.99, alpha: 1.0))
        case .other:
            return (UIColor(red: 0.70, green: 0.47, blue: 0.24, alpha: 1.0), UIColor(red: 0.49, green: 0.38, blue: 0.29, alpha: 1.0))
        }
    }
}

private enum SosuzagramMessageMenuOption: String, CaseIterable {
    case reply
    case copy
    case translate
    case speak
    case save
    case forward
    case select
    case delete

    var defaultsKey: String {
        return "sosuzagram_message_menu_option_\(self.rawValue)"
    }

    var title: String {
        switch self {
        case .reply:
            return "ÐžÑ‚Ð²ÐµÑ‚"
        case .copy:
            return "ÐšÐ¾Ð¿Ð¸Ñ€Ð¾Ð²Ð°Ð½Ð¸Ðµ"
        case .translate:
            return "ÐŸÐµÑ€ÐµÐ²Ð¾Ð´"
        case .speak:
            return "ÐžÐ·Ð²ÑƒÑ‡Ð¸Ð²Ð°Ð½Ð¸Ðµ"
        case .save:
            return "Ð¡Ð¾Ñ…Ñ€Ð°Ð½ÐµÐ½Ð¸Ðµ"
        case .forward:
            return "ÐŸÐµÑ€ÐµÑÑ‹Ð»ÐºÐ°"
        case .select:
            return "Ð’Ñ‹Ð´ÐµÐ»ÐµÐ½Ð¸Ðµ"
        case .delete:
            return "Ð£Ð´Ð°Ð»ÐµÐ½Ð¸Ðµ"
        }
    }

    var defaultValue: Bool {
        switch self {
        case .speak:
            return false
        default:
            return true
        }
    }
}

private func sosuzagramMessageMenuOptionEnabled(_ option: SosuzagramMessageMenuOption) -> Bool {
    let defaults = UserDefaults.standard
    if defaults.object(forKey: option.defaultsKey) == nil {
        return option.defaultValue
    }
    return defaults.bool(forKey: option.defaultsKey)
}

private func sosuzagramMessageMenuEnabledCount() -> Int {
    return SosuzagramMessageMenuOption.allCases.reduce(0) { partialResult, option in
        return partialResult + (sosuzagramMessageMenuOptionEnabled(option) ? 1 : 0)
    }
}

private func sosuzagramStickerSizePresetLabel(_ value: String) -> String {
    switch value {
    case "small":
        return "ÃÅ“ÃÂ°ÃÂ»ÃÂµÃÂ½Ã‘Å’ÃÂºÃÂ¸ÃÂ¹"
    case "large":
        return "Ãâ€˜ÃÂ¾ÃÂ»Ã‘Å’Ã‘Ë†ÃÂ¾ÃÂ¹"
    default:
        return "ÃÂ¡Ã‘â‚¬ÃÂµÃÂ´ÃÂ½ÃÂ¸ÃÂ¹"
    }
}

private func sosuzagramDoubleTapActionLabel(_ action: SosuzagramDoubleTapAction) -> String {
    switch action {
    case .reactions:
        return "ÃÂ ÃÂµÃÂ°ÃÂºÃ‘â€ ÃÂ¸ÃÂ¸"
    case .none:
        return "ÃÂÃÂµÃ‘â€š"
    }
}

private func sosuzagramDownloadAccelerationLabel(_ value: String) -> String {
    switch value {
    case "fast":
        return "Ð‘Ñ‹ÑÑ‚Ñ€Ð¾"
    case "faster":
        return "Ð‘Ñ‹ÑÑ‚Ñ€ÐµÐµ"
    default:
        return "ÐžÐ±Ñ‹Ñ‡Ð½Ð°Ñ"
    }
}

private func sosuzagramVoiceRecognitionLocaleLabel(_ value: String) -> String {
    switch value {
    case "ru-RU":
        return "Ð ÑƒÑÑÐºÐ¸Ð¹"
    case "en-US":
        return "English"
    case "uk-UA":
        return "Ð£ÐºÑ€Ð°Ñ—Ð½ÑÑŒÐºÐ°"
    default:
        return "Ð¡Ð¸ÑÑ‚ÐµÐ¼Ð½Ñ‹Ð¹"
    }
}

private func sosuzagramTranslationProviderLabel(_ value: String) -> String {
    switch value {
    case "google":
        return "Google"
    case "system":
        return "Ð¡Ð¸ÑÑ‚ÐµÐ¼Ð½Ñ‹Ð¹"
    default:
        return "Telegram"
    }
}

private func sosuzagramTranslationTargetLabel(_ value: String) -> String {
    switch value {
    case "app":
        return "Ð¯Ð·Ñ‹Ðº Ð¿Ñ€Ð¸Ð»Ð¾Ð¶ÐµÐ½Ð¸Ñ"
    case "system":
        return "Ð¯Ð·Ñ‹Ðº ÑÐ¸ÑÑ‚ÐµÐ¼Ñ‹"
    case "ru":
        return "Ð ÑƒÑÑÐºÐ¸Ð¹"
    case "en":
        return "English"
    case "uk":
        return "Ð£ÐºÑ€Ð°Ñ—Ð½ÑÑŒÐºÐ°"
    default:
        let normalizedValue = value.replacingOccurrences(of: "_", with: "-")
        let locale = Locale(identifier: Locale.current.identifier)
        return locale.localizedString(forLanguageCode: normalizedValue) ?? normalizedValue
    }
}

private func sosuzagramAndroidDesignEnabled() -> Bool {
    return UserDefaults.standard.bool(forKey: "sosuzagram_android_design")
}

private func sosuzagramSmoothAnimationsEnabled() -> Bool {
    return UserDefaults.standard.bool(forKey: "sosuzagram_smooth_animations")
}

private func sosuzagramSettingsSystemStyle() -> ItemListSystemStyle {
    let materialDesignLevel = max(0, min(3, UserDefaults.standard.integer(forKey: "sosuzagram_material_design_level")))
    return (sosuzagramAndroidDesignEnabled() || materialDesignLevel > 0) ? .legacy : .glass
}

private func sosuzagramApplyAndroidDesignPreset(_ value: Bool) {
    let defaults = UserDefaults.standard
    defaults.set(value, forKey: "sosuzagram_android_design")

    if value {
        defaults.set("circle", forKey: "sosuzagram_avatar_shape")
        defaults.set(true, forKey: "sosuzagram_unified_rounding")
        defaults.set(false, forKey: "sosuzagram_disable_separators")
        defaults.set(false, forKey: "sosuzagram_separate_headers")
        defaults.set(true, forKey: "sosuzagram_chat_themes")
        defaults.set(3, forKey: "sosuzagram_material_design_level")
        defaults.set(false, forKey: "sosuzagram_system_fonts")
        defaults.set(false, forKey: "sosuzagram_system_emoji")
        defaults.set(true, forKey: "sosuzagram_sticky_avatar_animation")
        defaults.set(false, forKey: "sosuzagram_force_snow")
        defaults.set(false, forKey: "sosuzagram_hide_chat_list_status")
        defaults.set(false, forKey: "sosuzagram_center_chat_list_title")
        defaults.set(false, forKey: "sosuzagram_mini_avatars")
        defaults.set(true, forKey: "sosuzagram_smooth_animations")
        defaults.set(true, forKey: "sosuzagram_show_folder_badges")
        defaults.set("title_and_icon", forKey: "sosuzagram_folder_tab_titles")
        defaults.set("name", forKey: "sosuzagram_chat_list_title_text")
    }
}

private func sosuzagramVideoMessageCameraLabel(_ value: String) -> String {
    switch value {
    case "front":
        return "ÃÂ¤Ã‘â‚¬ÃÂ¾ÃÂ½Ã‘â€šÃÂ°ÃÂ»Ã‘Å’ÃÂ½ÃÂ°Ã‘Â"
    case "back":
        return "ÃÅ¾Ã‘ÂÃÂ½ÃÂ¾ÃÂ²ÃÂ½ÃÂ°Ã‘Â"
    case "last":
        return "ÃÅ¸ÃÂ¾Ã‘ÂÃÂ»ÃÂµÃÂ´ÃÂ½Ã‘ÂÃ‘Â"
    default:
        return "ÃÂ¡ÃÂ¸Ã‘ÂÃ‘â€šÃÂµÃÂ¼ÃÂ½ÃÂ¾"
    }
}

private func sosuzagramCameraTypeLabel(_ value: String) -> String {
    switch value {
    case "camera1":
        return "Camera 1"
    case "camera2":
        return "Camera 2"
    default:
        return "Ð¡Ð¸ÑÑ‚ÐµÐ¼Ð½Ð¾"
    }
}

private func sosuzagramAvatarShapeLabel(_ value: String) -> String {
    switch value {
    case "circle":
        return "ÃÅ¡Ã‘â‚¬Ã‘Æ’ÃÂ³"
    case "rounded":
        return "ÃÂ¡ÃÂºÃ‘â‚¬Ã‘Æ’ÃÂ³ÃÂ»Ã‘â€˜ÃÂ½ÃÂ½ÃÂ°Ã‘Â"
    case "square":
        return "ÃÅ¡ÃÂ²ÃÂ°ÃÂ´Ã‘â‚¬ÃÂ°Ã‘â€š"
    default:
        return "ÃÂ¡ÃÂ¸Ã‘ÂÃ‘â€šÃÂµÃÂ¼ÃÂ½ÃÂ¾"
    }
}

private func sosuzagramChatListTitleTextLabel(_ value: String) -> String {
    switch value {
    case "username":
        return "Username"
    case "name_and_username":
        return "ÃËœÃÂ¼Ã‘Â ÃÂ¸ username"
    default:
        return "ÃËœÃÂ¼Ã‘Â"
    }
}

private func sosuzagramFolderTabTitlesLabel(_ value: String) -> String {
    switch value {
    case "icon":
        return "ÃÂ¢ÃÂ¾ÃÂ»Ã‘Å’ÃÂºÃÂ¾ ÃÂ¸ÃÂºÃÂ¾ÃÂ½ÃÂºÃÂ°"
    case "title_and_icon":
        return "ÃÂÃÂ°ÃÂ·ÃÂ²ÃÂ°ÃÂ½ÃÂ¸ÃÂµ ÃÂ¸ ÃÂ¸ÃÂºÃÂ¾ÃÂ½ÃÂºÃÂ°"
    default:
        return "ÃÂÃÂ°ÃÂ·ÃÂ²ÃÂ°ÃÂ½ÃÂ¸ÃÂµ"
    }
}

private func sosuzagramMaterialDesignLevelLabel(_ value: Int) -> String {
    let clampedValue = max(0, min(3, value))
    return "\(clampedValue)/3"
}

private func sosuzagramReplyStyleLabel(_ value: String) -> String {
    switch value {
    case "rounded":
        return "Ð—Ð°ÐºÑ€ÑƒÐ³Ð»Ñ‘Ð½Ð½Ñ‹Ðµ"
    case "message":
        return "Ð¡Ð¾Ð¾Ð±Ñ‰ÐµÐ½Ð¸Ñ"
    default:
        return "ÐŸÐ¾ ÑƒÐ¼Ð¾Ð»Ñ‡Ð°Ð½Ð¸ÑŽ"
    }
}

private func sosuzagramStickerShapeLabel(_ value: String) -> String {
    switch value {
    case "rounded":
        return "Ð—Ð°ÐºÑ€ÑƒÐ³Ð»Ñ‘Ð½Ð½Ð°Ñ"
    case "message":
        return "Ð¡Ð¾Ð¾Ð±Ñ‰ÐµÐ½Ð¸Ðµ"
    default:
        return "ÐŸÐ¾ ÑƒÐ¼Ð¾Ð»Ñ‡Ð°Ð½Ð¸ÑŽ"
    }
}

private func sosuzagramPillStackModeLabel(_ value: String) -> String {
    switch value {
    case "compact":
        return "ÐšÐ¾Ð¼Ð¿Ð°ÐºÑ‚Ð½Ñ‹Ð¹"
    case "stacked":
        return "Ð¡Ñ‚ÐµÐº"
    default:
        return "ÐžÑ‚ÐºÐ»ÑŽÑ‡ÐµÐ½Ð¾"
    }
}

private func sosuzagramCategoryIcon(_ category: SosuzagramSettingsCategory) -> UIImage? {
    let size = CGSize(width: 30.0, height: 30.0)
    let renderer = UIGraphicsImageRenderer(size: size)
    return renderer.image { context in
        let rect = CGRect(origin: .zero, size: size)
        let roundedRect = rect.insetBy(dx: 1.0, dy: 1.0)
        let path = UIBezierPath(roundedRect: roundedRect, cornerRadius: 10.0)
        context.cgContext.saveGState()
        path.addClip()

        let colors = [category.gradientColors.0.cgColor, category.gradientColors.1.cgColor] as CFArray
        let space = CGColorSpaceCreateDeviceRGB()
        if let gradient = CGGradient(colorsSpace: space, colors: colors, locations: [0.0, 1.0]) {
            context.cgContext.drawLinearGradient(gradient, start: CGPoint(x: 0.0, y: 0.0), end: CGPoint(x: size.width, y: size.height), options: [])
        }

        context.cgContext.setFillColor(UIColor.white.withAlphaComponent(0.12).cgColor)
        context.cgContext.fillEllipse(in: CGRect(x: -8.0, y: -10.0, width: 28.0, height: 18.0))
        context.cgContext.restoreGState()

        if let symbol = UIImage(
            systemName: category.symbolName,
            withConfiguration: UIImage.SymbolConfiguration(pointSize: 14.0, weight: .semibold)
        )?.withTintColor(.white, renderingMode: .alwaysOriginal) {
            let symbolOrigin = CGPoint(
                x: floor((size.width - symbol.size.width) / 2.0),
                y: floor((size.height - symbol.size.height) / 2.0)
            )
            symbol.draw(at: symbolOrigin)
        }
    }
}

private func sosuzagramCategoryMatches(_ category: SosuzagramSettingsCategory, signature: String) -> Bool {
    switch category {
    case .basics:
        return [
            "translate-header",
            "showtranslate:",
            "translatechats:",
            "translationprovider",
            "translationtarget",
            "donottranslate:",
            "languagesettings",
            "compactcounts:",
            "seconds:",
            "downloadacceleration:",
            "uploadacceleration:",
            "relativeonline:",
            "hidephone:",
            "showiddc:",
            "zalgo:",
            "appvibration:",
            "yandexmaps:",
            "hidearchive:",
            "openarchivepull:",
            "disablearchivereturn:"
        ].contains(where: { signature.hasPrefix($0) })
    case .appearance:
        return [
            "centertitle:",
            "hidechatliststatus:",
            "stories:",
            "hidefloating:",
            "hideallchatstab:",
            "avatarshape:",
            "unifiedrounding:",
            "miniavatars:",
            "disableseparators:",
            "separateheaders:",
            "chatthemes:",
            "materialdesignlevel:",
            "systememoji:",
            "stickyavataranimation:",
            "androiddesign:",
            "smoothanimations:",
            "systemfonts:",
            "folderbadges:",
            "chatlisttitletext:",
            "foldertabtitles:",
            "pillstackmode:",
            "navigationinapp",
            "glasshighlights:",
            "forceblur:",
            "forcesnow:",
            "iconpacks",
            "icons-header",
            "icon:",
            "appearance-links-header",
            "themesettings",
            "chatfolderssettings"
        ].contains(where: { signature.hasPrefix($0) })
    case .chats:
        return [
            "ui-header",
            "confirmcalls:",
            "confirmvoice:",
            "hideshare:",
            "pollpreview:",
            "messagemenuenabled:",
            "messagemenusettings:",
            "groupmessagemenu:",
            "hidekeyboard:",
            "hidesendas:",
            "hidegreetingsticker:",
            "commaaftermention:",
            "editedicon:",
            "onlineindicator:",
            "hidetail:",
            "hidereactions:",
            "voicerecognitionlocale:",
            "voiceondevice:",
            "doubletapincoming:",
            "doubletapoutgoing:",
            "hidestickertimestamp:",
            "stickersize:",
            "alwayssendhd:",
            "hidephotocounter:",
            "hidecameratile:",
            "soundwithvolumebuttons:",
            "cameratype:",
            "preferoriginalquality:",
            "pipswipe:",
            "staticzoom:",
            "rememberlastcamera:",
            "videomessagecamera:",
            "doubletapseek:",
            "infiniterecentstickers:",
            "lowerbutton:",
            "quickadminactions:",
            "stickershape:",
            "replystyle:",
            "advancedcamerasettings:"
        ].contains(where: { signature.hasPrefix($0) })
    case .plugins:
        return [
            "plugins-header",
            "plugins-import",
            "plugin:",
            "plugins-info"
        ].contains(where: { signature.hasPrefix($0) })
    case .other:
        return [
            "ghost-header",
            "skip:",
            "storyviews:",
            "typing:",
            "ghost-info",
            "anti-header",
            "history:",
            "marker:",
            "anti-info"
        ].contains(where: { signature.hasPrefix($0) })
    }
}

private func sosuzagramFilterEntries(_ entries: [SosuzagramSettingsEntry], category: SosuzagramSettingsCategory) -> [SosuzagramSettingsEntry] {
    return entries.filter { sosuzagramCategoryMatches(category, signature: $0.signature) }
}

private func sosuzagramIsCountableEntry(_ entry: SosuzagramSettingsEntry) -> Bool {
    if entry.signature.hasSuffix("-header") || entry.signature.hasSuffix("-info") {
        return false
    }
    if entry.signature == "plugins-import" {
        return false
    }
    return true
}

private func sosuzagramCategoryItemCount(_ entries: [SosuzagramSettingsEntry], category: SosuzagramSettingsCategory) -> Int {
    return sosuzagramFilterEntries(entries, category: category).filter(sosuzagramIsCountableEntry).count
}

private func sosuzagramLocalizedLanguageName(_ code: String) -> String {
    let locale = Locale(identifier: "ru_RU")
    let fallbackLocale = Locale.current
    return locale.localizedString(forLanguageCode: code)?.capitalized
        ?? fallbackLocale.localizedString(forLanguageCode: code)?.capitalized
        ?? code.uppercased()
}

private func sosuzagramDoNotTranslateSummary(_ ignoredLanguages: [String]?) -> String {
    guard let ignoredLanguages else {
        return "ÃÂÃÂ²Ã‘â€šÃÂ¾"
    }
    let normalized = ignoredLanguages.filter { !$0.isEmpty }
    guard !normalized.isEmpty else {
        return "ÃÂÃÂ²Ã‘â€šÃÂ¾"
    }
    let names = normalized.map(sosuzagramLocalizedLanguageName)
    switch names.count {
    case 1:
        return names[0]
    case 2:
        return "\(names[0]), \(names[1])"
    default:
        return "\(names[0]) +\(names.count - 1)"
    }
}

private func sosuzagramOverviewEntries(
    presentationData: PresentationData,
    allEntries: [SosuzagramSettingsEntry]
) -> [SosuzagramSettingsEntry] {
    var entries: [SosuzagramSettingsEntry] = []

    entries.append(SosuzagramSettingsEntry(
        section: 0,
        stableId: 0,
        sortId: 0,
        signature: "overview-header",
        buildItem: { presentationData, _ in
            ItemListSectionHeaderItem(presentationData: presentationData, text: "ÃÅ¡ÃÂ°Ã‘â€šÃÂµÃÂ³ÃÂ¾Ã‘â‚¬ÃÂ¸ÃÂ¸", sectionId: 0)
        }
    ))

    for (index, category) in SosuzagramSettingsCategory.allCases.enumerated() {
        let label = "\(sosuzagramCategoryItemCount(allEntries, category: category))"

        entries.append(SosuzagramSettingsEntry(
            section: 0,
            stableId: UInt64(1 + index),
            sortId: Int32(1 + index),
            signature: "overview:\(category.title)",
            buildItem: { presentationData, arguments in
                ItemListDisclosureItem(
                    presentationData: presentationData,
                    systemStyle: sosuzagramSettingsSystemStyle(),
                    icon: sosuzagramCategoryIcon(category),
                    title: category.title,
                    label: label,
                    labelStyle: .badge(presentationData.theme.list.itemAccentColor),
                    additionalDetailLabel: category.subtitle,
                    sectionId: 0,
                    style: .blocks,
                    disclosureStyle: .arrow,
                    action: {
                        arguments.openCategory(category)
                    }
                )
            }
        ))
    }

    entries.append(SosuzagramSettingsEntry(
        section: 1,
        stableId: 100,
        sortId: 100,
        signature: "overview-info",
        buildItem: { presentationData, _ in
            ItemListTextItem(
                presentationData: presentationData,
                text: .plain("ÃÂÃÂ°Ã‘ÂÃ‘â€šÃ‘â‚¬ÃÂ¾ÃÂ¹ÃÂºÃÂ¸ Sosuzagram Ã‘â‚¬ÃÂ°ÃÂ·ÃÂ»ÃÂ¾ÃÂ¶ÃÂµÃÂ½Ã‘â€¹ ÃÂ¿ÃÂ¾ ÃÂºÃÂ°Ã‘â€šÃÂµÃÂ³ÃÂ¾Ã‘â‚¬ÃÂ¸Ã‘ÂÃÂ¼. Ãâ€™ÃÂ½Ã‘Æ’Ã‘â€šÃ‘â‚¬ÃÂ¸ Ã‘â‚¬ÃÂ°ÃÂ·ÃÂ´ÃÂµÃÂ»ÃÂ¾ÃÂ² ÃÂ´ÃÂ¾Ã‘ÂÃ‘â€šÃ‘Æ’ÃÂ¿ÃÂ½Ã‘â€¹ ÃÂ²Ã‘ÂÃÂµ Ã‘Æ’ÃÂ¶ÃÂµ ÃÂ¿ÃÂµÃ‘â‚¬ÃÂµÃÂ½ÃÂµÃ‘ÂÃ‘â€˜ÃÂ½ÃÂ½Ã‘â€¹ÃÂµ ÃÂ½ÃÂ°Ã‘â€šÃÂ¸ÃÂ²ÃÂ½Ã‘â€¹ÃÂµ Ã‘â€žÃ‘Æ’ÃÂ½ÃÂºÃ‘â€ ÃÂ¸ÃÂ¸ ÃÂ¸ ÃÂ¿ÃÂ°Ã‘â‚¬ÃÂ°ÃÂ¼ÃÂµÃ‘â€šÃ‘â‚¬Ã‘â€¹ ÃÂ²Ã‘ÂÃ‘â€šÃ‘â‚¬ÃÂ¾ÃÂµÃÂ½ÃÂ½Ã‘â€¹Ã‘â€¦ ÃÂ¿ÃÂ»ÃÂ°ÃÂ³ÃÂ¸ÃÂ½ÃÂ¾ÃÂ²."),
                sectionId: 1
            )
        }
    ))

    return entries
}

private func sosuzagramPluginImportDirectory() throws -> URL {
    let fileManager = FileManager.default
    guard let documentsDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else {
        throw NSError(domain: "SosuzagramPluginImport", code: 1, userInfo: [NSLocalizedDescriptionKey: "Documents directory is unavailable."])
    }
    let pluginDirectory = documentsDirectory.appendingPathComponent("SosuzagramPlugins", isDirectory: true)
    try fileManager.createDirectory(at: pluginDirectory, withIntermediateDirectories: true, attributes: nil)
    return pluginDirectory
}

private func sosuzagramSanitizedPluginComponent(_ value: String) -> String {
    let allowed = CharacterSet.alphanumerics.union(CharacterSet(charactersIn: "_-"))
    let sanitized = value.unicodeScalars.map { allowed.contains($0) ? String($0) : "_" }.joined()
    let trimmed = sanitized.trimmingCharacters(in: CharacterSet(charactersIn: "_"))
    return trimmed.isEmpty ? "plugin" : trimmed
}

private func sosuzagramImportPluginFile(from sourceURL: URL) throws -> ImportedPlugin {
    let fileManager = FileManager.default
    guard let plugin = parsePlugin(at: sourceURL) else {
        throw NSError(domain: "SosuzagramPluginImport", code: 2, userInfo: [NSLocalizedDescriptionKey: "ÃÂ¤ÃÂ°ÃÂ¹ÃÂ» ÃÂ½ÃÂµ Ã‘ÂÃÂ¾ÃÂ´ÃÂµÃ‘â‚¬ÃÂ¶ÃÂ¸Ã‘â€š ÃÂºÃÂ¾Ã‘â‚¬Ã‘â‚¬ÃÂµÃÂºÃ‘â€šÃÂ½Ã‘â€¹ÃÂµ ÃÂ¼ÃÂµÃ‘â€šÃÂ°ÃÂ´ÃÂ°ÃÂ½ÃÂ½Ã‘â€¹ÃÂµ ÃÂ¿ÃÂ»ÃÂ°ÃÂ³ÃÂ¸ÃÂ½ÃÂ°."])
    }
    let directory = try sosuzagramPluginImportDirectory()
    let fileName = "\(sosuzagramSanitizedPluginComponent(plugin.id))_\(sosuzagramSanitizedPluginComponent(plugin.version)).sosuzagramplugin"
    let targetURL = directory.appendingPathComponent(fileName, isDirectory: false)
    if fileManager.fileExists(atPath: targetURL.path) {
        try fileManager.removeItem(at: targetURL)
    }
    try fileManager.copyItem(at: sourceURL, to: targetURL)
    return plugin
}

private func sosuzagramSettingsEntries(
    presentationData: PresentationData,
    skipReadHistory: Bool,
    hideStoryViews: Bool,
    hideTyping: Bool,
    keepLocalHistory: Bool,
    showMarker: Bool,
    hideStories: Bool,
    confirmCalls: Bool,
    confirmVoiceMessages: Bool,
    hideShareButton: Bool,
    pollResultsBeforeVoting: Bool,
    messageMenuEnabled: Bool,
    groupMessageMenu: Bool,
    hideKeyboardOnScroll: Bool,
    hideSendAsButton: Bool,
    replaceEditedWithIcon: Bool,
    hideFloatingButton: Bool,
    hideAllChatsTab: Bool,
    hideGreetingSticker: Bool,
    hideStickerTimestamp: Bool,
    disableCompactNumericCounts: Bool,
    formatTimeWithSeconds: Bool,
    commaAfterMention: Bool,
    showOnlineIndicator: Bool,
    hideMessageTail: Bool,
    centerChatListTitle: Bool,
    useYandexMaps: Bool,
    hideChatListStatus: Bool,
    hideArchiveFromList: Bool,
    openArchiveOnPull: Bool,
    disableArchiveReturnGesture: Bool,
    relativeOnlineTime: Bool,
    hidePhoneNumber: Bool,
    showIdDc: Bool,
    filterZalgo: Bool,
    appVibration: Bool,
    showTranslateMessages: Bool,
    translateEntireChats: Bool,
    translationProvider: String,
    translationTarget: String,
    doNotTranslateSummary: String,
    voiceRecognitionLocale: String,
    voiceRecognitionOnDevice: Bool,
    hideReactions: Bool,
    downloadAcceleration: String,
    uploadAcceleration: Bool,
    alwaysSendHd: Bool,
    hidePhotoCounter: Bool,
    hideCameraTile: Bool,
    enableSoundWithVolumeButtons: Bool,
    advancedCameraSettings: Bool,
    preferOriginalQuality: Bool,
    pictureInPictureSwipe: Bool,
    staticZoom: Bool,
    rememberLastCamera: Bool,
    cameraType: String,
    videoMessageCamera: String,
    doubleTapSeek: Bool,
    infiniteRecentStickers: Bool,
    lowerNavigationButton: Bool,
    quickAdminActions: Bool,
    replyStyle: String,
    incomingDoubleTapAction: SosuzagramDoubleTapAction,
    outgoingDoubleTapAction: SosuzagramDoubleTapAction,
    stickerSizePreset: String,
    stickerShape: String,
    avatarShape: String,
    unifiedRounding: Bool,
    miniAvatars: Bool,
    disableSeparators: Bool,
    separateHeaders: Bool,
    chatThemes: Bool,
    materialDesignLevel: Int,
    chatListTitleText: String,
    folderTabTitles: String,
    glassHighlights: Bool,
    forceBlur: Bool,
    androidDesign: Bool,
    smoothAnimations: Bool,
    systemFonts: Bool,
    systemEmoji: Bool,
    stickyAvatarAnimation: Bool,
    showFolderBadges: Bool,
    pillStackMode: String,
    forceSnow: Bool,
    currentIcon: String,
    plugins: [SosuzagramPluginDescriptor]
) -> [SosuzagramSettingsEntry] {
    let theme = presentationData.theme
    var entries: [SosuzagramSettingsEntry] = []

    entries.append(SosuzagramSettingsEntry(
        section: SosuzagramSettingsSection.ghost.rawValue,
        stableId: 0,
        sortId: 0,
        signature: "ghost-header",
        buildItem: { presentationData, _ in
            ItemListSectionHeaderItem(presentationData: presentationData, text: "ÃÂ ÃÂµÃÂ¶ÃÂ¸ÃÂ¼ ÃÂ¿Ã‘â‚¬ÃÂ¸ÃÂ·Ã‘â‚¬ÃÂ°ÃÂºÃÂ°", sectionId: SosuzagramSettingsSection.ghost.rawValue)
        }
    ))
    entries.append(SosuzagramSettingsEntry(
        section: SosuzagramSettingsSection.ghost.rawValue,
        stableId: 1,
        sortId: 1,
        signature: "skip:\(skipReadHistory)",
        buildItem: { presentationData, arguments in
            ItemListSwitchItem(presentationData: presentationData, systemStyle: sosuzagramSettingsSystemStyle(), title: "ÃÂÃÂµ ÃÂ¾Ã‘â€šÃÂ¼ÃÂµÃ‘â€¡ÃÂ°Ã‘â€šÃ‘Å’ ÃÂ¸Ã‘ÂÃ‘â€šÃÂ¾Ã‘â‚¬ÃÂ¸Ã‘Å½ ÃÂºÃÂ°ÃÂº ÃÂ¿Ã‘â‚¬ÃÂ¾Ã‘â€¡ÃÂ¸Ã‘â€šÃÂ°ÃÂ½ÃÂ½Ã‘Æ’Ã‘Å½", value: skipReadHistory, sectionId: SosuzagramSettingsSection.ghost.rawValue, style: .blocks, updated: { value in
                arguments.toggleSkipReadHistory(value)
            })
        }
    ))
    entries.append(SosuzagramSettingsEntry(
        section: SosuzagramSettingsSection.ghost.rawValue,
        stableId: 2,
        sortId: 2,
        signature: "storyviews:\(hideStoryViews)",
        buildItem: { presentationData, arguments in
            ItemListSwitchItem(presentationData: presentationData, systemStyle: sosuzagramSettingsSystemStyle(), title: "ÃÂ¡ÃÂºÃ‘â‚¬Ã‘â€¹ÃÂ²ÃÂ°Ã‘â€šÃ‘Å’ ÃÂ¿Ã‘â‚¬ÃÂ¾Ã‘ÂÃÂ¼ÃÂ¾Ã‘â€šÃ‘â‚¬Ã‘â€¹ ÃÂ¸Ã‘ÂÃ‘â€šÃÂ¾Ã‘â‚¬ÃÂ¸ÃÂ¹", value: hideStoryViews, sectionId: SosuzagramSettingsSection.ghost.rawValue, style: .blocks, updated: { value in
                arguments.toggleHideStoryViews(value)
            })
        }
    ))
    entries.append(SosuzagramSettingsEntry(
        section: SosuzagramSettingsSection.ghost.rawValue,
        stableId: 3,
        sortId: 3,
        signature: "typing:\(hideTyping)",
        buildItem: { presentationData, arguments in
            ItemListSwitchItem(presentationData: presentationData, systemStyle: sosuzagramSettingsSystemStyle(), title: "ÃÂ¡ÃÂºÃ‘â‚¬Ã‘â€¹ÃÂ²ÃÂ°Ã‘â€šÃ‘Å’ Ã‘ÂÃ‘â€šÃÂ°Ã‘â€šÃ‘Æ’Ã‘Â ÃÂ½ÃÂ°ÃÂ±ÃÂ¾Ã‘â‚¬ÃÂ° Ã‘â€šÃÂµÃÂºÃ‘ÂÃ‘â€šÃÂ°", value: hideTyping, sectionId: SosuzagramSettingsSection.ghost.rawValue, style: .blocks, updated: { value in
                arguments.toggleHideTyping(value)
            })
        }
    ))
    entries.append(SosuzagramSettingsEntry(
        section: SosuzagramSettingsSection.ghost.rawValue,
        stableId: 4,
        sortId: 4,
        signature: "ghost-info",
        buildItem: { presentationData, _ in
            ItemListTextItem(presentationData: presentationData, text: .plain("ÃÅ¸ÃÂ¾ÃÂ·ÃÂ²ÃÂ¾ÃÂ»Ã‘ÂÃÂµÃ‘â€š Ã‘â€¡ÃÂ¸Ã‘â€šÃÂ°Ã‘â€šÃ‘Å’ Ã‘ÂÃÂ¾ÃÂ¾ÃÂ±Ã‘â€°ÃÂµÃÂ½ÃÂ¸Ã‘Â, Ã‘ÂÃÂ¼ÃÂ¾Ã‘â€šÃ‘â‚¬ÃÂµÃ‘â€šÃ‘Å’ ÃÂ¸Ã‘ÂÃ‘â€šÃÂ¾Ã‘â‚¬ÃÂ¸ÃÂ¸ ÃÂ¸ ÃÂ¿ÃÂ¸Ã‘ÂÃÂ°Ã‘â€šÃ‘Å’ ÃÂ±ÃÂµÃÂ· ÃÂ»ÃÂ¸Ã‘Ë†ÃÂ½ÃÂ¸Ã‘â€¦ Ã‘Æ’ÃÂ²ÃÂµÃÂ´ÃÂ¾ÃÂ¼ÃÂ»ÃÂµÃÂ½ÃÂ¸ÃÂ¹ ÃÂ´ÃÂ»Ã‘Â Ã‘ÂÃÂ¾ÃÂ±ÃÂµÃ‘ÂÃÂµÃÂ´ÃÂ½ÃÂ¸ÃÂºÃÂ°."), sectionId: SosuzagramSettingsSection.ghost.rawValue)
        }
    ))

    entries.append(SosuzagramSettingsEntry(
        section: SosuzagramSettingsSection.antiDelete.rawValue,
        stableId: 5,
        sortId: 5,
        signature: "anti-header",
        buildItem: { presentationData, _ in
            ItemListSectionHeaderItem(presentationData: presentationData, text: "ÃÂÃÂ½Ã‘â€šÃÂ¸Ã‘Æ’ÃÂ´ÃÂ°ÃÂ»ÃÂµÃÂ½ÃÂ¸ÃÂµ", sectionId: SosuzagramSettingsSection.antiDelete.rawValue)
        }
    ))
    entries.append(SosuzagramSettingsEntry(
        section: SosuzagramSettingsSection.antiDelete.rawValue,
        stableId: 6,
        sortId: 6,
        signature: "history:\(keepLocalHistory)",
        buildItem: { presentationData, arguments in
            ItemListSwitchItem(presentationData: presentationData, systemStyle: sosuzagramSettingsSystemStyle(), title: "ÃÂ¡ÃÂ¾Ã‘â€¦Ã‘â‚¬ÃÂ°ÃÂ½Ã‘ÂÃ‘â€šÃ‘Å’ Ã‘Æ’ÃÂ´ÃÂ°ÃÂ»Ã‘â€˜ÃÂ½ÃÂ½Ã‘â€¹ÃÂµ Ã‘ÂÃÂ¾ÃÂ¾ÃÂ±Ã‘â€°ÃÂµÃÂ½ÃÂ¸Ã‘Â", value: keepLocalHistory, sectionId: SosuzagramSettingsSection.antiDelete.rawValue, style: .blocks, updated: { value in
                arguments.toggleKeepLocalHistory(value)
            })
        }
    ))
    entries.append(SosuzagramSettingsEntry(
        section: SosuzagramSettingsSection.antiDelete.rawValue,
        stableId: 7,
        sortId: 7,
        signature: "marker:\(showMarker)",
        buildItem: { presentationData, arguments in
            ItemListSwitchItem(presentationData: presentationData, systemStyle: sosuzagramSettingsSystemStyle(), title: "ÃÅ¸ÃÂ¾ÃÂºÃÂ°ÃÂ·Ã‘â€¹ÃÂ²ÃÂ°Ã‘â€šÃ‘Å’ ÃÂ¼ÃÂµÃ‘â€šÃÂºÃ‘Æ’ Ã‘Æ’ÃÂ´ÃÂ°ÃÂ»ÃÂµÃÂ½ÃÂ¸Ã‘Â", value: showMarker, sectionId: SosuzagramSettingsSection.antiDelete.rawValue, style: .blocks, updated: { value in
                arguments.toggleShowMarker(value)
            })
        }
    ))
    entries.append(SosuzagramSettingsEntry(
        section: SosuzagramSettingsSection.antiDelete.rawValue,
        stableId: 8,
        sortId: 8,
        signature: "anti-info",
        buildItem: { presentationData, _ in
            ItemListTextItem(presentationData: presentationData, text: .plain("Ãâ€ºÃÂ¾ÃÂºÃÂ°ÃÂ»Ã‘Å’ÃÂ½ÃÂ¾ Ã‘ÂÃÂ¾Ã‘â€¦Ã‘â‚¬ÃÂ°ÃÂ½Ã‘ÂÃÂµÃ‘â€š Ã‘Æ’ÃÂ´ÃÂ°ÃÂ»Ã‘â€˜ÃÂ½ÃÂ½Ã‘â€¹ÃÂµ ÃÂ¸ ÃÂ¾Ã‘â€šÃ‘â‚¬ÃÂµÃÂ´ÃÂ°ÃÂºÃ‘â€šÃÂ¸Ã‘â‚¬ÃÂ¾ÃÂ²ÃÂ°ÃÂ½ÃÂ½Ã‘â€¹ÃÂµ Ã‘ÂÃÂ¾ÃÂ¾ÃÂ±Ã‘â€°ÃÂµÃÂ½ÃÂ¸Ã‘Â. ÃÂ£ÃÂ´ÃÂ°ÃÂ»Ã‘â€˜ÃÂ½ÃÂ½Ã‘â€¹ÃÂµ Ã‘ÂÃÂ¾ÃÂ¾ÃÂ±Ã‘â€°ÃÂµÃÂ½ÃÂ¸Ã‘Â ÃÂ¼ÃÂ¾ÃÂ¶ÃÂ½ÃÂ¾ ÃÂ¿ÃÂ¾ÃÂ¼ÃÂµÃ‘â€¡ÃÂ°Ã‘â€šÃ‘Å’ ÃÂ¾Ã‘â€šÃÂ´ÃÂµÃÂ»Ã‘Å’ÃÂ½ÃÂ¾ÃÂ¹ ÃÂ¼ÃÂµÃ‘â€šÃÂºÃÂ¾ÃÂ¹."), sectionId: SosuzagramSettingsSection.antiDelete.rawValue)
        }
    ))

    entries.append(SosuzagramSettingsEntry(
        section: SosuzagramSettingsSection.translation.rawValue,
        stableId: 40,
        sortId: 15,
        signature: "translate-header",
        buildItem: { presentationData, _ in
            ItemListSectionHeaderItem(presentationData: presentationData, text: "ÃÅ¸ÃÂµÃ‘â‚¬ÃÂµÃÂ²ÃÂ¾ÃÂ´", sectionId: SosuzagramSettingsSection.translation.rawValue)
        }
    ))
    entries.append(SosuzagramSettingsEntry(
        section: SosuzagramSettingsSection.translation.rawValue,
        stableId: 41,
        sortId: 16,
        signature: "showtranslate:\(showTranslateMessages)",
        buildItem: { presentationData, arguments in
            ItemListSwitchItem(presentationData: presentationData, systemStyle: sosuzagramSettingsSystemStyle(), title: "ÃÅ¸ÃÂ¾ÃÂºÃÂ°ÃÂ·Ã‘â€¹ÃÂ²ÃÂ°Ã‘â€šÃ‘Å’ ÃÂºÃÂ½ÃÂ¾ÃÂ¿ÃÂºÃ‘Æ’ Ã‚Â«ÃÅ¸ÃÂµÃ‘â‚¬ÃÂµÃÂ²ÃÂµÃ‘ÂÃ‘â€šÃÂ¸Ã‚Â»", value: showTranslateMessages, sectionId: SosuzagramSettingsSection.translation.rawValue, style: .blocks, updated: { value in
                arguments.toggleShowTranslateMessages(value)
            })
        }
    ))
    entries.append(SosuzagramSettingsEntry(
        section: SosuzagramSettingsSection.translation.rawValue,
        stableId: 42,
        sortId: 17,
        signature: "translatechats:\(translateEntireChats)",
        buildItem: { presentationData, arguments in
            ItemListSwitchItem(presentationData: presentationData, systemStyle: sosuzagramSettingsSystemStyle(), title: "ÃÅ¸ÃÂµÃ‘â‚¬ÃÂµÃÂ²ÃÂ¾ÃÂ´ÃÂ¸Ã‘â€šÃ‘Å’ Ã‘â€¡ÃÂ°Ã‘â€šÃ‘â€¹ Ã‘â€ ÃÂµÃÂ»ÃÂ¸ÃÂºÃÂ¾ÃÂ¼", value: translateEntireChats, sectionId: SosuzagramSettingsSection.translation.rawValue, style: .blocks, updated: { value in
                arguments.toggleTranslateEntireChats(value)
            })
        }
    ))
    entries.append(SosuzagramSettingsEntry(
        section: SosuzagramSettingsSection.translation.rawValue,
        stableId: 45,
        sortId: 18,
        signature: "translationprovider:\(translationProvider)",
        buildItem: { presentationData, arguments in
            ItemListDisclosureItem(
                presentationData: presentationData,
                systemStyle: sosuzagramSettingsSystemStyle(),
                title: "ÐŸÑ€Ð¾Ð²Ð°Ð¹Ð´ÐµÑ€ Ð¿ÐµÑ€ÐµÐ²Ð¾Ð´Ð°",
                label: sosuzagramTranslationProviderLabel(translationProvider),
                sectionId: SosuzagramSettingsSection.translation.rawValue,
                style: .blocks,
                disclosureStyle: .arrow,
                action: {
                    arguments.openTranslationProvider()
                }
            )
        }
    ))
    entries.append(SosuzagramSettingsEntry(
        section: SosuzagramSettingsSection.translation.rawValue,
        stableId: 46,
        sortId: 19,
        signature: "translationtarget:\(translationTarget)",
        buildItem: { presentationData, arguments in
            ItemListDisclosureItem(
                presentationData: presentationData,
                systemStyle: sosuzagramSettingsSystemStyle(),
                title: "Ð¦ÐµÐ»ÐµÐ²Ð¾Ð¹ ÑÐ·Ñ‹Ðº",
                label: sosuzagramTranslationTargetLabel(translationTarget),
                additionalDetailLabel: "Ð˜ÑÐ¿Ð¾Ð»ÑŒÐ·ÑƒÐµÑ‚ÑÑ ÐºÐ°Ðº ÑÐ·Ñ‹Ðº Ð¿Ð¾ ÑƒÐ¼Ð¾Ð»Ñ‡Ð°Ð½Ð¸ÑŽ Ð´Ð»Ñ Ñ€ÑƒÑ‡Ð½Ð¾Ð³Ð¾ Ð¿ÐµÑ€ÐµÐ²Ð¾Ð´Ð° Ð¸ ÑÐºÑ€Ð°Ð½Ð¾Ð² Ð¿ÐµÑ€ÐµÐ²Ð¾Ð´Ð° Sosuzagram.",
                sectionId: SosuzagramSettingsSection.translation.rawValue,
                style: .blocks,
                disclosureStyle: .arrow,
                action: {
                    arguments.openTranslationTarget()
                }
            )
        }
    ))
    entries.append(SosuzagramSettingsEntry(
        section: SosuzagramSettingsSection.translation.rawValue,
        stableId: 43,
        sortId: 20,
        signature: "donottranslate:\(doNotTranslateSummary)",
        buildItem: { presentationData, arguments in
            ItemListDisclosureItem(
                presentationData: presentationData,
                systemStyle: sosuzagramSettingsSystemStyle(),
                title: "ÃÂÃÂµ ÃÂ¿ÃÂµÃ‘â‚¬ÃÂµÃÂ²ÃÂ¾ÃÂ´ÃÂ¸Ã‘â€šÃ‘Å’",
                label: doNotTranslateSummary,
                additionalDetailLabel: "Ãâ€™Ã‘â€¹ÃÂ±ÃÂµÃ‘â‚¬ÃÂ¸ Ã‘ÂÃÂ·Ã‘â€¹ÃÂºÃÂ¸, ÃÂºÃÂ¾Ã‘â€šÃÂ¾Ã‘â‚¬Ã‘â€¹ÃÂµ ÃÂ½ÃÂµ ÃÂ½Ã‘Æ’ÃÂ¶ÃÂ½ÃÂ¾ ÃÂ¿ÃÂµÃ‘â‚¬ÃÂµÃÂ²ÃÂ¾ÃÂ´ÃÂ¸Ã‘â€šÃ‘Å’ ÃÂ°ÃÂ²Ã‘â€šÃÂ¾ÃÂ¼ÃÂ°Ã‘â€šÃÂ¸Ã‘â€¡ÃÂµÃ‘ÂÃÂºÃÂ¸.",
                sectionId: SosuzagramSettingsSection.translation.rawValue,
                style: .blocks,
                disclosureStyle: .arrow,
                action: {
                    arguments.openDoNotTranslateLanguages()
                }
            )
        }
    ))
    entries.append(SosuzagramSettingsEntry(
        section: SosuzagramSettingsSection.translation.rawValue,
        stableId: 44,
        sortId: 21,
        signature: "languagesettings",
        buildItem: { presentationData, arguments in
            ItemListDisclosureItem(
                presentationData: presentationData,
                systemStyle: sosuzagramSettingsSystemStyle(),
                title: "ÃÂ¯ÃÂ·Ã‘â€¹ÃÂº ÃÂ¿Ã‘â‚¬ÃÂ¸ÃÂ»ÃÂ¾ÃÂ¶ÃÂµÃÂ½ÃÂ¸Ã‘Â ÃÂ¸ ÃÂ¿ÃÂµÃ‘â‚¬ÃÂµÃÂ²ÃÂ¾ÃÂ´",
                label: "",
                additionalDetailLabel: "ÃÅ¾Ã‘â€šÃÂºÃ‘â‚¬Ã‘â€¹ÃÂ²ÃÂ°ÃÂµÃ‘â€š Ã‘ÂÃÂ¸Ã‘ÂÃ‘â€šÃÂµÃÂ¼ÃÂ½Ã‘â€¹ÃÂ¹ Ã‘ÂÃÂºÃ‘â‚¬ÃÂ°ÃÂ½ Telegram Ã‘Â Ã‘ÂÃÂ·Ã‘â€¹ÃÂºÃÂ¾ÃÂ¼ ÃÂ¿Ã‘â‚¬ÃÂ¸ÃÂ»ÃÂ¾ÃÂ¶ÃÂµÃÂ½ÃÂ¸Ã‘Â ÃÂ¸ ÃÂ´ÃÂ¾ÃÂ¿ÃÂ¾ÃÂ»ÃÂ½ÃÂ¸Ã‘â€šÃÂµÃÂ»Ã‘Å’ÃÂ½Ã‘â€¹ÃÂ¼ÃÂ¸ Ã‘ÂÃÂ·Ã‘â€¹ÃÂºÃÂ¾ÃÂ²Ã‘â€¹ÃÂ¼ÃÂ¸ ÃÂ½ÃÂ°Ã‘ÂÃ‘â€šÃ‘â‚¬ÃÂ¾ÃÂ¹ÃÂºÃÂ°ÃÂ¼ÃÂ¸.",
                sectionId: SosuzagramSettingsSection.translation.rawValue,
                style: .blocks,
                disclosureStyle: .arrow,
                action: {
                    arguments.openLocalizationSettings()
                }
            )
        }
    ))

    entries.append(SosuzagramSettingsEntry(
        section: SosuzagramSettingsSection.ui.rawValue,
        stableId: 9,
        sortId: 9,
        signature: "ui-header",
        buildItem: { presentationData, _ in
            ItemListSectionHeaderItem(presentationData: presentationData, text: "ÃËœÃÂ½Ã‘â€šÃÂµÃ‘â‚¬Ã‘â€žÃÂµÃÂ¹Ã‘Â ÃÂ¸ ÃÂ¿ÃÂ¾ÃÂ´Ã‘â€šÃÂ²ÃÂµÃ‘â‚¬ÃÂ¶ÃÂ´ÃÂµÃÂ½ÃÂ¸Ã‘Â", sectionId: SosuzagramSettingsSection.ui.rawValue)
        }
    ))
    entries.append(SosuzagramSettingsEntry(
        section: SosuzagramSettingsSection.ui.rawValue,
        stableId: 10,
        sortId: 10,
        signature: "stories:\(hideStories)",
        buildItem: { presentationData, arguments in
            ItemListSwitchItem(presentationData: presentationData, systemStyle: sosuzagramSettingsSystemStyle(), title: "ÃÂ¡ÃÂºÃ‘â‚¬Ã‘â€¹ÃÂ²ÃÂ°Ã‘â€šÃ‘Å’ ÃÂ¸Ã‘ÂÃ‘â€šÃÂ¾Ã‘â‚¬ÃÂ¸ÃÂ¸ ÃÂ² Ã‘ÂÃÂ¿ÃÂ¸Ã‘ÂÃÂºÃÂµ Ã‘â€¡ÃÂ°Ã‘â€šÃÂ¾ÃÂ²", value: hideStories, sectionId: SosuzagramSettingsSection.ui.rawValue, style: .blocks, updated: { value in
                arguments.toggleHideStories(value)
            })
        }
    ))
    entries.append(SosuzagramSettingsEntry(
        section: SosuzagramSettingsSection.ui.rawValue,
        stableId: 11,
        sortId: 11,
        signature: "confirmcalls:\(confirmCalls)",
        buildItem: { presentationData, arguments in
            ItemListSwitchItem(presentationData: presentationData, systemStyle: sosuzagramSettingsSystemStyle(), title: "ÃÅ¸ÃÂ¾ÃÂ´Ã‘â€šÃÂ²ÃÂµÃ‘â‚¬ÃÂ¶ÃÂ´ÃÂ°Ã‘â€šÃ‘Å’ ÃÂ³ÃÂ¾ÃÂ»ÃÂ¾Ã‘ÂÃÂ¾ÃÂ²Ã‘â€¹ÃÂµ ÃÂ¸ ÃÂ²ÃÂ¸ÃÂ´ÃÂµÃÂ¾ÃÂ·ÃÂ²ÃÂ¾ÃÂ½ÃÂºÃÂ¸", value: confirmCalls, sectionId: SosuzagramSettingsSection.ui.rawValue, style: .blocks, updated: { value in
                arguments.toggleConfirmCalls(value)
            })
        }
    ))
    entries.append(SosuzagramSettingsEntry(
        section: SosuzagramSettingsSection.ui.rawValue,
        stableId: 12,
        sortId: 12,
        signature: "confirmvoice:\(confirmVoiceMessages)",
        buildItem: { presentationData, arguments in
            ItemListSwitchItem(presentationData: presentationData, systemStyle: sosuzagramSettingsSystemStyle(), title: "ÃÅ¸ÃÂ¾ÃÂ´Ã‘â€šÃÂ²ÃÂµÃ‘â‚¬ÃÂ¶ÃÂ´ÃÂ°Ã‘â€šÃ‘Å’ ÃÂ¾Ã‘â€šÃÂ¿Ã‘â‚¬ÃÂ°ÃÂ²ÃÂºÃ‘Æ’ ÃÂ³ÃÂ¾ÃÂ»ÃÂ¾Ã‘ÂÃÂ¾ÃÂ²Ã‘â€¹Ã‘â€¦", value: confirmVoiceMessages, sectionId: SosuzagramSettingsSection.ui.rawValue, style: .blocks, updated: { value in
                arguments.toggleConfirmVoiceMessages(value)
            })
        }
    ))
    entries.append(SosuzagramSettingsEntry(
        section: SosuzagramSettingsSection.ui.rawValue,
        stableId: 13,
        sortId: 13,
        signature: "hideshare:\(hideShareButton)",
        buildItem: { presentationData, arguments in
            ItemListSwitchItem(presentationData: presentationData, systemStyle: sosuzagramSettingsSystemStyle(), title: "ÃÂ¡ÃÂºÃ‘â‚¬Ã‘â€¹ÃÂ²ÃÂ°Ã‘â€šÃ‘Å’ ÃÂ±ÃÂ¾ÃÂºÃÂ¾ÃÂ²Ã‘Æ’Ã‘Å½ ÃÂºÃÂ½ÃÂ¾ÃÂ¿ÃÂºÃ‘Æ’ Ã‚Â«ÃÅ¸ÃÂ¾ÃÂ´ÃÂµÃÂ»ÃÂ¸Ã‘â€šÃ‘Å’Ã‘ÂÃ‘ÂÃ‚Â»", value: hideShareButton, sectionId: SosuzagramSettingsSection.ui.rawValue, style: .blocks, updated: { value in
                arguments.toggleHideShareButton(value)
            })
        }
    ))
    entries.append(SosuzagramSettingsEntry(
        section: SosuzagramSettingsSection.ui.rawValue,
        stableId: 14,
        sortId: 14,
        signature: "pollpreview:\(pollResultsBeforeVoting)",
        buildItem: { presentationData, arguments in
            ItemListSwitchItem(presentationData: presentationData, systemStyle: sosuzagramSettingsSystemStyle(), title: "ÃÅ¸ÃÂ¾ÃÂºÃÂ°ÃÂ·Ã‘â€¹ÃÂ²ÃÂ°Ã‘â€šÃ‘Å’ ÃÂ¸Ã‘â€šÃÂ¾ÃÂ³ÃÂ¸ ÃÂ¾ÃÂ¿Ã‘â‚¬ÃÂ¾Ã‘ÂÃÂ¾ÃÂ² ÃÂ´ÃÂ¾ ÃÂ³ÃÂ¾ÃÂ»ÃÂ¾Ã‘ÂÃÂ¾ÃÂ²ÃÂ°ÃÂ½ÃÂ¸Ã‘Â", value: pollResultsBeforeVoting, sectionId: SosuzagramSettingsSection.ui.rawValue, style: .blocks, updated: { value in
                arguments.togglePollResultsBeforeVoting(value)
            })
        }
    ))
    entries.append(SosuzagramSettingsEntry(
        section: SosuzagramSettingsSection.ui.rawValue,
        stableId: 15,
        sortId: 15,
        signature: "hidekeyboard:\(hideKeyboardOnScroll)",
        buildItem: { presentationData, arguments in
            ItemListSwitchItem(presentationData: presentationData, systemStyle: sosuzagramSettingsSystemStyle(), title: "ÃÂ¡ÃÂºÃ‘â‚¬Ã‘â€¹ÃÂ²ÃÂ°Ã‘â€šÃ‘Å’ ÃÂºÃÂ»ÃÂ°ÃÂ²ÃÂ¸ÃÂ°Ã‘â€šÃ‘Æ’Ã‘â‚¬Ã‘Æ’ ÃÂ¿Ã‘â‚¬ÃÂ¸ ÃÂ¿Ã‘â‚¬ÃÂ¾ÃÂºÃ‘â‚¬Ã‘Æ’Ã‘â€šÃÂºÃÂµ", value: hideKeyboardOnScroll, sectionId: SosuzagramSettingsSection.ui.rawValue, style: .blocks, updated: { value in
                arguments.toggleHideKeyboardOnScroll(value)
            })
        }
    ))
    entries.append(SosuzagramSettingsEntry(
        section: SosuzagramSettingsSection.ui.rawValue,
        stableId: 16,
        sortId: 16,
        signature: "hidesendas:\(hideSendAsButton)",
        buildItem: { presentationData, arguments in
            ItemListSwitchItem(presentationData: presentationData, systemStyle: sosuzagramSettingsSystemStyle(), title: "ÃÂ¡ÃÂºÃ‘â‚¬Ã‘â€¹Ã‘â€šÃ‘Å’ ÃÂºÃÂ½ÃÂ¾ÃÂ¿ÃÂºÃ‘Æ’ Ã‚Â«ÃÅ¾Ã‘â€šÃÂ¿Ã‘â‚¬ÃÂ°ÃÂ²ÃÂ¸Ã‘â€šÃ‘Å’ ÃÂºÃÂ°ÃÂº...Ã‚Â»", value: hideSendAsButton, sectionId: SosuzagramSettingsSection.ui.rawValue, style: .blocks, updated: { value in
                arguments.toggleHideSendAsButton(value)
            })
        }
    ))
    entries.append(SosuzagramSettingsEntry(
        section: SosuzagramSettingsSection.ui.rawValue,
        stableId: 17,
        sortId: 17,
        signature: "editedicon:\(replaceEditedWithIcon)",
        buildItem: { presentationData, arguments in
            ItemListSwitchItem(presentationData: presentationData, systemStyle: sosuzagramSettingsSystemStyle(), title: "Ãâ€”ÃÂ°ÃÂ¼ÃÂµÃÂ½Ã‘ÂÃ‘â€šÃ‘Å’ Ã‚Â«ÃÂ¸ÃÂ·ÃÂ¼ÃÂµÃÂ½ÃÂµÃÂ½ÃÂ¾Ã‚Â» ÃÂ¸ÃÂºÃÂ¾ÃÂ½ÃÂºÃÂ¾ÃÂ¹", value: replaceEditedWithIcon, sectionId: SosuzagramSettingsSection.ui.rawValue, style: .blocks, updated: { value in
                arguments.toggleReplaceEditedWithIcon(value)
            })
        }
    ))
    entries.append(SosuzagramSettingsEntry(
        section: SosuzagramSettingsSection.ui.rawValue,
        stableId: 18,
        sortId: 18,
        signature: "hidefloating:\(hideFloatingButton)",
        buildItem: { presentationData, arguments in
            ItemListSwitchItem(presentationData: presentationData, systemStyle: sosuzagramSettingsSystemStyle(), title: "ÃÂ¡ÃÂºÃ‘â‚¬Ã‘â€¹Ã‘â€šÃ‘Å’ ÃÂ¿ÃÂ»ÃÂ°ÃÂ²ÃÂ°Ã‘Å½Ã‘â€°Ã‘Æ’Ã‘Å½ ÃÂºÃÂ½ÃÂ¾ÃÂ¿ÃÂºÃ‘Æ’", value: hideFloatingButton, sectionId: SosuzagramSettingsSection.ui.rawValue, style: .blocks, updated: { value in
                arguments.toggleHideFloatingButton(value)
            })
        }
    ))
    entries.append(SosuzagramSettingsEntry(
        section: SosuzagramSettingsSection.ui.rawValue,
        stableId: 19,
        sortId: 19,
        signature: "hideallchatstab:\(hideAllChatsTab)",
        buildItem: { presentationData, arguments in
            ItemListSwitchItem(presentationData: presentationData, systemStyle: sosuzagramSettingsSystemStyle(), title: "ÃÂ¡ÃÂºÃ‘â‚¬Ã‘â€¹Ã‘â€šÃ‘Å’ ÃÂ²ÃÂºÃÂ»ÃÂ°ÃÂ´ÃÂºÃ‘Æ’ Ã‚Â«Ãâ€™Ã‘ÂÃÂµ Ã‘â€¡ÃÂ°Ã‘â€šÃ‘â€¹Ã‚Â»", value: hideAllChatsTab, sectionId: SosuzagramSettingsSection.ui.rawValue, style: .blocks, updated: { value in
                arguments.toggleHideAllChatsTab(value)
            })
        }
    ))
    entries.append(SosuzagramSettingsEntry(
        section: SosuzagramSettingsSection.ui.rawValue,
        stableId: 20,
        sortId: 20,
        signature: "hidegreetingsticker:\(hideGreetingSticker)",
        buildItem: { presentationData, arguments in
            ItemListSwitchItem(presentationData: presentationData, systemStyle: sosuzagramSettingsSystemStyle(), title: "ÃÂ¡ÃÂºÃ‘â‚¬Ã‘â€¹Ã‘â€šÃ‘Å’ ÃÂ¿Ã‘â‚¬ÃÂ¸ÃÂ²ÃÂµÃ‘â€šÃ‘ÂÃ‘â€šÃÂ²ÃÂµÃÂ½ÃÂ½Ã‘â€¹ÃÂ¹ Ã‘ÂÃ‘â€šÃÂ¸ÃÂºÃÂµÃ‘â‚¬", value: hideGreetingSticker, sectionId: SosuzagramSettingsSection.ui.rawValue, style: .blocks, updated: { value in
                arguments.toggleHideGreetingSticker(value)
            })
        }
    ))
    entries.append(SosuzagramSettingsEntry(
        section: SosuzagramSettingsSection.ui.rawValue,
        stableId: 21,
        sortId: 21,
        signature: "hidestickertimestamp:\(hideStickerTimestamp)",
        buildItem: { presentationData, arguments in
            ItemListSwitchItem(presentationData: presentationData, systemStyle: sosuzagramSettingsSystemStyle(), title: "ÃÂ¡ÃÂºÃ‘â‚¬Ã‘â€¹Ã‘â€šÃ‘Å’ ÃÂ²Ã‘â‚¬ÃÂµÃÂ¼Ã‘Â ÃÂ½ÃÂ° Ã‘ÂÃ‘â€šÃÂ¸ÃÂºÃÂµÃ‘â‚¬ÃÂ°Ã‘â€¦", value: hideStickerTimestamp, sectionId: SosuzagramSettingsSection.ui.rawValue, style: .blocks, updated: { value in
                arguments.toggleHideStickerTimestamp(value)
            })
        }
    ))
    entries.append(SosuzagramSettingsEntry(
        section: SosuzagramSettingsSection.ui.rawValue,
        stableId: 22,
        sortId: 22,
        signature: "compactcounts:\(disableCompactNumericCounts)",
        buildItem: { presentationData, arguments in
            ItemListSwitchItem(presentationData: presentationData, systemStyle: sosuzagramSettingsSystemStyle(), title: "ÃÂÃÂµ ÃÂ¾ÃÂºÃ‘â‚¬Ã‘Æ’ÃÂ³ÃÂ»Ã‘ÂÃ‘â€šÃ‘Å’ ÃÂ±ÃÂ¾ÃÂ»Ã‘Å’Ã‘Ë†ÃÂ¸ÃÂµ Ã‘â€¡ÃÂ¸Ã‘ÂÃÂ»ÃÂ°", value: disableCompactNumericCounts, sectionId: SosuzagramSettingsSection.ui.rawValue, style: .blocks, updated: { value in
                arguments.toggleDisableCompactNumericCounts(value)
            })
        }
    ))
    entries.append(SosuzagramSettingsEntry(
        section: SosuzagramSettingsSection.ui.rawValue,
        stableId: 23,
        sortId: 23,
        signature: "seconds:\(formatTimeWithSeconds)",
        buildItem: { presentationData, arguments in
            ItemListSwitchItem(presentationData: presentationData, systemStyle: sosuzagramSettingsSystemStyle(), title: "ÃÅ¸ÃÂ¾ÃÂºÃÂ°ÃÂ·Ã‘â€¹ÃÂ²ÃÂ°Ã‘â€šÃ‘Å’ ÃÂ²Ã‘â‚¬ÃÂµÃÂ¼Ã‘Â Ã‘Â Ã‘ÂÃÂµÃÂºÃ‘Æ’ÃÂ½ÃÂ´ÃÂ°ÃÂ¼ÃÂ¸", value: formatTimeWithSeconds, sectionId: SosuzagramSettingsSection.ui.rawValue, style: .blocks, updated: { value in
                arguments.toggleFormatTimeWithSeconds(value)
            })
        }
    ))
    entries.append(SosuzagramSettingsEntry(
        section: SosuzagramSettingsSection.ui.rawValue,
        stableId: 24,
        sortId: 24,
        signature: "commaaftermention:\(commaAfterMention)",
        buildItem: { presentationData, arguments in
            ItemListSwitchItem(presentationData: presentationData, systemStyle: sosuzagramSettingsSystemStyle(), title: "Ãâ€”ÃÂ°ÃÂ¿Ã‘ÂÃ‘â€šÃÂ°Ã‘Â ÃÂ¿ÃÂ¾Ã‘ÂÃÂ»ÃÂµ Ã‘Æ’ÃÂ¿ÃÂ¾ÃÂ¼ÃÂ¸ÃÂ½ÃÂ°ÃÂ½ÃÂ¸Ã‘Â", value: commaAfterMention, sectionId: SosuzagramSettingsSection.ui.rawValue, style: .blocks, updated: { value in
                arguments.toggleCommaAfterMention(value)
            })
        }
    ))
    entries.append(SosuzagramSettingsEntry(
        section: SosuzagramSettingsSection.ui.rawValue,
        stableId: 25,
        sortId: 25,
        signature: "onlineindicator:\(showOnlineIndicator)",
        buildItem: { presentationData, arguments in
            ItemListSwitchItem(presentationData: presentationData, systemStyle: sosuzagramSettingsSystemStyle(), title: "ÃÅ¸ÃÂ¾ÃÂºÃÂ°ÃÂ·Ã‘â€¹ÃÂ²ÃÂ°Ã‘â€šÃ‘Å’ ÃÂ¸ÃÂ½ÃÂ´ÃÂ¸ÃÂºÃÂ°Ã‘â€šÃÂ¾Ã‘â‚¬ ÃÂ¾ÃÂ½ÃÂ»ÃÂ°ÃÂ¹ÃÂ½ÃÂ°", value: showOnlineIndicator, sectionId: SosuzagramSettingsSection.ui.rawValue, style: .blocks, updated: { value in
                arguments.toggleShowOnlineIndicator(value)
            })
        }
    ))
    entries.append(SosuzagramSettingsEntry(
        section: SosuzagramSettingsSection.ui.rawValue,
        stableId: 26,
        sortId: 26,
        signature: "hidetail:\(hideMessageTail)",
        buildItem: { presentationData, arguments in
            ItemListSwitchItem(presentationData: presentationData, systemStyle: sosuzagramSettingsSystemStyle(), title: "ÃÂ£ÃÂ±Ã‘â‚¬ÃÂ°Ã‘â€šÃ‘Å’ Ã‘â€¦ÃÂ²ÃÂ¾Ã‘ÂÃ‘â€š Ã‘Æ’ Ã‘ÂÃÂ¾ÃÂ¾ÃÂ±Ã‘â€°ÃÂµÃÂ½ÃÂ¸ÃÂ¹", value: hideMessageTail, sectionId: SosuzagramSettingsSection.ui.rawValue, style: .blocks, updated: { value in
                arguments.toggleHideMessageTail(value)
            })
        }
    ))
    entries.append(SosuzagramSettingsEntry(
        section: SosuzagramSettingsSection.ui.rawValue,
        stableId: 27,
        sortId: 27,
        signature: "centertitle:\(centerChatListTitle)",
        buildItem: { presentationData, arguments in
            ItemListSwitchItem(presentationData: presentationData, systemStyle: sosuzagramSettingsSystemStyle(), title: "Ãâ€”ÃÂ°ÃÂ³ÃÂ¾ÃÂ»ÃÂ¾ÃÂ²ÃÂ¾ÃÂº ÃÂ¿ÃÂ¾ Ã‘â€ ÃÂµÃÂ½Ã‘â€šÃ‘â‚¬Ã‘Æ’", value: centerChatListTitle, sectionId: SosuzagramSettingsSection.ui.rawValue, style: .blocks, updated: { value in
                arguments.toggleCenterChatListTitle(value)
            })
        }
    ))
    entries.append(SosuzagramSettingsEntry(
        section: SosuzagramSettingsSection.ui.rawValue,
        stableId: 28,
        sortId: 28,
        signature: "yandexmaps:\(useYandexMaps)",
        buildItem: { presentationData, arguments in
            ItemListSwitchItem(presentationData: presentationData, systemStyle: sosuzagramSettingsSystemStyle(), title: "ÃËœÃ‘ÂÃÂ¿ÃÂ¾ÃÂ»Ã‘Å’ÃÂ·ÃÂ¾ÃÂ²ÃÂ°Ã‘â€šÃ‘Å’ ÃÂ¯ÃÂ½ÃÂ´ÃÂµÃÂºÃ‘Â ÃÅ¡ÃÂ°Ã‘â‚¬Ã‘â€šÃ‘â€¹", value: useYandexMaps, sectionId: SosuzagramSettingsSection.ui.rawValue, style: .blocks, updated: { value in
                arguments.toggleUseYandexMaps(value)
            })
        }
    ))
    entries.append(SosuzagramSettingsEntry(
        section: SosuzagramSettingsSection.ui.rawValue,
        stableId: 29,
        sortId: 29,
        signature: "hidechatliststatus:\(hideChatListStatus)",
        buildItem: { presentationData, arguments in
            ItemListSwitchItem(presentationData: presentationData, systemStyle: sosuzagramSettingsSystemStyle(), title: "ÃÂ¡ÃÂºÃ‘â‚¬Ã‘â€¹ÃÂ²ÃÂ°Ã‘â€šÃ‘Å’ Ã‘ÂÃ‘â€šÃÂ°Ã‘â€šÃ‘Æ’Ã‘Â ÃÂ² Ã‘ÂÃÂ¿ÃÂ¸Ã‘ÂÃÂºÃÂµ Ã‘â€¡ÃÂ°Ã‘â€šÃÂ¾ÃÂ²", value: hideChatListStatus, sectionId: SosuzagramSettingsSection.ui.rawValue, style: .blocks, updated: { value in
                arguments.toggleHideChatListStatus(value)
            })
        }
    ))
    entries.append(SosuzagramSettingsEntry(
        section: SosuzagramSettingsSection.ui.rawValue,
        stableId: 30,
        sortId: 30,
        signature: "hidearchive:\(hideArchiveFromList)",
        buildItem: { presentationData, arguments in
            ItemListSwitchItem(presentationData: presentationData, systemStyle: sosuzagramSettingsSystemStyle(), title: "ÃÂ¡ÃÂºÃ‘â‚¬Ã‘â€¹Ã‘â€šÃ‘Å’ ÃÂ°Ã‘â‚¬Ã‘â€¦ÃÂ¸ÃÂ² ÃÂ¸ÃÂ· Ã‘ÂÃÂ¿ÃÂ¸Ã‘ÂÃÂºÃÂ° Ã‘â€¡ÃÂ°Ã‘â€šÃÂ¾ÃÂ²", value: hideArchiveFromList, sectionId: SosuzagramSettingsSection.ui.rawValue, style: .blocks, updated: { value in
                arguments.toggleHideArchiveFromList(value)
            })
        }
    ))
    entries.append(SosuzagramSettingsEntry(
        section: SosuzagramSettingsSection.ui.rawValue,
        stableId: 31,
        sortId: 31,
        signature: "openarchivepull:\(openArchiveOnPull)",
        buildItem: { presentationData, arguments in
            ItemListSwitchItem(presentationData: presentationData, systemStyle: sosuzagramSettingsSystemStyle(), title: "ÃÅ¾Ã‘â€šÃÂºÃ‘â‚¬Ã‘â€¹ÃÂ²ÃÂ°Ã‘â€šÃ‘Å’ ÃÂ°Ã‘â‚¬Ã‘â€¦ÃÂ¸ÃÂ² Ã‘ÂÃÂ²ÃÂ°ÃÂ¹ÃÂ¿ÃÂ¾ÃÂ¼ ÃÂ²ÃÂ½ÃÂ¸ÃÂ·", value: openArchiveOnPull, sectionId: SosuzagramSettingsSection.ui.rawValue, style: .blocks, updated: { value in
                arguments.toggleOpenArchiveOnPull(value)
            })
        }
    ))
    entries.append(SosuzagramSettingsEntry(
        section: SosuzagramSettingsSection.ui.rawValue,
        stableId: 32,
        sortId: 32,
        signature: "disablearchivereturn:\(disableArchiveReturnGesture)",
        buildItem: { presentationData, arguments in
            ItemListSwitchItem(presentationData: presentationData, systemStyle: sosuzagramSettingsSystemStyle(), title: "ÃÅ¾Ã‘â€šÃÂºÃÂ»Ã‘Å½Ã‘â€¡ÃÂ¸Ã‘â€šÃ‘Å’ ÃÂ²ÃÂ¾ÃÂ·ÃÂ²Ã‘â‚¬ÃÂ°Ã‘â€š ÃÂ¸ÃÂ· ÃÂ°Ã‘â‚¬Ã‘â€¦ÃÂ¸ÃÂ²ÃÂ° Ã‘ÂÃÂ²ÃÂ°ÃÂ¹ÃÂ¿ÃÂ¾ÃÂ¼", value: disableArchiveReturnGesture, sectionId: SosuzagramSettingsSection.ui.rawValue, style: .blocks, updated: { value in
                arguments.toggleDisableArchiveReturnGesture(value)
            })
        }
    ))
    entries.append(SosuzagramSettingsEntry(
        section: SosuzagramSettingsSection.ui.rawValue,
        stableId: 33,
        sortId: 33,
        signature: "relativeonline:\(relativeOnlineTime)",
        buildItem: { presentationData, arguments in
            ItemListSwitchItem(presentationData: presentationData, systemStyle: sosuzagramSettingsSystemStyle(), title: "ÃÅ¾Ã‘â€šÃÂ½ÃÂ¾Ã‘ÂÃÂ¸Ã‘â€šÃÂµÃÂ»Ã‘Å’ÃÂ½ÃÂ¾ÃÂµ ÃÂ²Ã‘â‚¬ÃÂµÃÂ¼Ã‘Â ÃÂ¾ÃÂ½ÃÂ»ÃÂ°ÃÂ¹ÃÂ½ÃÂ°", value: relativeOnlineTime, sectionId: SosuzagramSettingsSection.ui.rawValue, style: .blocks, updated: { value in
                arguments.toggleRelativeOnlineTime(value)
            })
        }
    ))
    entries.append(SosuzagramSettingsEntry(
        section: SosuzagramSettingsSection.ui.rawValue,
        stableId: 34,
        sortId: 34,
        signature: "hidephone:\(hidePhoneNumber)",
        buildItem: { presentationData, arguments in
            ItemListSwitchItem(presentationData: presentationData, systemStyle: sosuzagramSettingsSystemStyle(), title: "ÃÂ¡ÃÂºÃ‘â‚¬Ã‘â€¹ÃÂ²ÃÂ°Ã‘â€šÃ‘Å’ ÃÂ½ÃÂ¾ÃÂ¼ÃÂµÃ‘â‚¬ Ã‘â€šÃÂµÃÂ»ÃÂµÃ‘â€žÃÂ¾ÃÂ½ÃÂ°", value: hidePhoneNumber, sectionId: SosuzagramSettingsSection.ui.rawValue, style: .blocks, updated: { value in
                arguments.toggleHidePhoneNumber(value)
            })
        }
    ))
    entries.append(SosuzagramSettingsEntry(
        section: SosuzagramSettingsSection.ui.rawValue,
        stableId: 35,
        sortId: 35,
        signature: "showiddc:\(showIdDc)",
        buildItem: { presentationData, arguments in
            ItemListSwitchItem(presentationData: presentationData, systemStyle: sosuzagramSettingsSystemStyle(), title: "ÃÅ¸ÃÂ¾ÃÂºÃÂ°ÃÂ·Ã‘â€¹ÃÂ²ÃÂ°Ã‘â€šÃ‘Å’ ID / DC", value: showIdDc, sectionId: SosuzagramSettingsSection.ui.rawValue, style: .blocks, updated: { value in
                arguments.toggleShowIdDc(value)
            })
        }
    ))
    entries.append(SosuzagramSettingsEntry(
        section: SosuzagramSettingsSection.ui.rawValue,
        stableId: 36,
        sortId: 36,
        signature: "zalgo:\(filterZalgo)",
        buildItem: { presentationData, arguments in
            ItemListSwitchItem(presentationData: presentationData, systemStyle: sosuzagramSettingsSystemStyle(), title: "ÃÂ¤ÃÂ¸ÃÂ»Ã‘Å’Ã‘â€šÃ‘â‚¬ Zalgo", value: filterZalgo, sectionId: SosuzagramSettingsSection.ui.rawValue, style: .blocks, updated: { value in
                arguments.toggleFilterZalgo(value)
            })
        }
    ))
    entries.append(SosuzagramSettingsEntry(
        section: SosuzagramSettingsSection.ui.rawValue,
        stableId: 37,
        sortId: 37,
        signature: "appvibration:\(appVibration)",
        buildItem: { presentationData, arguments in
            ItemListSwitchItem(presentationData: presentationData, systemStyle: sosuzagramSettingsSystemStyle(), title: "Ãâ€™ÃÂ¸ÃÂ±Ã‘â‚¬ÃÂ°Ã‘â€ ÃÂ¸Ã‘Â ÃÂ¿Ã‘â‚¬ÃÂ¸ÃÂ»ÃÂ¾ÃÂ¶ÃÂµÃÂ½ÃÂ¸Ã‘Â", value: appVibration, sectionId: SosuzagramSettingsSection.ui.rawValue, style: .blocks, updated: { value in
                arguments.toggleAppVibration(value)
            })
        }
    ))
    entries.append(SosuzagramSettingsEntry(
        section: SosuzagramSettingsSection.ui.rawValue,
        stableId: 237,
        sortId: 237,
        signature: "downloadacceleration:\(downloadAcceleration)",
        buildItem: { presentationData, arguments in
            ItemListDisclosureItem(
                presentationData: presentationData,
                systemStyle: sosuzagramSettingsSystemStyle(),
                title: "Ð£ÑÐºÐ¾Ñ€ÐµÐ½Ð¸Ðµ Ð·Ð°Ð³Ñ€ÑƒÐ·ÐºÐ¸",
                label: sosuzagramDownloadAccelerationLabel(downloadAcceleration),
                additionalDetailLabel: "Ð£Ð²ÐµÐ»Ð¸Ñ‡Ð¸Ð²Ð°ÐµÑ‚ Ñ‡Ð¸ÑÐ»Ð¾ Ð¿Ð°Ñ€Ð°Ð»Ð»ÐµÐ»ÑŒÐ½Ñ‹Ñ… Ñ‡Ð°ÑÑ‚ÐµÐ¹ Ð¿Ñ€Ð¸ ÑÐºÐ°Ñ‡Ð¸Ð²Ð°Ð½Ð¸Ð¸ Ñ„Ð°Ð¹Ð»Ð¾Ð² Ð¸ Ð¼ÐµÐ´Ð¸Ð°.",
                sectionId: SosuzagramSettingsSection.ui.rawValue,
                style: .blocks,
                disclosureStyle: .arrow,
                action: {
                    arguments.openDownloadAcceleration()
                }
            )
        }
    ))
    entries.append(SosuzagramSettingsEntry(
        section: SosuzagramSettingsSection.ui.rawValue,
        stableId: 238,
        sortId: 238,
        signature: "uploadacceleration:\(uploadAcceleration)",
        buildItem: { presentationData, arguments in
            ItemListSwitchItem(presentationData: presentationData, systemStyle: sosuzagramSettingsSystemStyle(), title: "Ð£ÑÐºÐ¾Ñ€ÐµÐ½Ð¸Ðµ Ð¾Ñ‚Ð¿Ñ€Ð°Ð²ÐºÐ¸", value: uploadAcceleration, sectionId: SosuzagramSettingsSection.ui.rawValue, style: .blocks, updated: { value in
                arguments.toggleUploadAcceleration(value)
            })
        }
    ))
    entries.append(SosuzagramSettingsEntry(
        section: SosuzagramSettingsSection.ui.rawValue,
        stableId: 241,
        sortId: 241,
        signature: "voicerecognitionlocale:\(voiceRecognitionLocale)",
        buildItem: { presentationData, arguments in
            ItemListDisclosureItem(
                presentationData: presentationData,
                systemStyle: sosuzagramSettingsSystemStyle(),
                title: "Ð¯Ð·Ñ‹Ðº Ñ€Ð°ÑÐ¿Ð¾Ð·Ð½Ð°Ð²Ð°Ð½Ð¸Ñ",
                label: sosuzagramVoiceRecognitionLocaleLabel(voiceRecognitionLocale),
                additionalDetailLabel: "Ð˜ÑÐ¿Ð¾Ð»ÑŒÐ·ÑƒÐµÑ‚ÑÑ Ð´Ð»Ñ Ð»Ð¾ÐºÐ°Ð»ÑŒÐ½Ð¾Ð¹ Ñ‚Ñ€Ð°Ð½ÑÐºÑ€Ð¸Ð±Ð°Ñ†Ð¸Ð¸ Ð³Ð¾Ð»Ð¾ÑÐ¾Ð²Ñ‹Ñ… Ð¸ Ð²Ð¸Ð´ÐµÐ¾ÑÐ¾Ð¾Ð±Ñ‰ÐµÐ½Ð¸Ð¹.",
                sectionId: SosuzagramSettingsSection.ui.rawValue,
                style: .blocks,
                disclosureStyle: .arrow,
                action: {
                    arguments.openVoiceRecognitionLocale()
                }
            )
        }
    ))
    entries.append(SosuzagramSettingsEntry(
        section: SosuzagramSettingsSection.ui.rawValue,
        stableId: 242,
        sortId: 242,
        signature: "voiceondevice:\(voiceRecognitionOnDevice)",
        buildItem: { presentationData, arguments in
            ItemListSwitchItem(presentationData: presentationData, systemStyle: sosuzagramSettingsSystemStyle(), title: "Ð˜ÑÐ¿Ð¾Ð»ÑŒÐ·Ð¾Ð²Ð°Ñ‚ÑŒ Ð˜Ð˜ Ð´Ð»Ñ Ð¿Ð¾ÑÑ‚Ð¾Ð±Ñ€Ð°Ð±Ð¾Ñ‚ÐºÐ¸", value: voiceRecognitionOnDevice, sectionId: SosuzagramSettingsSection.ui.rawValue, style: .blocks, updated: { value in
                arguments.toggleVoiceRecognitionOnDevice(value)
            })
        }
    ))
    entries.append(SosuzagramSettingsEntry(
        section: SosuzagramSettingsSection.ui.rawValue,
        stableId: 38,
        sortId: 38,
        signature: "hidereactions:\(hideReactions)",
        buildItem: { presentationData, arguments in
            ItemListSwitchItem(presentationData: presentationData, systemStyle: sosuzagramSettingsSystemStyle(), title: "ÃÂ¡ÃÂºÃ‘â‚¬Ã‘â€¹Ã‘â€šÃ‘Å’ Ã‘â‚¬ÃÂµÃÂ°ÃÂºÃ‘â€ ÃÂ¸ÃÂ¸", value: hideReactions, sectionId: SosuzagramSettingsSection.ui.rawValue, style: .blocks, updated: { value in
                arguments.toggleHideReactions(value)
            })
        }
    ))
    entries.append(SosuzagramSettingsEntry(
        section: SosuzagramSettingsSection.ui.rawValue,
        stableId: 39,
        sortId: 39,
        signature: "doubletapincoming:\(incomingDoubleTapAction.rawValue)",
        buildItem: { presentationData, arguments in
            ItemListDisclosureItem(
                presentationData: presentationData,
                systemStyle: sosuzagramSettingsSystemStyle(),
                title: "Ãâ€ÃÂ²ÃÂ¾ÃÂ¹ÃÂ½ÃÂ¾ÃÂ¹ Ã‘â€šÃÂ°ÃÂ¿ ÃÂ¿ÃÂ¾ ÃÂ²Ã‘â€¦ÃÂ¾ÃÂ´Ã‘ÂÃ‘â€°ÃÂ¸ÃÂ¼",
                label: sosuzagramDoubleTapActionLabel(incomingDoubleTapAction),
                additionalDetailLabel: "Ãâ€™Ã‘â€¹ÃÂ±ÃÂ¸Ã‘â‚¬ÃÂ°ÃÂµÃ‘â€š ÃÂ´ÃÂµÃÂ¹Ã‘ÂÃ‘â€šÃÂ²ÃÂ¸ÃÂµ ÃÂ¿ÃÂ¾ ÃÂ´ÃÂ²ÃÂ¾ÃÂ¹ÃÂ½ÃÂ¾ÃÂ¼Ã‘Æ’ ÃÂ½ÃÂ°ÃÂ¶ÃÂ°Ã‘â€šÃÂ¸Ã‘Å½ ÃÂ½ÃÂ° ÃÂ²Ã‘â€¦ÃÂ¾ÃÂ´Ã‘ÂÃ‘â€°ÃÂµÃÂµ Ã‘ÂÃÂ¾ÃÂ¾ÃÂ±Ã‘â€°ÃÂµÃÂ½ÃÂ¸ÃÂµ.",
                sectionId: SosuzagramSettingsSection.ui.rawValue,
                style: .blocks,
                disclosureStyle: .arrow,
                action: {
                    arguments.openIncomingDoubleTapAction()
                }
            )
        }
    ))
    entries.append(SosuzagramSettingsEntry(
        section: SosuzagramSettingsSection.ui.rawValue,
        stableId: 40,
        sortId: 40,
        signature: "doubletapoutgoing:\(outgoingDoubleTapAction.rawValue)",
        buildItem: { presentationData, arguments in
            ItemListDisclosureItem(
                presentationData: presentationData,
                systemStyle: sosuzagramSettingsSystemStyle(),
                title: "Ãâ€ÃÂ²ÃÂ¾ÃÂ¹ÃÂ½ÃÂ¾ÃÂ¹ Ã‘â€šÃÂ°ÃÂ¿ ÃÂ¿ÃÂ¾ ÃÂ¸Ã‘ÂÃ‘â€¦ÃÂ¾ÃÂ´Ã‘ÂÃ‘â€°ÃÂ¸ÃÂ¼",
                label: sosuzagramDoubleTapActionLabel(outgoingDoubleTapAction),
                additionalDetailLabel: "Ãâ€™Ã‘â€¹ÃÂ±ÃÂ¸Ã‘â‚¬ÃÂ°ÃÂµÃ‘â€š ÃÂ´ÃÂµÃÂ¹Ã‘ÂÃ‘â€šÃÂ²ÃÂ¸ÃÂµ ÃÂ¿ÃÂ¾ ÃÂ´ÃÂ²ÃÂ¾ÃÂ¹ÃÂ½ÃÂ¾ÃÂ¼Ã‘Æ’ ÃÂ½ÃÂ°ÃÂ¶ÃÂ°Ã‘â€šÃÂ¸Ã‘Å½ ÃÂ½ÃÂ° ÃÂ¸Ã‘ÂÃ‘â€¦ÃÂ¾ÃÂ´Ã‘ÂÃ‘â€°ÃÂµÃÂµ Ã‘ÂÃÂ¾ÃÂ¾ÃÂ±Ã‘â€°ÃÂµÃÂ½ÃÂ¸ÃÂµ.",
                sectionId: SosuzagramSettingsSection.ui.rawValue,
                style: .blocks,
                disclosureStyle: .arrow,
                action: {
                    arguments.openOutgoingDoubleTapAction()
                }
            )
        }
    ))
    entries.append(SosuzagramSettingsEntry(
        section: SosuzagramSettingsSection.ui.rawValue,
        stableId: 41,
        sortId: 41,
        signature: "stickersize:\(stickerSizePreset)",
        buildItem: { presentationData, arguments in
            ItemListDisclosureItem(
                presentationData: presentationData,
                systemStyle: sosuzagramSettingsSystemStyle(),
                title: "ÃÂ ÃÂ°ÃÂ·ÃÂ¼ÃÂµÃ‘â‚¬ Ã‘ÂÃ‘â€šÃÂ¸ÃÂºÃÂµÃ‘â‚¬ÃÂ¾ÃÂ²",
                label: sosuzagramStickerSizePresetLabel(stickerSizePreset),
                additionalDetailLabel: "ÃÅ“ÃÂµÃÂ½Ã‘ÂÃÂµÃ‘â€š ÃÂ¼ÃÂ°Ã‘ÂÃ‘Ë†Ã‘â€šÃÂ°ÃÂ± ÃÂ¾ÃÂ±Ã‘â€¹Ã‘â€¡ÃÂ½Ã‘â€¹Ã‘â€¦ ÃÂ¸ ÃÂ°ÃÂ½ÃÂ¸ÃÂ¼ÃÂ¸Ã‘â‚¬ÃÂ¾ÃÂ²ÃÂ°ÃÂ½ÃÂ½Ã‘â€¹Ã‘â€¦ Ã‘ÂÃ‘â€šÃÂ¸ÃÂºÃÂµÃ‘â‚¬ÃÂ¾ÃÂ² ÃÂ² Ã‘â€¡ÃÂ°Ã‘â€šÃÂµ.",
                sectionId: SosuzagramSettingsSection.ui.rawValue,
                style: .blocks,
                disclosureStyle: .arrow,
                action: {
                    arguments.openStickerSizePreset()
                }
            )
        }
    ))
    entries.append(SosuzagramSettingsEntry(
        section: SosuzagramSettingsSection.ui.rawValue,
        stableId: 42,
        sortId: 42,
        signature: "alwayssendhd:\(alwaysSendHd)",
        buildItem: { presentationData, arguments in
            ItemListSwitchItem(presentationData: presentationData, systemStyle: sosuzagramSettingsSystemStyle(), title: "Ãâ€™Ã‘ÂÃÂµÃÂ³ÃÂ´ÃÂ° ÃÂ¾Ã‘â€šÃÂ¿Ã‘â‚¬ÃÂ°ÃÂ²ÃÂ»Ã‘ÂÃ‘â€šÃ‘Å’ Ã‘â€žÃÂ¾Ã‘â€šÃÂ¾ ÃÂ² HD", value: alwaysSendHd, sectionId: SosuzagramSettingsSection.ui.rawValue, style: .blocks, updated: { value in
                arguments.toggleAlwaysSendHd(value)
            })
        }
    ))
    entries.append(SosuzagramSettingsEntry(
        section: SosuzagramSettingsSection.ui.rawValue,
        stableId: 43,
        sortId: 43,
        signature: "preferoriginalquality:\(preferOriginalQuality)",
        buildItem: { presentationData, arguments in
            ItemListSwitchItem(presentationData: presentationData, systemStyle: sosuzagramSettingsSystemStyle(), title: "ÃÅ¸Ã‘â‚¬ÃÂµÃÂ´ÃÂ¿ÃÂ¾Ã‘â€¡ÃÂ¸Ã‘â€šÃÂ°Ã‘â€šÃ‘Å’ original quality", value: preferOriginalQuality, sectionId: SosuzagramSettingsSection.ui.rawValue, style: .blocks, updated: { value in
                arguments.togglePreferOriginalQuality(value)
            })
        }
    ))
    entries.append(SosuzagramSettingsEntry(
        section: SosuzagramSettingsSection.ui.rawValue,
        stableId: 44,
        sortId: 44,
        signature: "hidephotocounter:\(hidePhotoCounter)",
        buildItem: { presentationData, arguments in
            ItemListSwitchItem(presentationData: presentationData, systemStyle: sosuzagramSettingsSystemStyle(), title: "ÃÂ¡ÃÂºÃ‘â‚¬Ã‘â€¹Ã‘â€šÃ‘Å’ Ã‘ÂÃ‘â€¡Ã‘â€˜Ã‘â€šÃ‘â€¡ÃÂ¸ÃÂº Ã‘â€žÃÂ¾Ã‘â€šÃÂ¾", value: hidePhotoCounter, sectionId: SosuzagramSettingsSection.ui.rawValue, style: .blocks, updated: { value in
                arguments.toggleHidePhotoCounter(value)
            })
        }
    ))
    entries.append(SosuzagramSettingsEntry(
        section: SosuzagramSettingsSection.ui.rawValue,
        stableId: 45,
        sortId: 45,
        signature: "hidecameratile:\(hideCameraTile)",
        buildItem: { presentationData, arguments in
            ItemListSwitchItem(presentationData: presentationData, systemStyle: sosuzagramSettingsSystemStyle(), title: "ÃÂ¡ÃÂºÃ‘â‚¬Ã‘â€¹Ã‘â€šÃ‘Å’ camera tile", value: hideCameraTile, sectionId: SosuzagramSettingsSection.ui.rawValue, style: .blocks, updated: { value in
                arguments.toggleHideCameraTile(value)
            })
        }
    ))
    entries.append(SosuzagramSettingsEntry(
        section: SosuzagramSettingsSection.ui.rawValue,
        stableId: 244,
        sortId: 46,
        signature: "advancedcamerasettings:\(advancedCameraSettings)",
        buildItem: { presentationData, arguments in
            ItemListSwitchItem(
                presentationData: presentationData,
                systemStyle: sosuzagramSettingsSystemStyle(),
                title: "Ð Ð°ÑÑˆÐ¸Ñ€ÐµÐ½Ð½Ñ‹Ðµ Ð½Ð°ÑÑ‚Ñ€Ð¾Ð¹ÐºÐ¸ ÐºÐ°Ð¼ÐµÑ€Ñ‹",
                text: "Ð’ÐºÐ»ÑŽÑ‡Ð°ÐµÑ‚ Ñ€Ð°ÑÑˆÐ¸Ñ€ÐµÐ½Ð½Ñ‹Ð¹ Ð²Ñ‹Ð±Ð¾Ñ€ ÑÑ‚Ð°Ñ€Ñ‚Ð¾Ð²Ð¾Ð¹ ÐºÐ°Ð¼ÐµÑ€Ñ‹, Ñ€ÐµÐ¶Ð¸Ð¼Ð° Ð²Ð¸Ð´ÐµÐ¾ÑÐ¾Ð¾Ð±Ñ‰ÐµÐ½Ð¸Ð¹, ÑÑ‚Ð°Ñ‚Ð¸Ñ‡Ð½Ð¾Ð³Ð¾ Ð·ÑƒÐ¼Ð° Ð¸ Ð·Ð°Ð¿Ð¾Ð¼Ð¸Ð½Ð°Ð½Ð¸Ñ Ð¿Ð¾ÑÐ»ÐµÐ´Ð½ÐµÐ¹ ÐºÐ°Ð¼ÐµÑ€Ñ‹.",
                value: advancedCameraSettings,
                sectionId: SosuzagramSettingsSection.ui.rawValue,
                style: .blocks,
                updated: { value in
                    arguments.toggleAdvancedCameraSettings(value)
                }
            )
        }
    ))
    entries.append(SosuzagramSettingsEntry(
        section: SosuzagramSettingsSection.ui.rawValue,
        stableId: 246,
        sortId: 47,
        signature: "soundwithvolumebuttons:\(enableSoundWithVolumeButtons)",
        buildItem: { presentationData, arguments in
            ItemListSwitchItem(presentationData: presentationData, systemStyle: sosuzagramSettingsSystemStyle(), title: "Ð’ÐºÐ»ÑŽÑ‡ÐµÐ½Ð¸Ðµ Ð·Ð²ÑƒÐºÐ° ÐºÐ½Ð¾Ð¿ÐºÐ°Ð¼Ð¸ Ð³Ñ€Ð¾Ð¼ÐºÐ¾ÑÑ‚Ð¸", text: "Ð Ð°Ð·Ñ€ÐµÑˆÐ°ÐµÑ‚ Ð±Ñ‹ÑÑ‚Ñ€Ð¾ Ð²ÐºÐ»ÑŽÑ‡Ð°Ñ‚ÑŒ Ð·Ð²ÑƒÐº Ð³Ð¾Ð»Ð¾ÑÐ¾Ð²Ñ‹Ñ… Ð¸ ÐºÑ€ÑƒÐ¶ÐºÐ¾Ð² Ð°Ð¿Ð¿Ð°Ñ€Ð°Ñ‚Ð½Ñ‹Ð¼Ð¸ ÐºÐ½Ð¾Ð¿ÐºÐ°Ð¼Ð¸ Ð³Ñ€Ð¾Ð¼ÐºÐ¾ÑÑ‚Ð¸.", value: enableSoundWithVolumeButtons, sectionId: SosuzagramSettingsSection.ui.rawValue, style: .blocks, updated: { value in
                arguments.toggleEnableSoundWithVolumeButtons(value)
            })
        }
    ))
    entries.append(SosuzagramSettingsEntry(
        section: SosuzagramSettingsSection.ui.rawValue,
        stableId: 247,
        sortId: 48,
        signature: "cameratype:\(cameraType)",
        buildItem: { presentationData, arguments in
            ItemListDisclosureItem(
                presentationData: presentationData,
                systemStyle: sosuzagramSettingsSystemStyle(),
                title: "Ð¢Ð¸Ð¿ ÐºÐ°Ð¼ÐµÑ€Ñ‹",
                label: sosuzagramCameraTypeLabel(cameraType),
                additionalDetailLabel: "ÐžÐ¿Ñ€ÐµÐ´ÐµÐ»ÑÐµÑ‚ ÑÑ‚Ð°Ñ€Ñ‚Ð¾Ð²Ñ‹Ð¹ Ñ€ÐµÐ¶Ð¸Ð¼ ÐºÐ°Ð¼ÐµÑ€Ñ‹: Ð¾Ð±Ñ‹Ñ‡Ð½Ð°Ñ Ð¸Ð»Ð¸ dual-camera, ÐµÑÐ»Ð¸ ÑƒÑÑ‚Ñ€Ð¾Ð¹ÑÑ‚Ð²Ð¾ ÐµÑ‘ Ð¿Ð¾Ð´Ð´ÐµÑ€Ð¶Ð¸Ð²Ð°ÐµÑ‚.",
                sectionId: SosuzagramSettingsSection.ui.rawValue,
                style: .blocks,
                disclosureStyle: .arrow,
                action: {
                    arguments.openCameraType()
                }
            )
        }
    ))
    entries.append(SosuzagramSettingsEntry(
        section: SosuzagramSettingsSection.ui.rawValue,
        stableId: 245,
        sortId: 49,
        signature: "pipswipe:\(pictureInPictureSwipe)",
        buildItem: { presentationData, arguments in
            ItemListSwitchItem(presentationData: presentationData, systemStyle: sosuzagramSettingsSystemStyle(), title: "ÐšÐ°Ñ€Ñ‚Ð¸Ð½ÐºÐ°-ÐºÐ°Ñ€Ñ‚Ð¸Ð½ÐºÐµ Ð¿Ð¾ ÑÐ²Ð°Ð¹Ð¿Ñƒ", value: pictureInPictureSwipe, sectionId: SosuzagramSettingsSection.ui.rawValue, style: .blocks, updated: { value in
                arguments.togglePictureInPictureSwipe(value)
            })
        }
    ))
    entries.append(SosuzagramSettingsEntry(
        section: SosuzagramSettingsSection.ui.rawValue,
        stableId: 46,
        sortId: 50,
        signature: "staticzoom:\(staticZoom)",
        buildItem: { presentationData, arguments in
            ItemListSwitchItem(presentationData: presentationData, systemStyle: sosuzagramSettingsSystemStyle(), title: "ÃÂ¡Ã‘â€šÃÂ°Ã‘â€šÃÂ¸Ã‘â€¡ÃÂµÃ‘ÂÃÂºÃÂ¸ÃÂ¹ zoom ÃÂºÃÂ°ÃÂ¼ÃÂµÃ‘â‚¬Ã‘â€¹", value: staticZoom, sectionId: SosuzagramSettingsSection.ui.rawValue, style: .blocks, updated: { value in
                arguments.toggleStaticZoom(value)
            })
        }
    ))
    entries.append(SosuzagramSettingsEntry(
        section: SosuzagramSettingsSection.ui.rawValue,
        stableId: 47,
        sortId: 51,
        signature: "rememberlastcamera:\(rememberLastCamera)",
        buildItem: { presentationData, arguments in
            ItemListSwitchItem(presentationData: presentationData, systemStyle: sosuzagramSettingsSystemStyle(), title: "Ãâ€”ÃÂ°ÃÂ¿ÃÂ¾ÃÂ¼ÃÂ¸ÃÂ½ÃÂ°Ã‘â€šÃ‘Å’ ÃÂ¿ÃÂ¾Ã‘ÂÃÂ»ÃÂµÃÂ´ÃÂ½Ã‘Å½Ã‘Å½ ÃÂºÃÂ°ÃÂ¼ÃÂµÃ‘â‚¬Ã‘Æ’", value: rememberLastCamera, sectionId: SosuzagramSettingsSection.ui.rawValue, style: .blocks, updated: { value in
                arguments.toggleRememberLastCamera(value)
            })
        }
    ))
    entries.append(SosuzagramSettingsEntry(
        section: SosuzagramSettingsSection.ui.rawValue,
        stableId: 48,
        sortId: 52,
        signature: "videomessagecamera:\(videoMessageCamera)",
        buildItem: { presentationData, arguments in
            ItemListDisclosureItem(
                presentationData: presentationData,
                systemStyle: sosuzagramSettingsSystemStyle(),
                title: "ÃÅ¡ÃÂ°ÃÂ¼ÃÂµÃ‘â‚¬ÃÂ° ÃÂ² ÃÂ²ÃÂ¸ÃÂ´ÃÂµÃÂ¾Ã‘ÂÃÂ¾ÃÂ¾ÃÂ±Ã‘â€°ÃÂµÃÂ½ÃÂ¸Ã‘ÂÃ‘â€¦",
                label: sosuzagramVideoMessageCameraLabel(videoMessageCamera),
                additionalDetailLabel: "Ãâ€™Ã‘â€¹ÃÂ±ÃÂ¸Ã‘â‚¬ÃÂ°ÃÂµÃ‘â€š Ã‘ÂÃ‘â€šÃÂ°Ã‘â‚¬Ã‘â€šÃÂ¾ÃÂ²Ã‘Æ’Ã‘Å½ ÃÂºÃÂ°ÃÂ¼ÃÂµÃ‘â‚¬Ã‘Æ’ ÃÂ´ÃÂ»Ã‘Â ÃÂºÃ‘â‚¬Ã‘Æ’ÃÂ¶ÃÂºÃÂ¾ÃÂ² ÃÂ¸ Ã‘ÂÃÂºÃ‘â‚¬ÃÂ°ÃÂ½ÃÂ° ÃÂºÃÂ°ÃÂ¼ÃÂµÃ‘â‚¬Ã‘â€¹.",
                sectionId: SosuzagramSettingsSection.ui.rawValue,
                style: .blocks,
                disclosureStyle: .arrow,
                action: {
                    arguments.openVideoMessageCamera()
                }
            )
        }
    ))
    entries.append(SosuzagramSettingsEntry(
        section: SosuzagramSettingsSection.ui.rawValue,
        stableId: 49,
        sortId: 53,
        signature: "doubletapseek:\(doubleTapSeek)",
        buildItem: { presentationData, arguments in
            ItemListSwitchItem(presentationData: presentationData, systemStyle: sosuzagramSettingsSystemStyle(), title: "Double tap seek", value: doubleTapSeek, sectionId: SosuzagramSettingsSection.ui.rawValue, style: .blocks, updated: { value in
                arguments.toggleDoubleTapSeek(value)
            })
        }
    ))
    entries.append(SosuzagramSettingsEntry(
        section: SosuzagramSettingsSection.ui.rawValue,
        stableId: 50,
        sortId: 54,
        signature: "infiniterecentstickers:\(infiniteRecentStickers)",
        buildItem: { presentationData, arguments in
            ItemListSwitchItem(presentationData: presentationData, systemStyle: sosuzagramSettingsSystemStyle(), title: "Ãâ€˜ÃÂµÃ‘ÂÃÂºÃÂ¾ÃÂ½ÃÂµÃ‘â€¡ÃÂ½Ã‘â€¹ÃÂµ recent stickers", value: infiniteRecentStickers, sectionId: SosuzagramSettingsSection.ui.rawValue, style: .blocks, updated: { value in
                arguments.toggleInfiniteRecentStickers(value)
            })
        }
    ))
    entries.append(SosuzagramSettingsEntry(
        section: SosuzagramSettingsSection.ui.rawValue,
        stableId: 51,
        sortId: 55,
        signature: "lowerbutton:\(lowerNavigationButton)",
        buildItem: { presentationData, arguments in
            ItemListSwitchItem(presentationData: presentationData, systemStyle: sosuzagramSettingsSystemStyle(), title: "ÐÐ¸Ð¶Ð½ÑÑ ÐºÐ½Ð¾Ð¿ÐºÐ° Ð½Ð°Ð²Ð¸Ð³Ð°Ñ†Ð¸Ð¸", value: lowerNavigationButton, sectionId: SosuzagramSettingsSection.ui.rawValue, style: .blocks, updated: { value in
                arguments.toggleLowerNavigationButton(value)
            })
        }
    ))
    entries.append(SosuzagramSettingsEntry(
        section: SosuzagramSettingsSection.ui.rawValue,
        stableId: 52,
        sortId: 56,
        signature: "replystyle:\(replyStyle)",
        buildItem: { presentationData, arguments in
            ItemListDisclosureItem(
                presentationData: presentationData,
                systemStyle: sosuzagramSettingsSystemStyle(),
                title: "ÐžÑ‚Ð²ÐµÑ‚Ñ‹",
                label: sosuzagramReplyStyleLabel(replyStyle),
                additionalDetailLabel: "ÐœÐµÐ½ÑÐµÑ‚ Ñ„Ð¾Ñ€Ð¼Ñƒ Ð¸ Ð¿Ð¾Ð´Ð°Ñ‡Ñƒ reply-Ð±Ð»Ð¾ÐºÐ¾Ð² Ð² ÑÐ¾Ð¾Ð±Ñ‰ÐµÐ½Ð¸ÑÑ… Ð¸ Ð¿Ð°Ð½ÐµÐ»Ð¸ Ð¾Ñ‚Ð²ÐµÑ‚Ð°.",
                sectionId: SosuzagramSettingsSection.ui.rawValue,
                style: .blocks,
                disclosureStyle: .arrow,
                action: {
                    arguments.openReplyStyle()
                }
            )
        }
    ))
    entries.append(SosuzagramSettingsEntry(
        section: SosuzagramSettingsSection.ui.rawValue,
        stableId: 53,
        sortId: 57,
        signature: "quickadminactions:\(quickAdminActions)",
        buildItem: { presentationData, arguments in
            ItemListSwitchItem(
                presentationData: presentationData,
                systemStyle: sosuzagramSettingsSystemStyle(),
                title: "Ð‘Ñ‹ÑÑ‚Ñ€Ñ‹Ðµ Ð°Ð´Ð¼Ð¸Ð½-Ð´ÐµÐ¹ÑÑ‚Ð²Ð¸Ñ",
                text: "Ð”Ð¾Ð±Ð°Ð²Ð»ÑÐµÑ‚ Ð¾Ñ‚Ð´ÐµÐ»ÑŒÐ½Ñ‹Ð¹ Ð¿ÑƒÐ½ÐºÑ‚ Ð°Ð´Ð¼Ð¸Ð½-Ð´ÐµÐ¹ÑÑ‚Ð²Ð¸Ð¹ Ð² Ð¼ÐµÐ½ÑŽ ÑÐ¾Ð¾Ð±Ñ‰ÐµÐ½Ð¸Ñ Ñ‚Ð°Ð¼, Ð³Ð´Ðµ Ñƒ Ð°ÐºÐºÐ°ÑƒÐ½Ñ‚Ð° ÐµÑÑ‚ÑŒ Ð¿Ñ€Ð°Ð²Ð° Ð¼Ð¾Ð´ÐµÑ€Ð°Ñ†Ð¸Ð¸.",
                value: quickAdminActions,
                sectionId: SosuzagramSettingsSection.ui.rawValue,
                style: .blocks,
                updated: { value in
                    arguments.toggleQuickAdminActions(value)
                }
            )
        }
    ))
    entries.append(SosuzagramSettingsEntry(
        section: SosuzagramSettingsSection.ui.rawValue,
        stableId: 54,
        sortId: 58,
        signature: "stickershape:\(stickerShape)",
        buildItem: { presentationData, arguments in
            ItemListDisclosureItem(
                presentationData: presentationData,
                systemStyle: sosuzagramSettingsSystemStyle(),
                title: "Ð¤Ð¾Ñ€Ð¼Ð° ÑÑ‚Ð¸ÐºÐµÑ€Ð¾Ð²",
                label: sosuzagramStickerShapeLabel(stickerShape),
                additionalDetailLabel: "ÐŸÐµÑ€ÐµÐºÐ»ÑŽÑ‡Ð°ÐµÑ‚ Ñ„Ð¾Ð½ Ð¸ Ñ„Ð¾Ñ€Ð¼Ñƒ bubble Ñƒ ÑÑ‚Ð¸ÐºÐµÑ€Ð¾Ð² Ð¼ÐµÐ¶Ð´Ñƒ ÑÐ¸ÑÑ‚ÐµÐ¼Ð½Ñ‹Ð¼ Ð²Ð¸Ð´Ð¾Ð¼, Ð·Ð°ÐºÑ€ÑƒÐ³Ð»Ñ‘Ð½Ð½Ð¾Ð¹ ÐºÐ°Ñ€Ñ‚Ð¾Ñ‡ÐºÐ¾Ð¹ Ð¸ Ð¾Ð±Ñ‹Ñ‡Ð½Ñ‹Ð¼ ÑÐ¾Ð¾Ð±Ñ‰ÐµÐ½Ð¸ÐµÐ¼.",
                sectionId: SosuzagramSettingsSection.ui.rawValue,
                style: .blocks,
                disclosureStyle: .arrow,
                action: {
                    arguments.openStickerShape()
                }
            )
        }
    ))
    entries.append(SosuzagramSettingsEntry(
        section: SosuzagramSettingsSection.ui.rawValue,
        stableId: 55,
        sortId: 59,
        signature: "messagemenuenabled:\(messageMenuEnabled)",
        buildItem: { presentationData, arguments in
            ItemListSwitchItem(
                presentationData: presentationData,
                systemStyle: sosuzagramSettingsSystemStyle(),
                title: "ÐœÐµÐ½ÑŽ ÑÐ¾Ð¾Ð±Ñ‰ÐµÐ½Ð¸Ñ",
                text: "Ð’ÐºÐ»ÑŽÑ‡Ð°ÐµÑ‚ ÐºÐ°ÑÑ‚Ð¾Ð¼Ð¸Ð·Ð°Ñ†Ð¸ÑŽ Ð¾ÑÐ½Ð¾Ð²Ð½Ñ‹Ñ… Ð´ÐµÐ¹ÑÑ‚Ð²Ð¸Ð¹ Ð² ÐºÐ¾Ð½Ñ‚ÐµÐºÑÑ‚Ð½Ð¾Ð¼ Ð¼ÐµÐ½ÑŽ ÑÐ¾Ð¾Ð±Ñ‰ÐµÐ½Ð¸Ñ.",
                value: messageMenuEnabled,
                sectionId: SosuzagramSettingsSection.ui.rawValue,
                style: .blocks,
                updated: { value in
                    arguments.toggleMessageMenuEnabled(value)
                }
            )
        }
    ))
    entries.append(SosuzagramSettingsEntry(
        section: SosuzagramSettingsSection.ui.rawValue,
        stableId: 56,
        sortId: 60,
        signature: "messagemenusettings:\(sosuzagramMessageMenuEnabledCount())",
        buildItem: { presentationData, arguments in
            ItemListDisclosureItem(
                presentationData: presentationData,
                systemStyle: sosuzagramSettingsSystemStyle(),
                title: "ÐÐ°ÑÑ‚Ñ€Ð¾Ð¸Ñ‚ÑŒ Ð¼ÐµÐ½ÑŽ ÑÐ¾Ð¾Ð±Ñ‰ÐµÐ½Ð¸Ñ",
                label: "\(sosuzagramMessageMenuEnabledCount())/8",
                additionalDetailLabel: "Ð£Ð¿Ñ€Ð°Ð²Ð»ÑÐµÑ‚ Ð½Ð°Ð±Ð¾Ñ€Ð¾Ð¼ Ð¾ÑÐ½Ð¾Ð²Ð½Ñ‹Ñ… Ð´ÐµÐ¹ÑÑ‚Ð²Ð¸Ð¹: Ð¾Ñ‚Ð²ÐµÑ‚, ÐºÐ¾Ð¿Ð¸Ñ€Ð¾Ð²Ð°Ð½Ð¸Ðµ, Ð¿ÐµÑ€ÐµÐ²Ð¾Ð´, Ð¾Ð·Ð²ÑƒÑ‡Ð¸Ð²Ð°Ð½Ð¸Ðµ, ÑÐ¾Ñ…Ñ€Ð°Ð½ÐµÐ½Ð¸Ðµ, Ð¿ÐµÑ€ÐµÑÑ‹Ð»ÐºÐ°, Ð²Ñ‹Ð´ÐµÐ»ÐµÐ½Ð¸Ðµ Ð¸ ÑƒÐ´Ð°Ð»ÐµÐ½Ð¸Ðµ.",
                sectionId: SosuzagramSettingsSection.ui.rawValue,
                style: .blocks,
                disclosureStyle: .arrow,
                action: {
                    arguments.openMessageMenuSettings()
                }
            )
        }
    ))
    entries.append(SosuzagramSettingsEntry(
        section: SosuzagramSettingsSection.ui.rawValue,
        stableId: 57,
        sortId: 61,
        signature: "groupmessagemenu:\(groupMessageMenu)",
        buildItem: { presentationData, arguments in
            ItemListSwitchItem(
                presentationData: presentationData,
                systemStyle: sosuzagramSettingsSystemStyle(),
                title: "Ð“Ñ€ÑƒÐ¿Ð¿Ð¸Ñ€Ð¾Ð²Ð°Ñ‚ÑŒ Ð¼ÐµÐ½ÑŽ ÑÐ¾Ð¾Ð±Ñ‰ÐµÐ½Ð¸Ñ",
                text: "ÐŸÐµÑ€ÐµÐ¼ÐµÑ‰Ð°ÐµÑ‚ Ð¾ÑÐ½Ð¾Ð²Ð½Ñ‹Ðµ Ð´ÐµÐ¹ÑÑ‚Ð²Ð¸Ñ Ð² Ð½Ð¸Ð¶Ð½ÑŽÑŽ Ñ‡Ð°ÑÑ‚ÑŒ Ð¼ÐµÐ½ÑŽ ÑÐ¾Ð¾Ð±Ñ‰ÐµÐ½Ð¸Ñ Ð¾Ñ‚Ð´ÐµÐ»ÑŒÐ½Ñ‹Ð¼ Ð±Ð»Ð¾ÐºÐ¾Ð¼.",
                value: groupMessageMenu,
                sectionId: SosuzagramSettingsSection.ui.rawValue,
                style: .blocks,
                updated: { value in
                    arguments.toggleGroupMessageMenu(value)
                }
            )
        }
    ))
    entries.append(SosuzagramSettingsEntry(
        section: SosuzagramSettingsSection.icons.rawValue,
        stableId: 223,
        sortId: 223,
        signature: "avatarshape:\(avatarShape)",
        buildItem: { presentationData, arguments in
            ItemListDisclosureItem(
                presentationData: presentationData,
                systemStyle: sosuzagramSettingsSystemStyle(),
                title: "ÃÂ¤ÃÂ¾Ã‘â‚¬ÃÂ¼ÃÂ° ÃÂ°ÃÂ²ÃÂ°Ã‘â€šÃÂ°Ã‘â‚¬ÃÂ¾ÃÂ²",
                label: sosuzagramAvatarShapeLabel(avatarShape),
                additionalDetailLabel: "ÃÅ“ÃÂµÃÂ½Ã‘ÂÃÂµÃ‘â€š Ã‘â€žÃÂ¾Ã‘â‚¬ÃÂ¼Ã‘Æ’ ÃÂ°ÃÂ²ÃÂ°Ã‘â€šÃÂ°Ã‘â‚¬ÃÂ¾ÃÂ² ÃÂ² Ã‘ÂÃÂ¿ÃÂ¸Ã‘ÂÃÂºÃÂµ Ã‘â€¡ÃÂ°Ã‘â€šÃÂ¾ÃÂ².",
                sectionId: SosuzagramSettingsSection.icons.rawValue,
                style: .blocks,
                disclosureStyle: .arrow,
                action: {
                    arguments.openAvatarShape()
                }
            )
        }
    ))
    entries.append(SosuzagramSettingsEntry(
        section: SosuzagramSettingsSection.icons.rawValue,
        stableId: 224,
        sortId: 224,
        signature: "unifiedrounding:\(unifiedRounding)",
        buildItem: { presentationData, arguments in
            ItemListSwitchItem(presentationData: presentationData, systemStyle: sosuzagramSettingsSystemStyle(), title: "Ãâ€¢ÃÂ´ÃÂ¸ÃÂ½ÃÂ¾ÃÂµ Ã‘ÂÃÂºÃ‘â‚¬Ã‘Æ’ÃÂ³ÃÂ»ÃÂµÃÂ½ÃÂ¸ÃÂµ ÃÂ°ÃÂ²ÃÂ°Ã‘â€šÃÂ°Ã‘â‚¬ÃÂ¾ÃÂ²", value: unifiedRounding, sectionId: SosuzagramSettingsSection.icons.rawValue, style: .blocks, updated: { value in
                arguments.toggleUnifiedRounding(value)
            })
        }
    ))
    entries.append(SosuzagramSettingsEntry(
        section: SosuzagramSettingsSection.icons.rawValue,
        stableId: 225,
        sortId: 225,
        signature: "miniavatars:\(miniAvatars)",
        buildItem: { presentationData, arguments in
            ItemListSwitchItem(presentationData: presentationData, systemStyle: sosuzagramSettingsSystemStyle(), title: "ÃÅ“ÃÂ¸ÃÂ½ÃÂ¸-ÃÂ°ÃÂ²ÃÂ°Ã‘â€šÃÂ°Ã‘â‚¬Ã‘â€¹", value: miniAvatars, sectionId: SosuzagramSettingsSection.icons.rawValue, style: .blocks, updated: { value in
                arguments.toggleMiniAvatars(value)
            })
        }
    ))
    entries.append(SosuzagramSettingsEntry(
        section: SosuzagramSettingsSection.icons.rawValue,
        stableId: 226,
        sortId: 226,
        signature: "disableseparators:\(disableSeparators)",
        buildItem: { presentationData, arguments in
            ItemListSwitchItem(presentationData: presentationData, systemStyle: sosuzagramSettingsSystemStyle(), title: "ÃÅ¾Ã‘â€šÃÂºÃÂ»Ã‘Å½Ã‘â€¡ÃÂ¸Ã‘â€šÃ‘Å’ Ã‘â‚¬ÃÂ°ÃÂ·ÃÂ´ÃÂµÃÂ»ÃÂ¸Ã‘â€šÃÂµÃÂ»ÃÂ¸", value: disableSeparators, sectionId: SosuzagramSettingsSection.icons.rawValue, style: .blocks, updated: { value in
                arguments.toggleDisableSeparators(value)
            })
        }
    ))
    entries.append(SosuzagramSettingsEntry(
        section: SosuzagramSettingsSection.icons.rawValue,
        stableId: 227,
        sortId: 227,
        signature: "separateheaders:\(separateHeaders)",
        buildItem: { presentationData, arguments in
            ItemListSwitchItem(
                presentationData: presentationData,
                systemStyle: sosuzagramSettingsSystemStyle(),
                title: "ÐžÑ‚Ð´ÐµÐ»ÑŒÐ½Ñ‹Ðµ Ð·Ð°Ð³Ð¾Ð»Ð¾Ð²ÐºÐ¸",
                text: "Ð’Ð¸Ð·ÑƒÐ°Ð»ÑŒÐ½Ð¾ Ð¾Ñ‚Ð´ÐµÐ»ÑÐµÑ‚ Ð²ÐµÑ€Ñ…Ð½Ð¸Ð¹ Ð·Ð°Ð³Ð¾Ð»Ð¾Ð²Ð¾Ðº ÑÐ¿Ð¸ÑÐºÐ° Ñ‡Ð°Ñ‚Ð¾Ð² Ð¾Ñ‚ Ð¿Ð°Ð½ÐµÐ»Ð¸ Ð²ÐºÐ»Ð°Ð´Ð¾Ðº Ð¸ Ð´Ð¾Ð¿Ð¾Ð»Ð½Ð¸Ñ‚ÐµÐ»ÑŒÐ½Ñ‹Ñ… Ð±Ð»Ð¾ÐºÐ¾Ð².",
                value: separateHeaders,
                sectionId: SosuzagramSettingsSection.icons.rawValue,
                style: .blocks,
                updated: { value in
                    arguments.toggleSeparateHeaders(value)
                }
            )
        }
    ))
    entries.append(SosuzagramSettingsEntry(
        section: SosuzagramSettingsSection.icons.rawValue,
        stableId: 228,
        sortId: 228,
        signature: "chatthemes:\(chatThemes)",
        buildItem: { presentationData, arguments in
            ItemListSwitchItem(
                presentationData: presentationData,
                systemStyle: sosuzagramSettingsSystemStyle(),
                title: "Ð Ð°Ð·Ð»Ð¸Ñ‡Ð½Ñ‹Ðµ Ñ‚ÐµÐ¼Ñ‹ Ð² Ñ‡Ð°Ñ‚Ð°Ñ…",
                text: "ÐŸÐ¾Ð·Ð²Ð¾Ð»ÑÐµÑ‚ ÐºÐ°Ð¶Ð´Ð¾Ð¼Ñƒ Ð´Ð¸Ð°Ð»Ð¾Ð³Ñƒ Ð¸ÑÐ¿Ð¾Ð»ÑŒÐ·Ð¾Ð²Ð°Ñ‚ÑŒ ÑÐ¾Ð±ÑÑ‚Ð²ÐµÐ½Ð½ÑƒÑŽ Ñ‚ÐµÐ¼Ñƒ Ð¸ Ð¾Ð±Ð¾Ð¸ Ð²Ð¼ÐµÑÑ‚Ð¾ Ð³Ð»Ð¾Ð±Ð°Ð»ÑŒÐ½Ð¾Ð¹ Ñ‚ÐµÐ¼Ñ‹ Ð¿Ñ€Ð¸Ð»Ð¾Ð¶ÐµÐ½Ð¸Ñ.",
                value: chatThemes,
                sectionId: SosuzagramSettingsSection.icons.rawValue,
                style: .blocks,
                updated: { value in
                    arguments.toggleChatThemes(value)
                }
            )
        }
    ))
    entries.append(SosuzagramSettingsEntry(
        section: SosuzagramSettingsSection.icons.rawValue,
        stableId: 229,
        sortId: 229,
        signature: "materialdesignlevel:\(materialDesignLevel)",
        buildItem: { presentationData, arguments in
            ItemListDisclosureItem(
                presentationData: presentationData,
                systemStyle: sosuzagramSettingsSystemStyle(),
                title: "Material Design 3",
                label: sosuzagramMaterialDesignLevelLabel(materialDesignLevel),
                additionalDetailLabel: "Ð£Ð¿Ñ€Ð°Ð²Ð»ÑÐµÑ‚ ÑÐ¸Ð»Ð¾Ð¹ Android-Ð¿Ð¾Ð´Ð¾Ð±Ð½Ð¾Ð³Ð¾ Ð¾Ñ„Ð¾Ñ€Ð¼Ð»ÐµÐ½Ð¸Ñ Ð´Ð»Ñ ÑÐ¿Ð¸ÑÐºÐ° Ñ‡Ð°Ñ‚Ð¾Ð², Ð²ÐºÐ»Ð°Ð´Ð¾Ðº Ð¸ ÑÐ²ÑÐ·Ð°Ð½Ð½Ñ‹Ñ… ÑÐ»ÐµÐ¼ÐµÐ½Ñ‚Ð¾Ð² Ð¸Ð½Ñ‚ÐµÑ€Ñ„ÐµÐ¹ÑÐ°.",
                sectionId: SosuzagramSettingsSection.icons.rawValue,
                style: .blocks,
                disclosureStyle: .arrow,
                action: {
                    arguments.openMaterialDesignLevel()
                }
            )
        }
    ))
    entries.append(SosuzagramSettingsEntry(
        section: SosuzagramSettingsSection.icons.rawValue,
        stableId: 230,
        sortId: 230,
        signature: "systememoji:\(systemEmoji)",
        buildItem: { presentationData, arguments in
            ItemListSwitchItem(
                presentationData: presentationData,
                systemStyle: sosuzagramSettingsSystemStyle(),
                title: "Ð¡Ð¸ÑÑ‚ÐµÐ¼Ð½Ñ‹Ðµ ÑÐ¼Ð¾Ð´Ð·Ð¸",
                text: "Ð£Ð¿Ñ€Ð¾Ñ‰Ð°ÐµÑ‚ Ð¾Ñ‚Ð¾Ð±Ñ€Ð°Ð¶ÐµÐ½Ð¸Ðµ ÑÐ¼Ð¾Ð´Ð·Ð¸ Ð¸ ÐºÐ°ÑÑ‚Ð¾Ð¼Ð½Ñ‹Ñ… Ð·Ð½Ð°Ñ‡ÐºÐ¾Ð² Ð² Ð¿Ñ€ÐµÐ²ÑŒÑŽ ÑÐ¿Ð¸ÑÐºÐ° Ñ‡Ð°Ñ‚Ð¾Ð², Ð±Ð»Ð¸Ð¶Ðµ Ðº ÑÐ¸ÑÑ‚ÐµÐ¼Ð½Ð¾Ð¼Ñƒ Ð²Ð¸Ð´Ñƒ iOS.",
                value: systemEmoji,
                sectionId: SosuzagramSettingsSection.icons.rawValue,
                style: .blocks,
                updated: { value in
                    arguments.toggleSystemEmoji(value)
                }
            )
        }
    ))
    entries.append(SosuzagramSettingsEntry(
        section: SosuzagramSettingsSection.icons.rawValue,
        stableId: 231,
        sortId: 231,
        signature: "stickyavataranimation:\(stickyAvatarAnimation)",
        buildItem: { presentationData, arguments in
            ItemListSwitchItem(
                presentationData: presentationData,
                systemStyle: sosuzagramSettingsSystemStyle(),
                title: "\"Ð›Ð¸Ð¿ÐºÐ°Ñ\" Ð°Ð½Ð¸Ð¼Ð°Ñ†Ð¸Ñ Ð°Ð²Ð°Ñ‚Ð°Ñ€Ð¾Ðº",
                text: "Ð”Ð¾Ð±Ð°Ð²Ð»ÑÐµÑ‚ Ð±Ð¾Ð»ÐµÐµ Ð²ÑÐ·ÐºÐ¾Ðµ Ð¸ Ð¿Ð»Ð°Ð²Ð½Ð¾Ðµ Ð´Ð²Ð¸Ð¶ÐµÐ½Ð¸Ðµ Ð°Ð²Ð°Ñ‚Ð°Ñ€Ð¾Ðº Ð¿Ñ€Ð¸ Ð¿ÐµÑ€ÐµÑÑ‚Ñ€Ð¾ÐµÐ½Ð¸Ð¸ ÑÐ¿Ð¸ÑÐºÐ° Ñ‡Ð°Ñ‚Ð¾Ð² Ð¸ ÑÐ²ÑÐ·Ð°Ð½Ð½Ñ‹Ñ… Ð¿ÐµÑ€ÐµÑ…Ð¾Ð´Ð°Ñ….",
                value: stickyAvatarAnimation,
                sectionId: SosuzagramSettingsSection.icons.rawValue,
                style: .blocks,
                updated: { value in
                    arguments.toggleStickyAvatarAnimation(value)
                }
            )
        }
    ))
    entries.append(SosuzagramSettingsEntry(
        section: SosuzagramSettingsSection.icons.rawValue,
        stableId: 242,
        sortId: 242,
        signature: "androiddesign:\(androidDesign)",
        buildItem: { presentationData, arguments in
            ItemListSwitchItem(presentationData: presentationData, systemStyle: sosuzagramSettingsSystemStyle(), title: "Android design (Exteragram)", text: "Ð’ÐºÐ»ÑŽÑ‡Ð°ÐµÑ‚ Ð¿Ñ€ÐµÑÐµÑ‚ Ð²Ð½ÐµÑˆÐ½ÐµÐ³Ð¾ Ð²Ð¸Ð´Ð° Ð² ÑÑ‚Ð¸Ð»Ðµ Ð¾Ñ€Ð¸Ð³Ð¸Ð½Ð°Ð»ÑŒÐ½Ð¾Ð³Ð¾ Exteragram Ð¸ Ð¼Ð¾Ð¶ÐµÑ‚ Ð¿Ð¾Ñ‚Ñ€ÐµÐ±Ð¾Ð²Ð°Ñ‚ÑŒ Ð¿ÐµÑ€ÐµÐ·Ð°Ð¿ÑƒÑÐº Ð¿Ñ€Ð¸Ð»Ð¾Ð¶ÐµÐ½Ð¸Ñ.", value: androidDesign, sectionId: SosuzagramSettingsSection.icons.rawValue, style: .blocks, updated: { value in
                arguments.toggleAndroidDesign(value)
            })
        }
    ))
    entries.append(SosuzagramSettingsEntry(
        section: SosuzagramSettingsSection.icons.rawValue,
        stableId: 244,
        sortId: 244,
        signature: "smoothanimations:\(smoothAnimations)",
        buildItem: { presentationData, arguments in
            ItemListSwitchItem(presentationData: presentationData, systemStyle: sosuzagramSettingsSystemStyle(), title: "ÐŸÐ»Ð°Ð²Ð½Ñ‹Ðµ Ð°Ð½Ð¸Ð¼Ð°Ñ†Ð¸Ð¸", text: "Ð£Ð²ÐµÐ»Ð¸Ñ‡Ð¸Ð²Ð°ÐµÑ‚ Ð´Ð»Ð¸Ñ‚ÐµÐ»ÑŒÐ½Ð¾ÑÑ‚ÑŒ Ð¸ ÑÐ³Ð»Ð°Ð¶Ð¸Ð²Ð°ÐµÑ‚ Ð¿ÐµÑ€ÐµÑ…Ð¾Ð´Ñ‹ Ð² Sosuzagram Ð¸ ÑÐ¿Ð¸ÑÐºÐµ Ñ‡Ð°Ñ‚Ð¾Ð².", value: smoothAnimations, sectionId: SosuzagramSettingsSection.icons.rawValue, style: .blocks, updated: { value in
                arguments.toggleSmoothAnimations(value)
            })
        }
    ))
    entries.append(SosuzagramSettingsEntry(
        section: SosuzagramSettingsSection.icons.rawValue,
        stableId: 243,
        sortId: 243,
        signature: "systemfonts:\(systemFonts)",
        buildItem: { presentationData, arguments in
            ItemListSwitchItem(presentationData: presentationData, systemStyle: sosuzagramSettingsSystemStyle(), title: "Ð¡Ð¸ÑÑ‚ÐµÐ¼Ð½Ñ‹Ðµ ÑˆÑ€Ð¸Ñ„Ñ‚Ñ‹", value: systemFonts, sectionId: SosuzagramSettingsSection.icons.rawValue, style: .blocks, updated: { value in
                arguments.toggleSystemFonts(value)
            })
        }
    ))
    entries.append(SosuzagramSettingsEntry(
        section: SosuzagramSettingsSection.icons.rawValue,
        stableId: 239,
        sortId: 239,
        signature: "folderbadges:\(showFolderBadges)",
        buildItem: { presentationData, arguments in
            ItemListSwitchItem(presentationData: presentationData, systemStyle: sosuzagramSettingsSystemStyle(), title: "Ð¡Ñ‡Ñ‘Ñ‚Ñ‡Ð¸Ðº ÑƒÐ²ÐµÐ´Ð¾Ð¼Ð»ÐµÐ½Ð¸Ð¹ Ð¿Ð°Ð¿Ð¾Ðº", value: showFolderBadges, sectionId: SosuzagramSettingsSection.icons.rawValue, style: .blocks, updated: { value in
                arguments.toggleShowFolderBadges(value)
            })
        }
    ))
    entries.append(SosuzagramSettingsEntry(
        section: SosuzagramSettingsSection.icons.rawValue,
        stableId: 238,
        sortId: 238,
        signature: "iconpacks",
        buildItem: { presentationData, arguments in
            ItemListDisclosureItem(
                presentationData: presentationData,
                systemStyle: sosuzagramSettingsSystemStyle(),
                title: "ÐÐ°Ð±Ð¾Ñ€Ñ‹ Ð¸ÐºÐ¾Ð½Ð¾Ðº",
                label: "Extera style",
                additionalDetailLabel: "Ð‘Ñ‹ÑÑ‚Ñ€Ñ‹Ð¹ Ð²Ñ‹Ð±Ð¾Ñ€ Ð°Ð»ÑŒÑ‚ÐµÑ€Ð½Ð°Ñ‚Ð¸Ð²Ð½Ð¾Ð¹ Ð¸ÐºÐ¾Ð½ÐºÐ¸ Ð¿Ñ€Ð¸Ð»Ð¾Ð¶ÐµÐ½Ð¸Ñ.",
                sectionId: SosuzagramSettingsSection.icons.rawValue,
                style: .blocks,
                disclosureStyle: .arrow,
                action: {
                    arguments.openIconPacks()
                }
            )
        }
    ))
    entries.append(SosuzagramSettingsEntry(
        section: SosuzagramSettingsSection.icons.rawValue,
        stableId: 249,
        sortId: 249,
        signature: "pillstackmode:\(pillStackMode)",
        buildItem: { presentationData, arguments in
            ItemListDisclosureItem(
                presentationData: presentationData,
                systemStyle: sosuzagramSettingsSystemStyle(),
                title: "Pill Stack",
                label: sosuzagramPillStackModeLabel(pillStackMode),
                additionalDetailLabel: "ÐÐ°ÑÑ‚Ñ€Ð°Ð¸Ð²Ð°ÐµÑ‚ Ð¿Ð»Ð¾Ñ‚Ð½Ð¾ÑÑ‚ÑŒ Ð¸ Ñ„Ð¾Ñ€Ð¼Ñƒ Ð²ÐºÐ»Ð°Ð´Ð¾Ðº-Ð¿Ð»Ð°ÑˆÐµÐº Ð² ÑÐ¿Ð¸ÑÐºÐµ Ñ‡Ð°Ñ‚Ð¾Ð².",
                sectionId: SosuzagramSettingsSection.icons.rawValue,
                style: .blocks,
                disclosureStyle: .arrow,
                action: {
                    arguments.openPillStackMode()
                }
            )
        }
    ))
    entries.append(SosuzagramSettingsEntry(
        section: SosuzagramSettingsSection.icons.rawValue,
        stableId: 250,
        sortId: 250,
        signature: "navigationinapp",
        buildItem: { presentationData, arguments in
            ItemListDisclosureItem(
                presentationData: presentationData,
                systemStyle: sosuzagramSettingsSystemStyle(),
                title: "ÐÐ°Ð²Ð¸Ð³Ð°Ñ†Ð¸Ñ Ð² Ð¿Ñ€Ð¸Ð»Ð¾Ð¶ÐµÐ½Ð¸Ð¸",
                label: "ÐÐ°ÑÑ‚Ñ€Ð¾Ð¸Ñ‚ÑŒ",
                additionalDetailLabel: "Ð‘Ñ‹ÑÑ‚Ñ€Ñ‹Ð¹ Ð´Ð¾ÑÑ‚ÑƒÐ¿ Ðº Ð½Ð°ÑÑ‚Ñ€Ð¾Ð¹ÐºÐ°Ð¼ Ð²ÐºÐ»Ð°Ð´Ð¾Ðº, Ð¿Ð°Ð¿Ð¾Ðº Ð¸ Ð·Ð°Ð³Ð¾Ð»Ð¾Ð²ÐºÐ° ÑÐ¿Ð¸ÑÐºÐ° Ñ‡Ð°Ñ‚Ð¾Ð².",
                sectionId: SosuzagramSettingsSection.icons.rawValue,
                style: .blocks,
                disclosureStyle: .arrow,
                action: {
                    arguments.openNavigationInApp()
                }
            )
        }
    ))
    entries.append(SosuzagramSettingsEntry(
        section: SosuzagramSettingsSection.icons.rawValue,
        stableId: 245,
        sortId: 245,
        signature: "chatlisttitletext:\(chatListTitleText)",
        buildItem: { presentationData, arguments in
            ItemListDisclosureItem(
                presentationData: presentationData,
                systemStyle: sosuzagramSettingsSystemStyle(),
                title: "ÃÂ¢ÃÂµÃÂºÃ‘ÂÃ‘â€š ÃÂ² ÃÂ·ÃÂ°ÃÂ³ÃÂ¾ÃÂ»ÃÂ¾ÃÂ²ÃÂºÃÂµ",
                label: sosuzagramChatListTitleTextLabel(chatListTitleText),
                additionalDetailLabel: "ÃÅ“ÃÂµÃÂ½Ã‘ÂÃÂµÃ‘â€š Ã‘â€šÃÂµÃÂºÃ‘ÂÃ‘â€š ÃÂ²ÃÂµÃ‘â‚¬Ã‘â€¦ÃÂ½ÃÂµÃÂ³ÃÂ¾ ÃÂ·ÃÂ°ÃÂ³ÃÂ¾ÃÂ»ÃÂ¾ÃÂ²ÃÂºÃÂ° Ã‘ÂÃÂ¿ÃÂ¸Ã‘ÂÃÂºÃÂ° Ã‘â€¡ÃÂ°Ã‘â€šÃÂ¾ÃÂ².",
                sectionId: SosuzagramSettingsSection.icons.rawValue,
                style: .blocks,
                disclosureStyle: .arrow,
                action: {
                    arguments.openChatListTitleText()
                }
            )
        }
    ))
    entries.append(SosuzagramSettingsEntry(
        section: SosuzagramSettingsSection.icons.rawValue,
        stableId: 246,
        sortId: 246,
        signature: "foldertabtitles:\(folderTabTitles)",
        buildItem: { presentationData, arguments in
            ItemListDisclosureItem(
                presentationData: presentationData,
                systemStyle: sosuzagramSettingsSystemStyle(),
                title: "Ãâ€”ÃÂ°ÃÂ³ÃÂ¾ÃÂ»ÃÂ¾ÃÂ²ÃÂºÃÂ¸ ÃÂ¿ÃÂ°ÃÂ¿ÃÂ¾ÃÂº",
                label: sosuzagramFolderTabTitlesLabel(folderTabTitles),
                additionalDetailLabel: "ÃÅ“ÃÂµÃÂ½Ã‘ÂÃÂµÃ‘â€š, ÃÂºÃÂ°ÃÂº ÃÂ¾Ã‘â€šÃÂ¾ÃÂ±Ã‘â‚¬ÃÂ°ÃÂ¶ÃÂ°Ã‘Å½Ã‘â€šÃ‘ÂÃ‘Â ÃÂ½ÃÂ°ÃÂ·ÃÂ²ÃÂ°ÃÂ½ÃÂ¸Ã‘Â ÃÂ¸ ÃÂ¸ÃÂºÃÂ¾ÃÂ½ÃÂºÃÂ¸ ÃÂ²ÃÂºÃÂ»ÃÂ°ÃÂ´ÃÂ¾ÃÂº.",
                sectionId: SosuzagramSettingsSection.icons.rawValue,
                style: .blocks,
                disclosureStyle: .arrow,
                action: {
                    arguments.openFolderTabTitles()
                }
            )
        }
    ))
    entries.append(SosuzagramSettingsEntry(
        section: SosuzagramSettingsSection.icons.rawValue,
        stableId: 240,
        sortId: 240,
        signature: "forcesnow:\(forceSnow)",
        buildItem: { presentationData, arguments in
            ItemListSwitchItem(presentationData: presentationData, systemStyle: sosuzagramSettingsSystemStyle(), title: "ÐŸÑ€Ð¸Ð½ÑƒÐ´Ð¸Ñ‚ÐµÐ»ÑŒÐ½Ñ‹Ð¹ ÑÐ½ÐµÐ³", value: forceSnow, sectionId: SosuzagramSettingsSection.icons.rawValue, style: .blocks, updated: { value in
                arguments.toggleForceSnow(value)
            })
        }
    ))
    entries.append(SosuzagramSettingsEntry(
        section: SosuzagramSettingsSection.icons.rawValue,
        stableId: 247,
        sortId: 247,
        signature: "glasshighlights:\(glassHighlights)",
        buildItem: { presentationData, arguments in
            ItemListSwitchItem(
                presentationData: presentationData,
                systemStyle: sosuzagramSettingsSystemStyle(),
                title: "Ð‘Ð»Ð¸ÐºÐ¸ Ð½Ð° ÑÐ»ÐµÐ¼ÐµÐ½Ñ‚Ð°Ñ…",
                text: "ÐžÑ‚ÐºÐ»ÑŽÑ‡Ð°ÐµÑ‚ ÑÑ‚ÐµÐºÐ»ÑÐ½Ð½Ñ‹Ðµ Ð±Ð»Ð¸ÐºÐ¸ Ð¸ ÑÑ€ÐºÑƒÑŽ Ð¾Ð±Ð²Ð¾Ð´ÐºÑƒ Ð½Ð° blur-ÑÐ»ÐµÐ¼ÐµÐ½Ñ‚Ð°Ñ… Ð¸Ð½Ñ‚ÐµÑ€Ñ„ÐµÐ¹ÑÐ°.",
                value: glassHighlights,
                sectionId: SosuzagramSettingsSection.icons.rawValue,
                style: .blocks,
                updated: { value in
                    arguments.toggleGlassHighlights(value)
                }
            )
        }
    ))
    entries.append(SosuzagramSettingsEntry(
        section: SosuzagramSettingsSection.icons.rawValue,
        stableId: 248,
        sortId: 248,
        signature: "forceblur:\(forceBlur)",
        buildItem: { presentationData, arguments in
            ItemListSwitchItem(
                presentationData: presentationData,
                systemStyle: sosuzagramSettingsSystemStyle(),
                title: "ÐŸÑ€Ð¸Ð½ÑƒÐ´Ð¸Ñ‚ÐµÐ»ÑŒÐ½Ð¾Ðµ Ñ€Ð°Ð·Ð¼Ñ‹Ñ‚Ð¸Ðµ",
                text: "ÐŸÑ€Ð¸Ð½ÑƒÐ´Ð¸Ñ‚ÐµÐ»ÑŒÐ½Ð¾ Ð²ÐºÐ»ÑŽÑ‡Ð°ÐµÑ‚ blur/glass-ÑÑ„Ñ„ÐµÐºÑ‚ Ñ‚Ð°Ð¼, Ð³Ð´Ðµ ÑÐ¸ÑÑ‚ÐµÐ¼Ð° Ð¼Ð¾Ð¶ÐµÑ‚ Ð¸ÑÐ¿Ð¾Ð»ÑŒÐ·Ð¾Ð²Ð°Ñ‚ÑŒ ÑƒÐ¿Ñ€Ð¾Ñ‰Ñ‘Ð½Ð½Ñ‹Ð¹ ÑÑ‚Ð¸Ð»ÑŒ. Ð”Ð»Ñ Ð¿Ð¾Ð»Ð½Ð¾Ð³Ð¾ Ð¿Ñ€Ð¸Ð¼ÐµÐ½ÐµÐ½Ð¸Ñ Ð»ÑƒÑ‡ÑˆÐµ Ð¿ÐµÑ€ÐµÐ·Ð°Ð¿ÑƒÑÑ‚Ð¸Ñ‚ÑŒ Ð¿Ñ€Ð¸Ð»Ð¾Ð¶ÐµÐ½Ð¸Ðµ.",
                value: forceBlur,
                sectionId: SosuzagramSettingsSection.icons.rawValue,
                style: .blocks,
                updated: { value in
                    arguments.toggleForceBlur(value)
                }
            )
        }
    ))

    let icons = [
        ("ÃÂ¡Ã‘â€šÃÂ°ÃÂ½ÃÂ´ÃÂ°Ã‘â‚¬Ã‘â€šÃÂ½ÃÂ°Ã‘Â", "nil"),
        ("ÃÅ¡Ã‘â‚¬ÃÂ°Ã‘ÂÃÂ½ÃÂ°Ã‘Â (Extera style)", "Red"),
        ("Ãâ€”ÃÂµÃÂ»Ã‘â€˜ÃÂ½ÃÂ°Ã‘Â (Extera style)", "Green"),
        ("ÃÅ¾Ã‘â‚¬ÃÂ°ÃÂ½ÃÂ¶ÃÂµÃÂ²ÃÂ°Ã‘Â (Extera style)", "Orange"),
        ("ÃÂ¤ÃÂ¸ÃÂ¾ÃÂ»ÃÂµÃ‘â€šÃÂ¾ÃÂ²ÃÂ°Ã‘Â (Extera style)", "Purple")
    ]
    entries.append(SosuzagramSettingsEntry(
        section: SosuzagramSettingsSection.icons.rawValue,
        stableId: 13,
        sortId: 13,
        signature: "icons-header",
        buildItem: { presentationData, _ in
            ItemListSectionHeaderItem(presentationData: presentationData, text: "ÃËœÃÂºÃÂ¾ÃÂ½ÃÂºÃÂ¸ ÃÂ¿Ã‘â‚¬ÃÂ¸ÃÂ»ÃÂ¾ÃÂ¶ÃÂµÃÂ½ÃÂ¸Ã‘Â", sectionId: SosuzagramSettingsSection.icons.rawValue)
        }
    ))
    for (index, icon) in icons.enumerated() {
        let isSelected = currentIcon == icon.1
        entries.append(SosuzagramSettingsEntry(
            section: SosuzagramSettingsSection.icons.rawValue,
            stableId: UInt64(100 + index),
            sortId: Int32(100 + index),
            signature: "icon:\(icon.1):\(isSelected)",
            buildItem: { presentationData, arguments in
                ItemListDisclosureItem(
                    presentationData: presentationData,
                    systemStyle: sosuzagramSettingsSystemStyle(),
                    title: icon.0,
                    label: isSelected ? "Ãâ€™Ã‘â€¹ÃÂ±Ã‘â‚¬ÃÂ°ÃÂ½ÃÂ¾" : "",
                    sectionId: SosuzagramSettingsSection.icons.rawValue,
                    style: .blocks,
                    disclosureStyle: .none,
                    action: {
                        arguments.selectIcon(icon.1)
                    }
                )
            }
        ))
    }
    entries.append(SosuzagramSettingsEntry(
        section: SosuzagramSettingsSection.icons.rawValue,
        stableId: 220,
        sortId: 220,
        signature: "appearance-links-header",
        buildItem: { presentationData, _ in
            ItemListSectionHeaderItem(presentationData: presentationData, text: "Ãâ€™Ã‘ÂÃ‘â€šÃ‘â‚¬ÃÂ¾ÃÂµÃÂ½ÃÂ½Ã‘â€¹ÃÂµ Ã‘â‚¬ÃÂ°ÃÂ·ÃÂ´ÃÂµÃÂ»Ã‘â€¹ Telegram", sectionId: SosuzagramSettingsSection.icons.rawValue)
        }
    ))
    entries.append(SosuzagramSettingsEntry(
        section: SosuzagramSettingsSection.icons.rawValue,
        stableId: 221,
        sortId: 221,
        signature: "themesettings",
        buildItem: { presentationData, arguments in
            ItemListDisclosureItem(
                presentationData: presentationData,
                systemStyle: sosuzagramSettingsSystemStyle(),
                title: "ÃÂ¢ÃÂµÃÂ¼Ã‘â€¹ Telegram",
                label: "",
                additionalDetailLabel: "ÃÅ¾Ã‘â€šÃÂºÃ‘â‚¬Ã‘â€¹ÃÂ²ÃÂ°ÃÂµÃ‘â€š Ã‘ÂÃÂ¸Ã‘ÂÃ‘â€šÃÂµÃÂ¼ÃÂ½Ã‘â€¹ÃÂ¹ Ã‘ÂÃÂºÃ‘â‚¬ÃÂ°ÃÂ½ Ã‘â€šÃÂµÃÂ¼ ÃÂ¸ ÃÂ¾Ã‘â€žÃÂ¾Ã‘â‚¬ÃÂ¼ÃÂ»ÃÂµÃÂ½ÃÂ¸Ã‘Â Telegram.",
                sectionId: SosuzagramSettingsSection.icons.rawValue,
                style: .blocks,
                disclosureStyle: .arrow,
                action: {
                    arguments.openThemeSettings()
                }
            )
        }
    ))
    entries.append(SosuzagramSettingsEntry(
        section: SosuzagramSettingsSection.icons.rawValue,
        stableId: 222,
        sortId: 222,
        signature: "chatfolderssettings",
        buildItem: { presentationData, arguments in
            ItemListDisclosureItem(
                presentationData: presentationData,
                systemStyle: sosuzagramSettingsSystemStyle(),
                title: "ÃÅ¸ÃÂ°ÃÂ¿ÃÂºÃÂ¸ ÃÂ¸ ÃÂ²ÃÂºÃÂ»ÃÂ°ÃÂ´ÃÂºÃÂ¸",
                label: "",
                additionalDetailLabel: "ÃÅ¾Ã‘â€šÃÂºÃ‘â‚¬Ã‘â€¹ÃÂ²ÃÂ°ÃÂµÃ‘â€š Ã‘ÂÃÂ¸Ã‘ÂÃ‘â€šÃÂµÃÂ¼ÃÂ½Ã‘â€¹ÃÂµ ÃÂ½ÃÂ°Ã‘ÂÃ‘â€šÃ‘â‚¬ÃÂ¾ÃÂ¹ÃÂºÃÂ¸ ÃÂ¿ÃÂ°ÃÂ¿ÃÂ¾ÃÂº, Ã‘â€žÃÂ¸ÃÂ»Ã‘Å’Ã‘â€šÃ‘â‚¬ÃÂ¾ÃÂ² ÃÂ¸ ÃÂ²ÃÂºÃÂ»ÃÂ°ÃÂ´ÃÂ¾ÃÂº Telegram.",
                sectionId: SosuzagramSettingsSection.icons.rawValue,
                style: .blocks,
                disclosureStyle: .arrow,
                action: {
                    arguments.openChatFoldersSettings()
                }
            )
        }
    ))

    entries.append(SosuzagramSettingsEntry(
        section: SosuzagramSettingsSection.plugins.rawValue,
        stableId: 200,
        sortId: 200,
        signature: "plugins-header",
        buildItem: { presentationData, _ in
            ItemListSectionHeaderItem(presentationData: presentationData, text: "ÃÅ¸ÃÂ»ÃÂ°ÃÂ³ÃÂ¸ÃÂ½Ã‘â€¹ Extera (iOS)", sectionId: SosuzagramSettingsSection.plugins.rawValue)
        }
    ))
    entries.append(SosuzagramSettingsEntry(
        section: SosuzagramSettingsSection.plugins.rawValue,
        stableId: 201,
        sortId: 201,
        signature: "plugins-import",
        buildItem: { presentationData, arguments in
            ItemListActionItem(
                presentationData: presentationData,
                systemStyle: sosuzagramSettingsSystemStyle(),
                title: "Ãâ€”ÃÂ°ÃÂ³Ã‘â‚¬Ã‘Æ’ÃÂ·ÃÂ¸Ã‘â€šÃ‘Å’ .plugin",
                kind: .generic,
                alignment: .natural,
                sectionId: SosuzagramSettingsSection.plugins.rawValue,
                style: .blocks,
                action: {
                    arguments.importPlugin()
                }
            )
        }
    ))

    for (index, plugin) in plugins.enumerated() {
        let status = sosuzagramPluginEnabled(plugin.id) ? "Ãâ€™ÃÂºÃÂ»" : "Ãâ€™Ã‘â€¹ÃÂºÃÂ»"
        entries.append(SosuzagramSettingsEntry(
            section: SosuzagramSettingsSection.plugins.rawValue,
            stableId: UInt64(1000 + index),
            sortId: Int32(1000 + index),
            signature: "plugin:\(plugin.id):\(status):\(plugin.desc)",
            buildItem: { presentationData, arguments in
                ItemListDisclosureItem(
                    presentationData: presentationData,
                    systemStyle: sosuzagramSettingsSystemStyle(),
                    title: plugin.name,
                    label: status,
                    additionalDetailLabel: plugin.desc,
                    sectionId: SosuzagramSettingsSection.plugins.rawValue,
                    style: .blocks,
                    disclosureStyle: .arrow,
                    action: {
                        arguments.openPlugin(plugin.id)
                    }
                )
            }
        ))
    }

    entries.append(SosuzagramSettingsEntry(
        section: SosuzagramSettingsSection.plugins.rawValue,
        stableId: 2000,
        sortId: 2000,
        signature: "plugins-info",
        buildItem: { presentationData, _ in
            ItemListTextItem(presentationData: presentationData, text: .plain("ÃÂÃÂ¾ÃÂ²Ã‘â€¹ÃÂµ .plugin-Ã‘â€žÃÂ°ÃÂ¹ÃÂ»Ã‘â€¹ ÃÂ½ÃÂµ ÃÂ¸ÃÂ¼ÃÂ¿ÃÂ¾Ã‘â‚¬Ã‘â€šÃÂ¸Ã‘â‚¬Ã‘Æ’Ã‘Å½Ã‘â€šÃ‘ÂÃ‘Â ÃÂ°ÃÂ²Ã‘â€šÃÂ¾ÃÂ¼ÃÂ°Ã‘â€šÃÂ¸Ã‘â€¡ÃÂµÃ‘ÂÃÂºÃÂ¸. Ãâ€ÃÂ»Ã‘Â ÃÂºÃÂ°ÃÂ¶ÃÂ´ÃÂ¾ÃÂ³ÃÂ¾ ÃÂ½ÃÂ¾ÃÂ²ÃÂ¾ÃÂ³ÃÂ¾ ÃÂ¿ÃÂ»ÃÂ°ÃÂ³ÃÂ¸ÃÂ½ÃÂ° ÃÂ½Ã‘Æ’ÃÂ¶ÃÂµÃÂ½ ÃÂ¾Ã‘â€šÃÂ´ÃÂµÃÂ»Ã‘Å’ÃÂ½Ã‘â€¹ÃÂ¹ ÃÂ½ÃÂ°Ã‘â€šÃÂ¸ÃÂ²ÃÂ½Ã‘â€¹ÃÂ¹ ÃÂ¿ÃÂ¾Ã‘â‚¬Ã‘â€š ÃÂ¿ÃÂ¾ÃÂ´ Sosuzagram."), sectionId: SosuzagramSettingsSection.plugins.rawValue)
        }
    ))

    _ = theme
    return entries
}

public func sosuzagramSettingsController(context: AccountContext) -> ViewController {
    return sosuzagramSettingsControllerImpl(context: context, category: nil)
}

private func sosuzagramSettingsCategoryController(context: AccountContext, category: SosuzagramSettingsCategory) -> ViewController {
    return sosuzagramSettingsControllerImpl(context: context, category: category)
}

private func sosuzagramSettingsControllerImpl(context: AccountContext, category: SosuzagramSettingsCategory?) -> ViewController {
    deployEmbeddedPluginsIfNeeded()

    let statePromise = ValuePromise<Bool>(true, ignoreRepeated: false)
    var updateSettingsImpl: (() -> Void)?
    var openCategoryImpl: ((SosuzagramSettingsCategory) -> Void)?
    var openStickerSizePresetImpl: (() -> Void)?
    var openVoiceRecognitionLocaleImpl: (() -> Void)?
    var openDownloadAccelerationImpl: (() -> Void)?
    var promptAndroidDesignRestartImpl: ((Bool) -> Void)?
    var promptForceBlurRestartImpl: ((Bool) -> Void)?
    var openCameraTypeImpl: (() -> Void)?
    var openVideoMessageCameraImpl: (() -> Void)?
    var openAvatarShapeImpl: (() -> Void)?
    var openMaterialDesignLevelImpl: (() -> Void)?
    var openReplyStyleImpl: (() -> Void)?
    var openMessageMenuSettingsImpl: (() -> Void)?
    var openPillStackModeImpl: (() -> Void)?
    var openNavigationInAppImpl: (() -> Void)?
    var openIconPacksImpl: (() -> Void)?
    var openChatListTitleTextImpl: (() -> Void)?
    var openFolderTabTitlesImpl: (() -> Void)?
    var openDoNotTranslateLanguagesImpl: (() -> Void)?
    var openTranslationProviderImpl: (() -> Void)?
    var openTranslationTargetImpl: (() -> Void)?
    var openLocalizationSettingsImpl: (() -> Void)?
    var openThemeSettingsImpl: (() -> Void)?
    var openChatFoldersSettingsImpl: (() -> Void)?
    var openIncomingDoubleTapActionImpl: (() -> Void)?
    var openOutgoingDoubleTapActionImpl: (() -> Void)?
    var openStickerShapeImpl: (() -> Void)?
    var openPluginImpl: ((String) -> Void)?
    var importPluginImpl: (() -> Void)?

    let arguments = SosuzagramSettingsControllerArguments(
        context: context,
        openCategory: { selectedCategory in
            openCategoryImpl?(selectedCategory)
        },
        toggleSkipReadHistory: { value in
            let _ = updateExperimentalUISettingsInteractively(accountManager: context.sharedContext.accountManager, { settings in
                var settings = settings
                settings.skipReadHistory = value
                return settings
            }).start()
            UserDefaults.standard.set(value, forKey: "sosuzagram_skip_read_history")
            updateSettingsImpl?()
        },
        toggleHideStoryViews: { value in
            UserDefaults.standard.set(value, forKey: "sosuzagram_hide_story_views")
            updateSettingsImpl?()
        },
        toggleHideTyping: { value in
            UserDefaults.standard.set(value, forKey: "sosuzagram_hide_typing")
            updateSettingsImpl?()
        },
        toggleKeepLocalHistory: { value in
            UserDefaults.standard.set(value, forKey: "sosuzagram_local_history")
            updateSettingsImpl?()
        },
        toggleShowMarker: { value in
            UserDefaults.standard.set(value, forKey: "sosuzagram_show_marker")
            updateSettingsImpl?()
        },
        toggleHideStories: { value in
            UserDefaults.standard.set(value, forKey: "sosuzagram_hide_stories")
            updateSettingsImpl?()
        },
        toggleConfirmCalls: { value in
            UserDefaults.standard.set(value, forKey: "sosuzagram_confirm_calls")
            updateSettingsImpl?()
        },
        toggleConfirmVoiceMessages: { value in
            UserDefaults.standard.set(value, forKey: "sosuzagram_confirm_voice_messages")
            updateSettingsImpl?()
        },
        toggleHideShareButton: { value in
            UserDefaults.standard.set(value, forKey: "sosuzagram_hide_share_button")
            updateSettingsImpl?()
        },
        togglePollResultsBeforeVoting: { value in
            UserDefaults.standard.set(value, forKey: "sosuzagram_poll_results_before_voting")
            updateSettingsImpl?()
        },
        toggleMessageMenuEnabled: { value in
            UserDefaults.standard.set(value, forKey: "sosuzagram_message_menu_enabled")
            updateSettingsImpl?()
        },
        toggleGroupMessageMenu: { value in
            UserDefaults.standard.set(value, forKey: "sosuzagram_group_message_menu")
            updateSettingsImpl?()
        },
        toggleHideKeyboardOnScroll: { value in
            UserDefaults.standard.set(value, forKey: "sosuzagram_hide_keyboard_on_scroll")
            updateSettingsImpl?()
        },
        toggleHideSendAsButton: { value in
            UserDefaults.standard.set(value, forKey: "sosuzagram_hide_send_as_button")
            updateSettingsImpl?()
        },
        toggleReplaceEditedWithIcon: { value in
            UserDefaults.standard.set(value, forKey: "sosuzagram_replace_edited_with_icon")
            updateSettingsImpl?()
        },
        toggleHideFloatingButton: { value in
            UserDefaults.standard.set(value, forKey: "sosuzagram_hide_floating_button")
            updateSettingsImpl?()
        },
        toggleHideAllChatsTab: { value in
            UserDefaults.standard.set(value, forKey: "sosuzagram_hide_all_chats_tab")
            updateSettingsImpl?()
        },
        toggleHideGreetingSticker: { value in
            UserDefaults.standard.set(value, forKey: "sosuzagram_hide_greeting_sticker")
            updateSettingsImpl?()
        },
        toggleHideStickerTimestamp: { value in
            UserDefaults.standard.set(value, forKey: "sosuzagram_hide_sticker_timestamp")
            updateSettingsImpl?()
        },
        toggleDisableCompactNumericCounts: { value in
            UserDefaults.standard.set(value, forKey: "sosuzagram_disable_compact_numeric_counts")
            updateSettingsImpl?()
        },
        toggleFormatTimeWithSeconds: { value in
            UserDefaults.standard.set(value, forKey: "sosuzagram_format_time_with_seconds")
            updateSettingsImpl?()
        },
        toggleCommaAfterMention: { value in
            UserDefaults.standard.set(value, forKey: "sosuzagram_comma_after_mention")
            updateSettingsImpl?()
        },
        toggleShowOnlineIndicator: { value in
            UserDefaults.standard.set(value, forKey: "sosuzagram_show_online_indicator")
            updateSettingsImpl?()
        },
        toggleHideMessageTail: { value in
            UserDefaults.standard.set(value, forKey: "sosuzagram_hide_message_tail")
            updateSettingsImpl?()
        },
        toggleCenterChatListTitle: { value in
            UserDefaults.standard.set(value, forKey: "sosuzagram_center_chat_list_title")
            updateSettingsImpl?()
        },
        toggleUseYandexMaps: { value in
            UserDefaults.standard.set(value, forKey: "sosuzagram_use_yandex_maps")
            updateSettingsImpl?()
        },
        toggleHideChatListStatus: { value in
            UserDefaults.standard.set(value, forKey: "sosuzagram_hide_chat_list_status")
            updateSettingsImpl?()
        },
        toggleHideArchiveFromList: { value in
            UserDefaults.standard.set(value, forKey: "sosuzagram_hide_archive_from_list")
            updateSettingsImpl?()
        },
        toggleOpenArchiveOnPull: { value in
            UserDefaults.standard.set(value, forKey: "sosuzagram_open_archive_on_pull")
            updateSettingsImpl?()
        },
        toggleDisableArchiveReturnGesture: { value in
            UserDefaults.standard.set(value, forKey: "sosuzagram_disable_archive_return_gesture")
            updateSettingsImpl?()
        },
        toggleRelativeOnlineTime: { value in
            UserDefaults.standard.set(value, forKey: "sosuzagram_relative_online_time")
            updateSettingsImpl?()
        },
        toggleHidePhoneNumber: { value in
            UserDefaults.standard.set(value, forKey: "sosuzagram_hide_phone_number")
            updateSettingsImpl?()
        },
        toggleShowIdDc: { value in
            UserDefaults.standard.set(value, forKey: "sosuzagram_show_id_dc")
            updateSettingsImpl?()
        },
        toggleFilterZalgo: { value in
            UserDefaults.standard.set(value, forKey: "sosuzagram_filter_zalgo")
            updateSettingsImpl?()
        },
        toggleAppVibration: { value in
            UserDefaults.standard.set(value, forKey: "sosuzagram_app_vibration")
            updateSettingsImpl?()
        },
        toggleShowTranslateMessages: { value in
            let _ = updateTranslationSettingsInteractively(accountManager: context.sharedContext.accountManager, { current in
                current.withUpdatedShowTranslate(value)
            }).start()
            updateSettingsImpl?()
        },
        toggleTranslateEntireChats: { value in
            let _ = updateTranslationSettingsInteractively(accountManager: context.sharedContext.accountManager, { current in
                current.withUpdatedTranslateChats(value)
            }).start()
            updateSettingsImpl?()
        },
        openTranslationProvider: {
            openTranslationProviderImpl?()
        },
        openTranslationTarget: {
            openTranslationTargetImpl?()
        },
        openVoiceRecognitionLocale: {
            openVoiceRecognitionLocaleImpl?()
        },
        toggleVoiceRecognitionOnDevice: { value in
            UserDefaults.standard.set(value, forKey: "sosuzagram_voice_recognition_on_device")
            updateSettingsImpl?()
        },
        toggleHideReactions: { value in
            UserDefaults.standard.set(value, forKey: "sosuzagram_hide_reactions")
            updateSettingsImpl?()
        },
        openDownloadAcceleration: {
            openDownloadAccelerationImpl?()
        },
        toggleUploadAcceleration: { value in
            UserDefaults.standard.set(value, forKey: "sosuzagram_upload_acceleration")
            updateSettingsImpl?()
        },
        toggleAlwaysSendHd: { value in
            UserDefaults.standard.set(value, forKey: "sosuzagram_always_send_hd")
            updateSettingsImpl?()
        },
        toggleHidePhotoCounter: { value in
            UserDefaults.standard.set(value, forKey: "sosuzagram_hide_photo_counter")
            updateSettingsImpl?()
        },
        toggleHideCameraTile: { value in
            UserDefaults.standard.set(value, forKey: "sosuzagram_hide_camera_tile")
            updateSettingsImpl?()
        },
        toggleEnableSoundWithVolumeButtons: { value in
            UserDefaults.standard.set(value, forKey: "sosuzagram_enable_sound_with_volume_buttons")
            updateSettingsImpl?()
        },
        togglePreferOriginalQuality: { value in
            UserDefaults.standard.set(value, forKey: "sosuzagram_prefer_original_quality")
            updateSettingsImpl?()
        },
        togglePictureInPictureSwipe: { value in
            UserDefaults.standard.set(value, forKey: "sosuzagram_picture_in_picture_swipe")
            updateSettingsImpl?()
        },
        toggleStaticZoom: { value in
            UserDefaults.standard.set(value, forKey: "sosuzagram_static_zoom")
            updateSettingsImpl?()
        },
        toggleRememberLastCamera: { value in
            UserDefaults.standard.set(value, forKey: "sosuzagram_remember_last_camera")
            updateSettingsImpl?()
        },
        toggleUnifiedRounding: { value in
            UserDefaults.standard.set(value, forKey: "sosuzagram_unified_rounding")
            updateSettingsImpl?()
        },
        toggleMiniAvatars: { value in
            UserDefaults.standard.set(value, forKey: "sosuzagram_mini_avatars")
            updateSettingsImpl?()
        },
        toggleDisableSeparators: { value in
            UserDefaults.standard.set(value, forKey: "sosuzagram_disable_separators")
            updateSettingsImpl?()
        },
        toggleSeparateHeaders: { value in
            UserDefaults.standard.set(value, forKey: "sosuzagram_separate_headers")
            updateSettingsImpl?()
        },
        toggleChatThemes: { value in
            UserDefaults.standard.set(value, forKey: "sosuzagram_chat_themes")
            updateSettingsImpl?()
        },
        toggleGlassHighlights: { value in
            UserDefaults.standard.set(value, forKey: "sosuzagram_glass_highlights")
            updateSettingsImpl?()
        },
        toggleForceBlur: { value in
            UserDefaults.standard.set(value, forKey: "sosuzagram_force_blur")
            updateSettingsImpl?()
            promptForceBlurRestartImpl?(value)
        },
        toggleAndroidDesign: { value in
            sosuzagramApplyAndroidDesignPreset(value)
            updateSettingsImpl?()
            promptAndroidDesignRestartImpl?(value)
        },
        toggleSmoothAnimations: { value in
            UserDefaults.standard.set(value, forKey: "sosuzagram_smooth_animations")
            updateSettingsImpl?()
        },
        toggleSystemFonts: { value in
            UserDefaults.standard.set(value, forKey: "sosuzagram_system_fonts")
            updateSettingsImpl?()
        },
        toggleSystemEmoji: { value in
            UserDefaults.standard.set(value, forKey: "sosuzagram_system_emoji")
            updateSettingsImpl?()
        },
        toggleStickyAvatarAnimation: { value in
            UserDefaults.standard.set(value, forKey: "sosuzagram_sticky_avatar_animation")
            updateSettingsImpl?()
        },
        toggleShowFolderBadges: { value in
            UserDefaults.standard.set(value, forKey: "sosuzagram_show_folder_badges")
            updateSettingsImpl?()
        },
        toggleForceSnow: { value in
            UserDefaults.standard.set(value, forKey: "sosuzagram_force_snow")
            updateSettingsImpl?()
        },
        toggleDoubleTapSeek: { value in
            UserDefaults.standard.set(value, forKey: "sosuzagram_double_tap_seek")
            updateSettingsImpl?()
        },
        toggleInfiniteRecentStickers: { value in
            UserDefaults.standard.set(value, forKey: "sosuzagram_infinite_recent_stickers")
            updateSettingsImpl?()
        },
        toggleLowerNavigationButton: { value in
            UserDefaults.standard.set(value, forKey: "sosuzagram_lower_button")
            updateSettingsImpl?()
        },
        toggleQuickAdminActions: { value in
            UserDefaults.standard.set(value, forKey: "sosuzagram_quick_admin_actions")
            updateSettingsImpl?()
        },
        toggleAdvancedCameraSettings: { value in
            UserDefaults.standard.set(value, forKey: "sosuzagram_advanced_camera_settings")
            updateSettingsImpl?()
        },
        openReplyStyle: {
            openReplyStyleImpl?()
        },
        openMessageMenuSettings: {
            openMessageMenuSettingsImpl?()
        },
        openPillStackMode: {
            openPillStackModeImpl?()
        },
        openNavigationInApp: {
            openNavigationInAppImpl?()
        },
        openIconPacks: {
            openIconPacksImpl?()
        },
        openIncomingDoubleTapAction: {
            openIncomingDoubleTapActionImpl?()
        },
        openOutgoingDoubleTapAction: {
            openOutgoingDoubleTapActionImpl?()
        },
        openStickerSizePreset: {
            openStickerSizePresetImpl?()
        },
        openStickerShape: {
            openStickerShapeImpl?()
        },
        openCameraType: {
            openCameraTypeImpl?()
        },
        openVideoMessageCamera: {
            openVideoMessageCameraImpl?()
        },
        openAvatarShape: {
            openAvatarShapeImpl?()
        },
        openMaterialDesignLevel: {
            openMaterialDesignLevelImpl?()
        },
        openChatListTitleText: {
            openChatListTitleTextImpl?()
        },
        openFolderTabTitles: {
            openFolderTabTitlesImpl?()
        },
        openDoNotTranslateLanguages: {
            openDoNotTranslateLanguagesImpl?()
        },
        openLocalizationSettings: {
            openLocalizationSettingsImpl?()
        },
        openThemeSettings: {
            openThemeSettingsImpl?()
        },
        openChatFoldersSettings: {
            openChatFoldersSettingsImpl?()
        },
        selectIcon: { iconName in
            let targetName = iconName == "nil" ? nil : iconName
            if UIApplication.shared.supportsAlternateIcons {
                UIApplication.shared.setAlternateIconName(targetName) { error in
                    if let error {
                        print("Error setting alternate icon: \(error.localizedDescription)")
                    }
                }
            }
            UserDefaults.standard.set(iconName, forKey: "sosuzagram_current_icon")
            updateSettingsImpl?()
        },
        openPlugin: { pluginId in
            openPluginImpl?(pluginId)
        },
        importPlugin: {
            importPluginImpl?()
        }
    )

    let signal = combineLatest(
        context.sharedContext.presentationData,
        context.sharedContext.accountManager.sharedData(keys: [
            ApplicationSpecificSharedDataKeys.experimentalUISettings,
            ApplicationSpecificSharedDataKeys.translationSettings
        ]),
        statePromise.get()
    )
    |> map { presentationData, sharedData, _ -> (ItemListControllerState, (ItemListNodeState, Any)) in
        let experimentalSettings = sharedData.entries[ApplicationSpecificSharedDataKeys.experimentalUISettings]?.get(ExperimentalUISettings.self) ?? ExperimentalUISettings.defaultSettings
        let translationSettings = sharedData.entries[ApplicationSpecificSharedDataKeys.translationSettings]?.get(TranslationSettings.self) ?? TranslationSettings.defaultSettings
        let skipReadHistory = experimentalSettings.skipReadHistory
        let hideStoryViews = UserDefaults.standard.bool(forKey: "sosuzagram_hide_story_views")
        let hideTyping = UserDefaults.standard.bool(forKey: "sosuzagram_hide_typing")
        let keepLocalHistory = UserDefaults.standard.object(forKey: "sosuzagram_local_history") as? Bool ?? true
        let showMarker = UserDefaults.standard.object(forKey: "sosuzagram_show_marker") as? Bool ?? true
        let hideStories = UserDefaults.standard.bool(forKey: "sosuzagram_hide_stories")
        let confirmCalls = UserDefaults.standard.bool(forKey: "sosuzagram_confirm_calls")
        let confirmVoiceMessages = UserDefaults.standard.bool(forKey: "sosuzagram_confirm_voice_messages")
        let hideShareButton = UserDefaults.standard.bool(forKey: "sosuzagram_hide_share_button")
        let pollResultsBeforeVoting = UserDefaults.standard.bool(forKey: "sosuzagram_poll_results_before_voting")
        let messageMenuEnabled = UserDefaults.standard.bool(forKey: "sosuzagram_message_menu_enabled")
        let groupMessageMenu = UserDefaults.standard.bool(forKey: "sosuzagram_group_message_menu")
        let hideKeyboardOnScroll = UserDefaults.standard.bool(forKey: "sosuzagram_hide_keyboard_on_scroll")
        let hideSendAsButton = UserDefaults.standard.bool(forKey: "sosuzagram_hide_send_as_button")
        let replaceEditedWithIcon = UserDefaults.standard.bool(forKey: "sosuzagram_replace_edited_with_icon")
        let hideFloatingButton = UserDefaults.standard.bool(forKey: "sosuzagram_hide_floating_button")
        let hideAllChatsTab = UserDefaults.standard.bool(forKey: "sosuzagram_hide_all_chats_tab")
        let hideGreetingSticker = UserDefaults.standard.bool(forKey: "sosuzagram_hide_greeting_sticker")
        let hideStickerTimestamp = UserDefaults.standard.bool(forKey: "sosuzagram_hide_sticker_timestamp")
        let disableCompactNumericCounts = UserDefaults.standard.bool(forKey: "sosuzagram_disable_compact_numeric_counts")
        let formatTimeWithSeconds = UserDefaults.standard.bool(forKey: "sosuzagram_format_time_with_seconds")
        let commaAfterMention = UserDefaults.standard.bool(forKey: "sosuzagram_comma_after_mention")
        let showOnlineIndicator = UserDefaults.standard.bool(forKey: "sosuzagram_show_online_indicator")
        let hideMessageTail = UserDefaults.standard.bool(forKey: "sosuzagram_hide_message_tail")
        let centerChatListTitle = UserDefaults.standard.bool(forKey: "sosuzagram_center_chat_list_title")
        let useYandexMaps = UserDefaults.standard.bool(forKey: "sosuzagram_use_yandex_maps")
        let hideChatListStatus = UserDefaults.standard.bool(forKey: "sosuzagram_hide_chat_list_status")
        let hideArchiveFromList = UserDefaults.standard.bool(forKey: "sosuzagram_hide_archive_from_list")
        let openArchiveOnPull = UserDefaults.standard.bool(forKey: "sosuzagram_open_archive_on_pull")
        let disableArchiveReturnGesture = UserDefaults.standard.bool(forKey: "sosuzagram_disable_archive_return_gesture")
        let relativeOnlineTime = UserDefaults.standard.bool(forKey: "sosuzagram_relative_online_time")
        let hidePhoneNumber = UserDefaults.standard.bool(forKey: "sosuzagram_hide_phone_number")
        let showIdDc = UserDefaults.standard.bool(forKey: "sosuzagram_show_id_dc")
        let filterZalgo = UserDefaults.standard.bool(forKey: "sosuzagram_filter_zalgo")
        let appVibration = UserDefaults.standard.object(forKey: "sosuzagram_app_vibration") as? Bool ?? true
        let showTranslateMessages = translationSettings.showTranslate
        let translateEntireChats = translationSettings.translateChats
        let translationProvider = UserDefaults.standard.string(forKey: "sosuzagram_translation_provider") ?? "telegram"
        let translationTarget = UserDefaults.standard.string(forKey: "sosuzagram_translation_target") ?? "app"
        let doNotTranslateSummary = sosuzagramDoNotTranslateSummary(translationSettings.ignoredLanguages)
        let voiceRecognitionLocale = UserDefaults.standard.string(forKey: "sosuzagram_voice_recognition_locale") ?? "system"
        let voiceRecognitionOnDevice = UserDefaults.standard.object(forKey: "sosuzagram_voice_recognition_on_device") as? Bool ?? false
        let hideReactions = UserDefaults.standard.bool(forKey: "sosuzagram_hide_reactions")
        let downloadAcceleration = UserDefaults.standard.string(forKey: "sosuzagram_download_acceleration") ?? "default"
        let uploadAcceleration = UserDefaults.standard.bool(forKey: "sosuzagram_upload_acceleration")
        let alwaysSendHd = UserDefaults.standard.bool(forKey: "sosuzagram_always_send_hd")
        let hidePhotoCounter = UserDefaults.standard.bool(forKey: "sosuzagram_hide_photo_counter")
        let hideCameraTile = UserDefaults.standard.bool(forKey: "sosuzagram_hide_camera_tile")
        let enableSoundWithVolumeButtons = UserDefaults.standard.object(forKey: "sosuzagram_enable_sound_with_volume_buttons") as? Bool ?? true
        let advancedCameraSettings = UserDefaults.standard.object(forKey: "sosuzagram_advanced_camera_settings") as? Bool ?? true
        let preferOriginalQuality = UserDefaults.standard.bool(forKey: "sosuzagram_prefer_original_quality")
        let pictureInPictureSwipe = UserDefaults.standard.object(forKey: "sosuzagram_picture_in_picture_swipe") as? Bool ?? true
        let staticZoom = UserDefaults.standard.bool(forKey: "sosuzagram_static_zoom")
        let rememberLastCamera = UserDefaults.standard.bool(forKey: "sosuzagram_remember_last_camera")
        let cameraType = UserDefaults.standard.string(forKey: "sosuzagram_camera_type") ?? "system"
        let videoMessageCamera = UserDefaults.standard.string(forKey: "sosuzagram_video_message_camera") ?? "system"
        let doubleTapSeek = UserDefaults.standard.bool(forKey: "sosuzagram_double_tap_seek")
        let infiniteRecentStickers = UserDefaults.standard.bool(forKey: "sosuzagram_infinite_recent_stickers")
        let lowerNavigationButton = UserDefaults.standard.bool(forKey: "sosuzagram_lower_button")
        let quickAdminActions = UserDefaults.standard.bool(forKey: "sosuzagram_quick_admin_actions")
        let incomingDoubleTapAction = sosuzagramDoubleTapAction(incoming: true)
        let outgoingDoubleTapAction = sosuzagramDoubleTapAction(incoming: false)
        let stickerSizePreset = UserDefaults.standard.string(forKey: "sosuzagram_sticker_size_preset") ?? "medium"
        let stickerShape = UserDefaults.standard.string(forKey: "sosuzagram_sticker_shape") ?? "default"
        let avatarShape = UserDefaults.standard.string(forKey: "sosuzagram_avatar_shape") ?? "system"
        let unifiedRounding = UserDefaults.standard.bool(forKey: "sosuzagram_unified_rounding")
        let miniAvatars = UserDefaults.standard.bool(forKey: "sosuzagram_mini_avatars")
        let disableSeparators = UserDefaults.standard.bool(forKey: "sosuzagram_disable_separators")
        let separateHeaders = UserDefaults.standard.bool(forKey: "sosuzagram_separate_headers")
        let chatThemes = UserDefaults.standard.object(forKey: "sosuzagram_chat_themes") as? Bool ?? true
        let materialDesignLevel = max(0, min(3, UserDefaults.standard.integer(forKey: "sosuzagram_material_design_level")))
        let chatListTitleText = UserDefaults.standard.string(forKey: "sosuzagram_chat_list_title_text") ?? "name"
        let folderTabTitles = UserDefaults.standard.string(forKey: "sosuzagram_folder_tab_titles") ?? "title_and_icon"
        let glassHighlights = UserDefaults.standard.object(forKey: "sosuzagram_glass_highlights") as? Bool ?? true
        let forceBlur = UserDefaults.standard.bool(forKey: "sosuzagram_force_blur")
        let androidDesign = UserDefaults.standard.bool(forKey: "sosuzagram_android_design")
        let smoothAnimations = UserDefaults.standard.bool(forKey: "sosuzagram_smooth_animations")
        let systemFonts = UserDefaults.standard.bool(forKey: "sosuzagram_system_fonts")
        let systemEmoji = UserDefaults.standard.bool(forKey: "sosuzagram_system_emoji")
        let stickyAvatarAnimation = UserDefaults.standard.bool(forKey: "sosuzagram_sticky_avatar_animation")
        let showFolderBadges = UserDefaults.standard.object(forKey: "sosuzagram_show_folder_badges") as? Bool ?? true
        let pillStackMode = UserDefaults.standard.string(forKey: "sosuzagram_pill_stack_mode") ?? "off"
        let forceSnow = UserDefaults.standard.bool(forKey: "sosuzagram_force_snow")
        let currentIcon = UserDefaults.standard.string(forKey: "sosuzagram_current_icon") ?? "nil"
        let plugins = sosuzagramBuiltInPlugins()

        let controllerState = ItemListControllerState(
            presentationData: ItemListPresentationData(presentationData),
            title: .text(category?.title ?? "Sosuzagram"),
            leftNavigationButton: nil,
            rightNavigationButton: nil,
            backNavigationButton: ItemListBackButton(title: presentationData.strings.Common_Back)
        )

        let allEntries = sosuzagramSettingsEntries(
            presentationData: presentationData,
            skipReadHistory: skipReadHistory,
            hideStoryViews: hideStoryViews,
            hideTyping: hideTyping,
            keepLocalHistory: keepLocalHistory,
            showMarker: showMarker,
            hideStories: hideStories,
            confirmCalls: confirmCalls,
            confirmVoiceMessages: confirmVoiceMessages,
            hideShareButton: hideShareButton,
            pollResultsBeforeVoting: pollResultsBeforeVoting,
            messageMenuEnabled: messageMenuEnabled,
            groupMessageMenu: groupMessageMenu,
            hideKeyboardOnScroll: hideKeyboardOnScroll,
            hideSendAsButton: hideSendAsButton,
            replaceEditedWithIcon: replaceEditedWithIcon,
            hideFloatingButton: hideFloatingButton,
            hideAllChatsTab: hideAllChatsTab,
            hideGreetingSticker: hideGreetingSticker,
            hideStickerTimestamp: hideStickerTimestamp,
            disableCompactNumericCounts: disableCompactNumericCounts,
            formatTimeWithSeconds: formatTimeWithSeconds,
            commaAfterMention: commaAfterMention,
            showOnlineIndicator: showOnlineIndicator,
            hideMessageTail: hideMessageTail,
            centerChatListTitle: centerChatListTitle,
            useYandexMaps: useYandexMaps,
            hideChatListStatus: hideChatListStatus,
            hideArchiveFromList: hideArchiveFromList,
            openArchiveOnPull: openArchiveOnPull,
            disableArchiveReturnGesture: disableArchiveReturnGesture,
            relativeOnlineTime: relativeOnlineTime,
            hidePhoneNumber: hidePhoneNumber,
            showIdDc: showIdDc,
            filterZalgo: filterZalgo,
            appVibration: appVibration,
            showTranslateMessages: showTranslateMessages,
            translateEntireChats: translateEntireChats,
            translationProvider: translationProvider,
            translationTarget: translationTarget,
            doNotTranslateSummary: doNotTranslateSummary,
            voiceRecognitionLocale: voiceRecognitionLocale,
            voiceRecognitionOnDevice: voiceRecognitionOnDevice,
            hideReactions: hideReactions,
            downloadAcceleration: downloadAcceleration,
            uploadAcceleration: uploadAcceleration,
            alwaysSendHd: alwaysSendHd,
            hidePhotoCounter: hidePhotoCounter,
            hideCameraTile: hideCameraTile,
            enableSoundWithVolumeButtons: enableSoundWithVolumeButtons,
            advancedCameraSettings: advancedCameraSettings,
            preferOriginalQuality: preferOriginalQuality,
            pictureInPictureSwipe: pictureInPictureSwipe,
            staticZoom: staticZoom,
            rememberLastCamera: rememberLastCamera,
            cameraType: cameraType,
            videoMessageCamera: videoMessageCamera,
            doubleTapSeek: doubleTapSeek,
            infiniteRecentStickers: infiniteRecentStickers,
            lowerNavigationButton: lowerNavigationButton,
            quickAdminActions: quickAdminActions,
            replyStyle: UserDefaults.standard.string(forKey: "sosuzagram_reply_style") ?? "default",
            incomingDoubleTapAction: incomingDoubleTapAction,
            outgoingDoubleTapAction: outgoingDoubleTapAction,
            stickerSizePreset: stickerSizePreset,
            stickerShape: stickerShape,
            avatarShape: avatarShape,
            unifiedRounding: unifiedRounding,
            miniAvatars: miniAvatars,
            disableSeparators: disableSeparators,
            separateHeaders: separateHeaders,
            chatThemes: chatThemes,
            materialDesignLevel: materialDesignLevel,
            chatListTitleText: chatListTitleText,
            folderTabTitles: folderTabTitles,
            glassHighlights: glassHighlights,
            forceBlur: forceBlur,
            androidDesign: androidDesign,
            smoothAnimations: smoothAnimations,
            systemFonts: systemFonts,
            systemEmoji: systemEmoji,
            stickyAvatarAnimation: stickyAvatarAnimation,
            showFolderBadges: showFolderBadges,
            pillStackMode: pillStackMode,
            forceSnow: forceSnow,
            currentIcon: currentIcon,
            plugins: plugins
        )

        let entries: [SosuzagramSettingsEntry]
        if let category {
            entries = sosuzagramFilterEntries(allEntries, category: category)
        } else {
            entries = sosuzagramOverviewEntries(
                presentationData: presentationData,
                allEntries: allEntries
            )
        }

        let listState = ItemListNodeState(
            presentationData: ItemListPresentationData(presentationData),
            entries: entries,
            style: .blocks,
            animateChanges: smoothAnimations || androidDesign
        )

        return (controllerState, (listState, arguments))
    }

    let controller = ItemListController(context: context, state: signal)
    updateSettingsImpl = {
        statePromise.set(true)
    }
    promptAndroidDesignRestartImpl = { [weak controller] value in
        guard let controller else {
            return
        }
        let text: String
        if value {
            text = "Android design Ð²ÐºÐ»ÑŽÑ‡Ñ‘Ð½. Ð”Ð»Ñ Ð¿Ð¾Ð»Ð½Ð¾Ð³Ð¾ Ð¿Ñ€Ð¸Ð¼ÐµÐ½ÐµÐ½Ð¸Ñ Ð¿Ñ€ÐµÑÐµÑ‚Ð° Exteragram Ð»ÑƒÑ‡ÑˆÐµ Ð¿ÐµÑ€ÐµÐ·Ð°Ð¿ÑƒÑÑ‚Ð¸Ñ‚ÑŒ Ð¿Ñ€Ð¸Ð»Ð¾Ð¶ÐµÐ½Ð¸Ðµ ÑÐµÐ¹Ñ‡Ð°Ñ."
        } else {
            text = "Android design Ð²Ñ‹ÐºÐ»ÑŽÑ‡ÐµÐ½. Ð§Ñ‚Ð¾Ð±Ñ‹ Ð¸Ð½Ñ‚ÐµÑ€Ñ„ÐµÐ¹Ñ Ð¿Ð¾Ð»Ð½Ð¾ÑÑ‚ÑŒÑŽ Ð²ÐµÑ€Ð½ÑƒÐ»ÑÑ Ðº Ð¾Ð±Ñ‹Ñ‡Ð½Ð¾Ð¼Ñƒ ÑÑ‚Ð¸Ð»ÑŽ, Ð¿ÐµÑ€ÐµÐ·Ð°Ð¿ÑƒÑÑ‚Ð¸ Ð¿Ñ€Ð¸Ð»Ð¾Ð¶ÐµÐ½Ð¸Ðµ."
        }
        controller.present(textAlertController(context: context, title: "Android design", text: text, actions: [
            TextAlertAction(type: .genericAction, title: "ÐŸÐ¾Ð·Ð¶Ðµ", action: {}),
            TextAlertAction(type: .defaultAction, title: "ÐŸÐµÑ€ÐµÐ·Ð°Ð¿ÑƒÑÑ‚Ð¸Ñ‚ÑŒ", action: {
                exit(0)
            })
        ]), in: .window(.root))
    }
    promptForceBlurRestartImpl = { [weak controller] value in
        guard let controller else {
            return
        }
        let text: String
        if value {
            text = "ÐŸÑ€Ð¸Ð½ÑƒÐ´Ð¸Ñ‚ÐµÐ»ÑŒÐ½Ð¾Ðµ Ñ€Ð°Ð·Ð¼Ñ‹Ñ‚Ð¸Ðµ Ð²ÐºÐ»ÑŽÑ‡ÐµÐ½Ð¾. Ð§Ñ‚Ð¾Ð±Ñ‹ blur/glass-ÑÐ»ÐµÐ¼ÐµÐ½Ñ‚Ñ‹ Ð³Ð°Ñ€Ð°Ð½Ñ‚Ð¸Ñ€Ð¾Ð²Ð°Ð½Ð½Ð¾ Ð¿ÐµÑ€ÐµÑÐ¾Ð·Ð´Ð°Ð»Ð¸ÑÑŒ Ð²Ð¾ Ð²ÑÑ‘Ð¼ Ð¿Ñ€Ð¸Ð»Ð¾Ð¶ÐµÐ½Ð¸Ð¸, Ð»ÑƒÑ‡ÑˆÐµ Ð¿ÐµÑ€ÐµÐ·Ð°Ð¿ÑƒÑÑ‚Ð¸Ñ‚ÑŒ ÐµÐ³Ð¾ ÑÐµÐ¹Ñ‡Ð°Ñ."
        } else {
            text = "ÐŸÑ€Ð¸Ð½ÑƒÐ´Ð¸Ñ‚ÐµÐ»ÑŒÐ½Ð¾Ðµ Ñ€Ð°Ð·Ð¼Ñ‹Ñ‚Ð¸Ðµ Ð²Ñ‹ÐºÐ»ÑŽÑ‡ÐµÐ½Ð¾. Ð§Ñ‚Ð¾Ð±Ñ‹ blur/glass-ÑÐ»ÐµÐ¼ÐµÐ½Ñ‚Ñ‹ Ð²ÐµÑ€Ð½ÑƒÐ»Ð¸ÑÑŒ Ðº Ð¾Ð±Ñ‹Ñ‡Ð½Ð¾Ð¼Ñƒ Ñ€ÐµÐ¶Ð¸Ð¼Ñƒ Ð±ÐµÐ· ÑÐ¼ÐµÑˆÐ°Ð½Ð½Ñ‹Ñ… ÑÐ¾ÑÑ‚Ð¾ÑÐ½Ð¸Ð¹, Ð»ÑƒÑ‡ÑˆÐµ Ð¿ÐµÑ€ÐµÐ·Ð°Ð¿ÑƒÑÑ‚Ð¸Ñ‚ÑŒ Ð¿Ñ€Ð¸Ð»Ð¾Ð¶ÐµÐ½Ð¸Ðµ."
        }
        controller.present(textAlertController(context: context, title: "ÐŸÑ€Ð¸Ð½ÑƒÐ´Ð¸Ñ‚ÐµÐ»ÑŒÐ½Ð¾Ðµ Ñ€Ð°Ð·Ð¼Ñ‹Ñ‚Ð¸Ðµ", text: text, actions: [
            TextAlertAction(type: .genericAction, title: "ÐŸÐ¾Ð·Ð¶Ðµ", action: {}),
            TextAlertAction(type: .defaultAction, title: "ÐŸÐµÑ€ÐµÐ·Ð°Ð¿ÑƒÑÑ‚Ð¸Ñ‚ÑŒ", action: {
                exit(0)
            })
        ]), in: .window(.root))
    }
    openCategoryImpl = { [weak controller] selectedCategory in
        controller?.push(sosuzagramSettingsCategoryController(context: context, category: selectedCategory))
    }
    openMessageMenuSettingsImpl = { [weak controller] in
        controller?.push(sosuzagramMessageMenuSettingsController(context: context, onUpdate: {
            updateSettingsImpl?()
        }))
    }
    openVoiceRecognitionLocaleImpl = { [weak controller] in
        guard let controller else {
            return
        }
        let presentationData = context.sharedContext.currentPresentationData.with { $0 }
        let currentValue = UserDefaults.standard.string(forKey: "sosuzagram_voice_recognition_locale") ?? "system"
        let options: [(String, String)] = [
            ("system", "Ð¡Ð¸ÑÑ‚ÐµÐ¼Ð½Ñ‹Ð¹"),
            ("ru-RU", "Ð ÑƒÑÑÐºÐ¸Ð¹"),
            ("en-US", "English"),
            ("uk-UA", "Ð£ÐºÑ€Ð°Ñ—Ð½ÑÑŒÐºÐ°")
        ]

        let actionSheet = ActionSheetController(presentationData: presentationData)
        var items: [ActionSheetItem] = [ActionSheetTextItem(title: "Ð¯Ð·Ñ‹Ðº Ñ€Ð°ÑÐ¿Ð¾Ð·Ð½Ð°Ð²Ð°Ð½Ð¸Ñ")]
        for (value, title) in options {
            let itemTitle = value == currentValue ? "[selected] \(title)" : title
            items.append(ActionSheetButtonItem(title: itemTitle, color: .accent, action: { [weak actionSheet] in
                actionSheet?.dismissAnimated()
                UserDefaults.standard.set(value, forKey: "sosuzagram_voice_recognition_locale")
                updateSettingsImpl?()
            }))
        }
        actionSheet.setItemGroups([
            ActionSheetItemGroup(items: items),
            ActionSheetItemGroup(items: [
                ActionSheetButtonItem(title: presentationData.strings.Common_Cancel, color: .accent, font: .bold, action: { [weak actionSheet] in
                    actionSheet?.dismissAnimated()
                })
            ])
        ])
        controller.present(actionSheet, in: .window(.root))
    }
    openDownloadAccelerationImpl = { [weak controller] in
        guard let controller else {
            return
        }
        let presentationData = context.sharedContext.currentPresentationData.with { $0 }
        let currentValue = UserDefaults.standard.string(forKey: "sosuzagram_download_acceleration") ?? "default"
        let options: [(String, String)] = [
            ("default", "ÐžÐ±Ñ‹Ñ‡Ð½Ð°Ñ"),
            ("fast", "Ð‘Ñ‹ÑÑ‚Ñ€Ð¾"),
            ("faster", "Ð‘Ñ‹ÑÑ‚Ñ€ÐµÐµ")
        ]

        let actionSheet = ActionSheetController(presentationData: presentationData)
        var items: [ActionSheetItem] = [ActionSheetTextItem(title: "Ð£ÑÐºÐ¾Ñ€ÐµÐ½Ð¸Ðµ Ð·Ð°Ð³Ñ€ÑƒÐ·ÐºÐ¸")]
        for (value, title) in options {
            let itemTitle = value == currentValue ? "[selected] \(title)" : title
            items.append(ActionSheetButtonItem(title: itemTitle, color: .accent, action: { [weak actionSheet] in
                actionSheet?.dismissAnimated()
                UserDefaults.standard.set(value, forKey: "sosuzagram_download_acceleration")
                updateSettingsImpl?()
            }))
        }
        actionSheet.setItemGroups([
            ActionSheetItemGroup(items: items),
            ActionSheetItemGroup(items: [
                ActionSheetButtonItem(title: presentationData.strings.Common_Cancel, color: .accent, font: .bold, action: { [weak actionSheet] in
                    actionSheet?.dismissAnimated()
                })
            ])
        ])
        controller.present(actionSheet, in: .window(.root))
    }
    openStickerSizePresetImpl = { [weak controller] in
        guard let controller else {
            return
        }
        let presentationData = context.sharedContext.currentPresentationData.with { $0 }
        let currentPreset = UserDefaults.standard.string(forKey: "sosuzagram_sticker_size_preset") ?? "medium"
        let presets: [(String, String)] = [
            ("small", "ÃÅ“ÃÂ°ÃÂ»ÃÂµÃÂ½Ã‘Å’ÃÂºÃÂ¸ÃÂ¹"),
            ("medium", "ÃÂ¡Ã‘â‚¬ÃÂµÃÂ´ÃÂ½ÃÂ¸ÃÂ¹"),
            ("large", "Ãâ€˜ÃÂ¾ÃÂ»Ã‘Å’Ã‘Ë†ÃÂ¾ÃÂ¹")
        ]

        let actionSheet = ActionSheetController(presentationData: presentationData)
        var items: [ActionSheetItem] = [ActionSheetTextItem(title: "ÃÂ ÃÂ°ÃÂ·ÃÂ¼ÃÂµÃ‘â‚¬ Ã‘ÂÃ‘â€šÃÂ¸ÃÂºÃÂµÃ‘â‚¬ÃÂ¾ÃÂ²")]
        for (value, title) in presets {
            let itemTitle = value == currentPreset ? "[selected] \(title)" : title
            items.append(ActionSheetButtonItem(title: itemTitle, color: .accent, action: { [weak actionSheet] in
                actionSheet?.dismissAnimated()
                UserDefaults.standard.set(value, forKey: "sosuzagram_sticker_size_preset")
                updateSettingsImpl?()
            }))
        }
        actionSheet.setItemGroups([
            ActionSheetItemGroup(items: items),
            ActionSheetItemGroup(items: [
                ActionSheetButtonItem(title: presentationData.strings.Common_Cancel, color: .accent, font: .bold, action: { [weak actionSheet] in
                    actionSheet?.dismissAnimated()
                })
            ])
        ])
        controller.present(actionSheet, in: .window(.root))
    }
    openStickerShapeImpl = { [weak controller] in
        guard let controller else {
            return
        }
        let presentationData = context.sharedContext.currentPresentationData.with { $0 }
        let currentValue = UserDefaults.standard.string(forKey: "sosuzagram_sticker_shape") ?? "default"
        let options: [(String, String)] = [
            ("default", "ÐŸÐ¾ ÑƒÐ¼Ð¾Ð»Ñ‡Ð°Ð½Ð¸ÑŽ"),
            ("rounded", "Ð—Ð°ÐºÑ€ÑƒÐ³Ð»Ñ‘Ð½Ð½Ð°Ñ"),
            ("message", "Ð¡Ð¾Ð¾Ð±Ñ‰ÐµÐ½Ð¸Ðµ")
        ]

        let actionSheet = ActionSheetController(presentationData: presentationData)
        var items: [ActionSheetItem] = [ActionSheetTextItem(title: "Ð¤Ð¾Ñ€Ð¼Ð° ÑÑ‚Ð¸ÐºÐµÑ€Ð¾Ð²")]
        for (value, title) in options {
            let itemTitle = value == currentValue ? "[selected] \(title)" : title
            items.append(ActionSheetButtonItem(title: itemTitle, color: .accent, action: { [weak actionSheet] in
                actionSheet?.dismissAnimated()
                UserDefaults.standard.set(value, forKey: "sosuzagram_sticker_shape")
                updateSettingsImpl?()
            }))
        }
        actionSheet.setItemGroups([
            ActionSheetItemGroup(items: items),
            ActionSheetItemGroup(items: [
                ActionSheetButtonItem(title: presentationData.strings.Common_Cancel, color: .accent, font: .bold, action: { [weak actionSheet] in
                    actionSheet?.dismissAnimated()
                })
            ])
        ])
        controller.present(actionSheet, in: .window(.root))
    }
    openCameraTypeImpl = { [weak controller] in
        guard let controller else {
            return
        }
        let presentationData = context.sharedContext.currentPresentationData.with { $0 }
        let currentValue = UserDefaults.standard.string(forKey: "sosuzagram_camera_type") ?? "system"
        let options: [(String, String)] = [
            ("system", "Ð¡Ð¸ÑÑ‚ÐµÐ¼Ð½Ð¾"),
            ("camera1", "Camera 1"),
            ("camera2", "Camera 2")
        ]

        let actionSheet = ActionSheetController(presentationData: presentationData)
        var items: [ActionSheetItem] = [ActionSheetTextItem(title: "Ð¢Ð¸Ð¿ ÐºÐ°Ð¼ÐµÑ€Ñ‹")]
        for (value, title) in options {
            let itemTitle = value == currentValue ? "[selected] \(title)" : title
            items.append(ActionSheetButtonItem(title: itemTitle, color: .accent, action: { [weak actionSheet] in
                actionSheet?.dismissAnimated()
                UserDefaults.standard.set(value, forKey: "sosuzagram_camera_type")
                updateSettingsImpl?()
            }))
        }
        actionSheet.setItemGroups([
            ActionSheetItemGroup(items: items),
            ActionSheetItemGroup(items: [
                ActionSheetButtonItem(title: presentationData.strings.Common_Cancel, color: .accent, font: .bold, action: { [weak actionSheet] in
                    actionSheet?.dismissAnimated()
                })
            ])
        ])
        controller.present(actionSheet, in: .window(.root))
    }
    openVideoMessageCameraImpl = { [weak controller] in
        guard let controller else {
            return
        }
        let presentationData = context.sharedContext.currentPresentationData.with { $0 }
        let currentValue = UserDefaults.standard.string(forKey: "sosuzagram_video_message_camera") ?? "system"
        let options: [(String, String)] = [
            ("system", "ÃÂ¡ÃÂ¸Ã‘ÂÃ‘â€šÃÂµÃÂ¼ÃÂ½ÃÂ¾"),
            ("front", "ÃÂ¤Ã‘â‚¬ÃÂ¾ÃÂ½Ã‘â€šÃÂ°ÃÂ»Ã‘Å’ÃÂ½ÃÂ°Ã‘Â"),
            ("back", "ÃÅ¾Ã‘ÂÃÂ½ÃÂ¾ÃÂ²ÃÂ½ÃÂ°Ã‘Â"),
            ("last", "ÃÅ¸ÃÂ¾Ã‘ÂÃÂ»ÃÂµÃÂ´ÃÂ½Ã‘ÂÃ‘Â")
        ]

        let actionSheet = ActionSheetController(presentationData: presentationData)
        var items: [ActionSheetItem] = [ActionSheetTextItem(title: "ÃÅ¡ÃÂ°ÃÂ¼ÃÂµÃ‘â‚¬ÃÂ° ÃÂ² ÃÂ²ÃÂ¸ÃÂ´ÃÂµÃÂ¾Ã‘ÂÃÂ¾ÃÂ¾ÃÂ±Ã‘â€°ÃÂµÃÂ½ÃÂ¸Ã‘ÂÃ‘â€¦")]
        for (value, title) in options {
            let itemTitle = value == currentValue ? "[selected] \(title)" : title
            items.append(ActionSheetButtonItem(title: itemTitle, color: .accent, action: { [weak actionSheet] in
                actionSheet?.dismissAnimated()
                UserDefaults.standard.set(value, forKey: "sosuzagram_video_message_camera")
                updateSettingsImpl?()
            }))
        }
        actionSheet.setItemGroups([
            ActionSheetItemGroup(items: items),
            ActionSheetItemGroup(items: [
                ActionSheetButtonItem(title: presentationData.strings.Common_Cancel, color: .accent, font: .bold, action: { [weak actionSheet] in
                    actionSheet?.dismissAnimated()
                })
            ])
        ])
        controller.present(actionSheet, in: .window(.root))
    }
    openAvatarShapeImpl = { [weak controller] in
        guard let controller else {
            return
        }
        let presentationData = context.sharedContext.currentPresentationData.with { $0 }
        let currentValue = UserDefaults.standard.string(forKey: "sosuzagram_avatar_shape") ?? "system"
        let options: [(String, String)] = [
            ("system", "ÃÂ¡ÃÂ¸Ã‘ÂÃ‘â€šÃÂµÃÂ¼ÃÂ½ÃÂ¾"),
            ("circle", "ÃÅ¡Ã‘â‚¬Ã‘Æ’ÃÂ³"),
            ("rounded", "ÃÂ¡ÃÂºÃ‘â‚¬Ã‘Æ’ÃÂ³ÃÂ»Ã‘â€˜ÃÂ½ÃÂ½ÃÂ°Ã‘Â"),
            ("square", "ÃÅ¡ÃÂ²ÃÂ°ÃÂ´Ã‘â‚¬ÃÂ°Ã‘â€š")
        ]

        let actionSheet = ActionSheetController(presentationData: presentationData)
        var items: [ActionSheetItem] = [ActionSheetTextItem(title: "ÃÂ¤ÃÂ¾Ã‘â‚¬ÃÂ¼ÃÂ° ÃÂ°ÃÂ²ÃÂ°Ã‘â€šÃÂ°Ã‘â‚¬ÃÂ¾ÃÂ²")]
        for (value, title) in options {
            let itemTitle = value == currentValue ? "[selected] \(title)" : title
            items.append(ActionSheetButtonItem(title: itemTitle, color: .accent, action: { [weak actionSheet] in
                actionSheet?.dismissAnimated()
                UserDefaults.standard.set(value, forKey: "sosuzagram_avatar_shape")
                updateSettingsImpl?()
            }))
        }
        actionSheet.setItemGroups([
            ActionSheetItemGroup(items: items),
            ActionSheetItemGroup(items: [
                ActionSheetButtonItem(title: presentationData.strings.Common_Cancel, color: .accent, font: .bold, action: { [weak actionSheet] in
                    actionSheet?.dismissAnimated()
                })
            ])
        ])
        controller.present(actionSheet, in: .window(.root))
    }
    openMaterialDesignLevelImpl = { [weak controller] in
        guard let controller else {
            return
        }
        let presentationData = context.sharedContext.currentPresentationData.with { $0 }
        let currentValue = max(0, min(3, UserDefaults.standard.integer(forKey: "sosuzagram_material_design_level")))
        let options: [(Int, String)] = [
            (0, "ÐžÑ‚ÐºÐ»ÑŽÑ‡ÐµÐ½Ð¾"),
            (1, "1/3"),
            (2, "2/3"),
            (3, "3/3")
        ]

        let actionSheet = ActionSheetController(presentationData: presentationData)
        var items: [ActionSheetItem] = [ActionSheetTextItem(title: "Material Design 3")]
        for (value, title) in options {
            let itemTitle = value == currentValue ? "[selected] \(title)" : title
            items.append(ActionSheetButtonItem(title: itemTitle, color: .accent, action: { [weak actionSheet] in
                actionSheet?.dismissAnimated()
                UserDefaults.standard.set(value, forKey: "sosuzagram_material_design_level")
                updateSettingsImpl?()
            }))
        }
        actionSheet.setItemGroups([
            ActionSheetItemGroup(items: items),
            ActionSheetItemGroup(items: [
                ActionSheetButtonItem(title: presentationData.strings.Common_Cancel, color: .accent, font: .bold, action: { [weak actionSheet] in
                    actionSheet?.dismissAnimated()
                })
            ])
        ])
        controller.present(actionSheet, in: .window(.root))
    }
    openReplyStyleImpl = { [weak controller] in
        guard let controller else {
            return
        }
        let presentationData = context.sharedContext.currentPresentationData.with { $0 }
        let currentValue = UserDefaults.standard.string(forKey: "sosuzagram_reply_style") ?? "default"
        let options: [(String, String)] = [
            ("default", "ÐŸÐ¾ ÑƒÐ¼Ð¾Ð»Ñ‡Ð°Ð½Ð¸ÑŽ"),
            ("rounded", "Ð—Ð°ÐºÑ€ÑƒÐ³Ð»Ñ‘Ð½Ð½Ñ‹Ðµ"),
            ("message", "Ð¡Ð¾Ð¾Ð±Ñ‰ÐµÐ½Ð¸Ñ")
        ]

        let actionSheet = ActionSheetController(presentationData: presentationData)
        var items: [ActionSheetItem] = [ActionSheetTextItem(title: "ÐžÑ‚Ð²ÐµÑ‚Ñ‹")]
        for (value, title) in options {
            let itemTitle = value == currentValue ? "[selected] \(title)" : title
            items.append(ActionSheetButtonItem(title: itemTitle, color: .accent, action: { [weak actionSheet] in
                actionSheet?.dismissAnimated()
                UserDefaults.standard.set(value, forKey: "sosuzagram_reply_style")
                updateSettingsImpl?()
            }))
        }
        actionSheet.setItemGroups([
            ActionSheetItemGroup(items: items),
            ActionSheetItemGroup(items: [
                ActionSheetButtonItem(title: presentationData.strings.Common_Cancel, color: .accent, font: .bold, action: { [weak actionSheet] in
                    actionSheet?.dismissAnimated()
                })
            ])
        ])
        controller.present(actionSheet, in: .window(.root))
    }
    openPillStackModeImpl = { [weak controller] in
        guard let controller else {
            return
        }
        let presentationData = context.sharedContext.currentPresentationData.with { $0 }
        let currentValue = UserDefaults.standard.string(forKey: "sosuzagram_pill_stack_mode") ?? "off"
        let options: [(String, String)] = [
            ("off", "ÐžÑ‚ÐºÐ»ÑŽÑ‡ÐµÐ½Ð¾"),
            ("compact", "ÐšÐ¾Ð¼Ð¿Ð°ÐºÑ‚Ð½Ñ‹Ð¹"),
            ("stacked", "Ð¡Ñ‚ÐµÐº")
        ]

        let actionSheet = ActionSheetController(presentationData: presentationData)
        var items: [ActionSheetItem] = [ActionSheetTextItem(title: "Pill Stack")]
        for (value, title) in options {
            let itemTitle = value == currentValue ? "[selected] \(title)" : title
            items.append(ActionSheetButtonItem(title: itemTitle, color: .accent, action: { [weak actionSheet] in
                actionSheet?.dismissAnimated()
                UserDefaults.standard.set(value, forKey: "sosuzagram_pill_stack_mode")
                updateSettingsImpl?()
            }))
        }
        actionSheet.setItemGroups([
            ActionSheetItemGroup(items: items),
            ActionSheetItemGroup(items: [
                ActionSheetButtonItem(title: presentationData.strings.Common_Cancel, color: .accent, font: .bold, action: { [weak actionSheet] in
                    actionSheet?.dismissAnimated()
                })
            ])
        ])
        controller.present(actionSheet, in: .window(.root))
    }
    openIncomingDoubleTapActionImpl = { [weak controller] in
        guard let controller else {
            return
        }
        let presentationData = context.sharedContext.currentPresentationData.with { $0 }
        let currentAction = sosuzagramDoubleTapAction(incoming: true)
        let actionSheet = ActionSheetController(presentationData: presentationData)
        let options: [(SosuzagramDoubleTapAction, String)] = [
            (.reactions, "ÃÂ ÃÂµÃÂ°ÃÂºÃ‘â€ ÃÂ¸ÃÂ¸"),
            (.none, "ÃÂÃÂµÃ‘â€š")
        ]
        var items: [ActionSheetItem] = [ActionSheetTextItem(title: "Ãâ€ÃÂ²ÃÂ¾ÃÂ¹ÃÂ½ÃÂ¾ÃÂ¹ Ã‘â€šÃÂ°ÃÂ¿ ÃÂ¿ÃÂ¾ ÃÂ²Ã‘â€¦ÃÂ¾ÃÂ´Ã‘ÂÃ‘â€°ÃÂ¸ÃÂ¼ Ã‘ÂÃÂ¾ÃÂ¾ÃÂ±Ã‘â€°ÃÂµÃÂ½ÃÂ¸Ã‘ÂÃÂ¼")]
        for (action, title) in options {
            let itemTitle = action == currentAction ? "[selected] \(title)" : title
            items.append(ActionSheetButtonItem(title: itemTitle, color: .accent, action: { [weak actionSheet] in
                actionSheet?.dismissAnimated()
                sosuzagramSetDoubleTapAction(incoming: true, action: action)
                updateSettingsImpl?()
            }))
        }
        actionSheet.setItemGroups([
            ActionSheetItemGroup(items: items),
            ActionSheetItemGroup(items: [
                ActionSheetButtonItem(title: presentationData.strings.Common_Cancel, color: .accent, font: .bold, action: { [weak actionSheet] in
                    actionSheet?.dismissAnimated()
                })
            ])
        ])
        controller.present(actionSheet, in: .window(.root))
    }
    openOutgoingDoubleTapActionImpl = { [weak controller] in
        guard let controller else {
            return
        }
        let presentationData = context.sharedContext.currentPresentationData.with { $0 }
        let currentAction = sosuzagramDoubleTapAction(incoming: false)
        let actionSheet = ActionSheetController(presentationData: presentationData)
        let options: [(SosuzagramDoubleTapAction, String)] = [
            (.reactions, "ÃÂ ÃÂµÃÂ°ÃÂºÃ‘â€ ÃÂ¸ÃÂ¸"),
            (.none, "ÃÂÃÂµÃ‘â€š")
        ]
        var items: [ActionSheetItem] = [ActionSheetTextItem(title: "Ãâ€ÃÂ²ÃÂ¾ÃÂ¹ÃÂ½ÃÂ¾ÃÂ¹ Ã‘â€šÃÂ°ÃÂ¿ ÃÂ¿ÃÂ¾ ÃÂ¸Ã‘ÂÃ‘â€¦ÃÂ¾ÃÂ´Ã‘ÂÃ‘â€°ÃÂ¸ÃÂ¼ Ã‘ÂÃÂ¾ÃÂ¾ÃÂ±Ã‘â€°ÃÂµÃÂ½ÃÂ¸Ã‘ÂÃÂ¼")]
        for (action, title) in options {
            let itemTitle = action == currentAction ? "[selected] \(title)" : title
            items.append(ActionSheetButtonItem(title: itemTitle, color: .accent, action: { [weak actionSheet] in
                actionSheet?.dismissAnimated()
                sosuzagramSetDoubleTapAction(incoming: false, action: action)
                updateSettingsImpl?()
            }))
        }
        actionSheet.setItemGroups([
            ActionSheetItemGroup(items: items),
            ActionSheetItemGroup(items: [
                ActionSheetButtonItem(title: presentationData.strings.Common_Cancel, color: .accent, font: .bold, action: { [weak actionSheet] in
                    actionSheet?.dismissAnimated()
                })
            ])
        ])
        controller.present(actionSheet, in: .window(.root))
    }
    openChatListTitleTextImpl = { [weak controller] in
        guard let controller else {
            return
        }
        let presentationData = context.sharedContext.currentPresentationData.with { $0 }
        let currentValue = UserDefaults.standard.string(forKey: "sosuzagram_chat_list_title_text") ?? "name"
        let options: [(String, String)] = [
            ("name", "ÃËœÃÂ¼Ã‘Â"),
            ("username", "Username"),
            ("name_and_username", "ÃËœÃÂ¼Ã‘Â ÃÂ¸ username")
        ]

        let actionSheet = ActionSheetController(presentationData: presentationData)
        var items: [ActionSheetItem] = [ActionSheetTextItem(title: "ÃÂ¢ÃÂµÃÂºÃ‘ÂÃ‘â€š ÃÂ² ÃÂ·ÃÂ°ÃÂ³ÃÂ¾ÃÂ»ÃÂ¾ÃÂ²ÃÂºÃÂµ")]
        for (value, title) in options {
            let itemTitle = value == currentValue ? "[selected] \(title)" : title
            items.append(ActionSheetButtonItem(title: itemTitle, color: .accent, action: { [weak actionSheet] in
                actionSheet?.dismissAnimated()
                UserDefaults.standard.set(value, forKey: "sosuzagram_chat_list_title_text")
                updateSettingsImpl?()
            }))
        }
        actionSheet.setItemGroups([
            ActionSheetItemGroup(items: items),
            ActionSheetItemGroup(items: [
                ActionSheetButtonItem(title: presentationData.strings.Common_Cancel, color: .accent, font: .bold, action: { [weak actionSheet] in
                    actionSheet?.dismissAnimated()
                })
            ])
        ])
        controller.present(actionSheet, in: .window(.root))
    }
    openFolderTabTitlesImpl = { [weak controller] in
        guard let controller else {
            return
        }
        let presentationData = context.sharedContext.currentPresentationData.with { $0 }
        let currentValue = UserDefaults.standard.string(forKey: "sosuzagram_folder_tab_titles") ?? "title_and_icon"
        let options: [(String, String)] = [
            ("title_and_icon", "ÃÂÃÂ°ÃÂ·ÃÂ²ÃÂ°ÃÂ½ÃÂ¸ÃÂµ ÃÂ¸ ÃÂ¸ÃÂºÃÂ¾ÃÂ½ÃÂºÃÂ°"),
            ("title", "ÃÂÃÂ°ÃÂ·ÃÂ²ÃÂ°ÃÂ½ÃÂ¸ÃÂµ"),
            ("icon", "ÃÂ¢ÃÂ¾ÃÂ»Ã‘Å’ÃÂºÃÂ¾ ÃÂ¸ÃÂºÃÂ¾ÃÂ½ÃÂºÃÂ°")
        ]

        let actionSheet = ActionSheetController(presentationData: presentationData)
        var items: [ActionSheetItem] = [ActionSheetTextItem(title: "Ãâ€”ÃÂ°ÃÂ³ÃÂ¾ÃÂ»ÃÂ¾ÃÂ²ÃÂºÃÂ¸ ÃÂ¿ÃÂ°ÃÂ¿ÃÂ¾ÃÂº")]
        for (value, title) in options {
            let itemTitle = value == currentValue ? "[selected] \(title)" : title
            items.append(ActionSheetButtonItem(title: itemTitle, color: .accent, action: { [weak actionSheet] in
                actionSheet?.dismissAnimated()
                UserDefaults.standard.set(value, forKey: "sosuzagram_folder_tab_titles")
                updateSettingsImpl?()
            }))
        }
        actionSheet.setItemGroups([
            ActionSheetItemGroup(items: items),
            ActionSheetItemGroup(items: [
                ActionSheetButtonItem(title: presentationData.strings.Common_Cancel, color: .accent, font: .bold, action: { [weak actionSheet] in
                    actionSheet?.dismissAnimated()
                })
            ])
        ])
        controller.present(actionSheet, in: .window(.root))
    }
    openDoNotTranslateLanguagesImpl = { [weak controller] in
        controller?.push(context.sharedContext.makeTranslationSettingsController(context: context))
    }
    openTranslationProviderImpl = { [weak controller] in
        guard let controller else {
            return
        }
        let presentationData = context.sharedContext.currentPresentationData.with { $0 }
        let currentValue = UserDefaults.standard.string(forKey: "sosuzagram_translation_provider") ?? "telegram"
        let options: [(String, String)] = [
            ("telegram", "Telegram"),
            ("google", "Google"),
            ("system", "Ð¡Ð¸ÑÑ‚ÐµÐ¼Ð½Ñ‹Ð¹")
        ]

        let actionSheet = ActionSheetController(presentationData: presentationData)
        var items: [ActionSheetItem] = [ActionSheetTextItem(title: "ÐŸÑ€Ð¾Ð²Ð°Ð¹Ð´ÐµÑ€ Ð¿ÐµÑ€ÐµÐ²Ð¾Ð´Ð°")]
        for (value, title) in options {
            let itemTitle = value == currentValue ? "[selected] \(title)" : title
            items.append(ActionSheetButtonItem(title: itemTitle, color: .accent, action: { [weak actionSheet] in
                actionSheet?.dismissAnimated()
                UserDefaults.standard.set(value, forKey: "sosuzagram_translation_provider")
                updateSettingsImpl?()
            }))
        }
        items.append(ActionSheetTextItem(title: "Telegram Ð¸ÑÐ¿Ð¾Ð»ÑŒÐ·ÑƒÐµÑ‚ Ð²ÑÑ‚Ñ€Ð¾ÐµÐ½Ð½Ñ‹Ð¹ Ð¿ÐµÑ€ÐµÐ²Ð¾Ð´ Telegram, Google Ð²ÐºÐ»ÑŽÑ‡Ð°ÐµÑ‚ Ð°Ð»ÑŒÑ‚ÐµÑ€Ð½Ð°Ñ‚Ð¸Ð²Ð½Ñ‹Ð¹ Ð¿ÐµÑ€ÐµÐ²Ð¾Ð´, Ð° ÑÐ¸ÑÑ‚ÐµÐ¼Ð½Ñ‹Ð¹ Ñ€ÐµÐ¶Ð¸Ð¼ Ð¸ÑÐ¿Ð¾Ð»ÑŒÐ·ÑƒÐµÑ‚ iOS Translate, ÐµÑÐ»Ð¸ Ð¾Ð½ Ð´Ð¾ÑÑ‚ÑƒÐ¿ÐµÐ½."))
        actionSheet.setItemGroups([
            ActionSheetItemGroup(items: items),
            ActionSheetItemGroup(items: [
                ActionSheetButtonItem(title: presentationData.strings.Common_Cancel, color: .accent, font: .bold, action: { [weak actionSheet] in
                    actionSheet?.dismissAnimated()
                })
            ])
        ])
        controller.present(actionSheet, in: .window(.root))
    }
    openTranslationTargetImpl = { [weak controller] in
        guard let controller else {
            return
        }
        let presentationData = context.sharedContext.currentPresentationData.with { $0 }
        let currentValue = UserDefaults.standard.string(forKey: "sosuzagram_translation_target") ?? "app"
        let options: [(String, String)] = [
            ("app", "Ð¯Ð·Ñ‹Ðº Ð¿Ñ€Ð¸Ð»Ð¾Ð¶ÐµÐ½Ð¸Ñ"),
            ("system", "Ð¯Ð·Ñ‹Ðº ÑÐ¸ÑÑ‚ÐµÐ¼Ñ‹"),
            ("ru", "Ð ÑƒÑÑÐºÐ¸Ð¹"),
            ("en", "English"),
            ("uk", "Ð£ÐºÑ€Ð°Ñ—Ð½ÑÑŒÐºÐ°")
        ]

        let actionSheet = ActionSheetController(presentationData: presentationData)
        var items: [ActionSheetItem] = [ActionSheetTextItem(title: "Ð¦ÐµÐ»ÐµÐ²Ð¾Ð¹ ÑÐ·Ñ‹Ðº")]
        for (value, title) in options {
            let itemTitle = value == currentValue ? "[selected] \(title)" : title
            items.append(ActionSheetButtonItem(title: itemTitle, color: .accent, action: { [weak actionSheet] in
                actionSheet?.dismissAnimated()
                UserDefaults.standard.set(value, forKey: "sosuzagram_translation_target")
                updateSettingsImpl?()
            }))
        }
        items.append(ActionSheetTextItem(title: "Ð¯Ð·Ñ‹Ðº Ð¿Ñ€Ð¸Ð»Ð¾Ð¶ÐµÐ½Ð¸Ñ Ð¿Ð¾Ð²Ñ‚Ð¾Ñ€ÑÐµÑ‚ Ñ‚ÐµÐºÑƒÑ‰ÑƒÑŽ Ð»Ð¾ÐºÐ°Ð»Ð¸Ð·Ð°Ñ†Ð¸ÑŽ Telegram, Ð° ÑÐ·Ñ‹Ðº ÑÐ¸ÑÑ‚ÐµÐ¼Ñ‹ Ð±ÐµÑ€Ñ‘Ñ‚ÑÑ Ð¸Ð· Ð¾ÑÐ½Ð¾Ð²Ð½Ñ‹Ñ… ÑÐ·Ñ‹ÐºÐ¾Ð²Ñ‹Ñ… Ð½Ð°ÑÑ‚Ñ€Ð¾ÐµÐº iOS."))
        actionSheet.setItemGroups([
            ActionSheetItemGroup(items: items),
            ActionSheetItemGroup(items: [
                ActionSheetButtonItem(title: presentationData.strings.Common_Cancel, color: .accent, font: .bold, action: { [weak actionSheet] in
                    actionSheet?.dismissAnimated()
                })
            ])
        ])
        controller.present(actionSheet, in: .window(.root))
    }
    openLocalizationSettingsImpl = { [weak controller] in
        controller?.push(context.sharedContext.makeLocalizationListController(context: context))
    }
    openThemeSettingsImpl = { [weak controller] in
        controller?.push(context.sharedContext.makeThemeSettingsController(context: context))
    }
    openChatFoldersSettingsImpl = { [weak controller] in
        let filterController = context.sharedContext.makeFilterSettingsController(context: context, modal: false, scrollToTags: false, dismissed: nil)
        controller?.push(filterController)
    }
    openNavigationInAppImpl = { [weak controller] in
        guard let controller else {
            return
        }
        let presentationData = context.sharedContext.currentPresentationData.with { $0 }
        let actionSheet = ActionSheetController(presentationData: presentationData)
        actionSheet.setItemGroups([
            ActionSheetItemGroup(items: [
                ActionSheetTextItem(title: "ÐÐ°Ð²Ð¸Ð³Ð°Ñ†Ð¸Ñ Ð² Ð¿Ñ€Ð¸Ð»Ð¾Ð¶ÐµÐ½Ð¸Ð¸"),
                ActionSheetButtonItem(title: "ÐŸÐ°Ð¿ÐºÐ¸ Ð¸ Ð²ÐºÐ»Ð°Ð´ÐºÐ¸", color: .accent, action: { [weak actionSheet] in
                    actionSheet?.dismissAnimated()
                    openChatFoldersSettingsImpl?()
                }),
                ActionSheetButtonItem(title: "Ð¢ÐµÐºÑÑ‚ Ð² Ð·Ð°Ð³Ð¾Ð»Ð¾Ð²ÐºÐµ", color: .accent, action: { [weak actionSheet] in
                    actionSheet?.dismissAnimated()
                    openChatListTitleTextImpl?()
                }),
                ActionSheetButtonItem(title: "Ð—Ð°Ð³Ð¾Ð»Ð¾Ð²ÐºÐ¸ Ð¿Ð°Ð¿Ð¾Ðº", color: .accent, action: { [weak actionSheet] in
                    actionSheet?.dismissAnimated()
                    openFolderTabTitlesImpl?()
                })
            ]),
            ActionSheetItemGroup(items: [
                ActionSheetButtonItem(title: presentationData.strings.Common_Cancel, color: .accent, font: .bold, action: { [weak actionSheet] in
                    actionSheet?.dismissAnimated()
                })
            ])
        ])
        controller.present(actionSheet, in: .window(.root))
    }
    openIconPacksImpl = { [weak controller] in
        guard let controller else {
            return
        }
        let presentationData = context.sharedContext.currentPresentationData.with { $0 }
        let currentIcon = UserDefaults.standard.string(forKey: "sosuzagram_current_icon") ?? "nil"
        let icons = [
            ("Ð¡Ñ‚Ð°Ð½Ð´Ð°Ñ€Ñ‚Ð½Ð°Ñ", "nil"),
            ("ÐšÑ€Ð°ÑÐ½Ð°Ñ (Extera style)", "Red"),
            ("Ð—ÐµÐ»Ñ‘Ð½Ð°Ñ (Extera style)", "Green"),
            ("ÐžÑ€Ð°Ð½Ð¶ÐµÐ²Ð°Ñ (Extera style)", "Orange"),
            ("Ð¤Ð¸Ð¾Ð»ÐµÑ‚Ð¾Ð²Ð°Ñ (Extera style)", "Purple")
        ]

        let actionSheet = ActionSheetController(presentationData: presentationData)
        var items: [ActionSheetItem] = [ActionSheetTextItem(title: "ÐÐ°Ð±Ð¾Ñ€Ñ‹ Ð¸ÐºÐ¾Ð½Ð¾Ðº")]
        for (title, value) in icons {
            let itemTitle = value == currentIcon ? "[selected] \(title)" : title
            items.append(ActionSheetButtonItem(title: itemTitle, color: .accent, action: { [weak actionSheet] in
                actionSheet?.dismissAnimated()
                let targetName = value == "nil" ? nil : value
                if UIApplication.shared.supportsAlternateIcons {
                    UIApplication.shared.setAlternateIconName(targetName) { error in
                        if let error {
                            print("Error setting alternate icon: \(error.localizedDescription)")
                        }
                    }
                }
                UserDefaults.standard.set(value, forKey: "sosuzagram_current_icon")
                updateSettingsImpl?()
            }))
        }
        actionSheet.setItemGroups([
            ActionSheetItemGroup(items: items),
            ActionSheetItemGroup(items: [
                ActionSheetButtonItem(title: presentationData.strings.Common_Cancel, color: .accent, font: .bold, action: { [weak actionSheet] in
                    actionSheet?.dismissAnimated()
                })
            ])
        ])
        controller.present(actionSheet, in: .window(.root))
    }
    openPluginImpl = { [weak controller] pluginId in
        controller?.push(sosuzagramPluginSettingsController(context: context, pluginId: pluginId))
    }
    importPluginImpl = { [weak controller] in
        guard let controller else {
            return
        }
        let presentationData = context.sharedContext.currentPresentationData.with { $0 }
        var documentTypes = ["public.item"]
        if #available(iOS 14.0, *) {
            for fileExtension in ["plugin", "sosuzagramplugin"] {
                if let identifier = UTType(filenameExtension: fileExtension)?.identifier, !documentTypes.contains(identifier) {
                    documentTypes.append(identifier)
                }
            }
        }

        let pickerController = legacyICloudFilePicker(theme: presentationData.theme, mode: .import, documentTypes: documentTypes, completion: { [weak controller] urls in
            guard let controller, let url = urls.first else {
                return
            }
            let scopedAccess = url.startAccessingSecurityScopedResource()
            defer {
                if scopedAccess {
                    url.stopAccessingSecurityScopedResource()
                }
            }

            let allowedExtensions: Set<String> = ["plugin", "sosuzagramplugin"]
            guard allowedExtensions.contains(url.pathExtension.lowercased()) else {
                controller.present(textAlertController(context: context, title: "ÃËœÃÂ¼ÃÂ¿ÃÂ¾Ã‘â‚¬Ã‘â€š ÃÂ¿ÃÂ»ÃÂ°ÃÂ³ÃÂ¸ÃÂ½ÃÂ°", text: "Ãâ€™Ã‘â€¹ÃÂ±ÃÂµÃ‘â‚¬ÃÂ¸ Ã‘â€žÃÂ°ÃÂ¹ÃÂ» Ã‘Â Ã‘â‚¬ÃÂ°Ã‘ÂÃ‘Ë†ÃÂ¸Ã‘â‚¬ÃÂµÃÂ½ÃÂ¸ÃÂµÃÂ¼ .plugin ÃÂ¸ÃÂ»ÃÂ¸ .sosuzagramplugin.", actions: [
                    TextAlertAction(type: .defaultAction, title: presentationData.strings.Common_OK, action: {})
                ]), in: .window(.root))
                return
            }

            do {
                let importedPlugin = try sosuzagramImportPluginFile(from: url)
                let supportedPlugin = sosuzagramBuiltInPlugin(id: importedPlugin.id)
                if supportedPlugin != nil {
                    sosuzagramSetPluginEnabled(importedPlugin.id, true)
                }
                updateSettingsImpl?()

                var actions: [TextAlertAction] = []
                if supportedPlugin != nil {
                    actions.append(TextAlertAction(type: .genericAction, title: "ÃÅ¾Ã‘â€šÃÂºÃ‘â‚¬Ã‘â€¹Ã‘â€šÃ‘Å’", action: {
                        controller.push(sosuzagramPluginSettingsController(context: context, pluginId: importedPlugin.id))
                    }))
                }
                actions.append(TextAlertAction(type: .defaultAction, title: presentationData.strings.Common_OK, action: {}))

                let message: String
                if supportedPlugin != nil {
                    message = "ÃÅ¸ÃÂ»ÃÂ°ÃÂ³ÃÂ¸ÃÂ½ \(importedPlugin.name) ÃÂ¸ÃÂ¼ÃÂ¿ÃÂ¾Ã‘â‚¬Ã‘â€šÃÂ¸Ã‘â‚¬ÃÂ¾ÃÂ²ÃÂ°ÃÂ½ ÃÂ¸ ÃÂ²ÃÂºÃÂ»Ã‘Å½Ã‘â€¡Ã‘â€˜ÃÂ½. Ãâ€¢ÃÂ³ÃÂ¾ ÃÂ½ÃÂ°Ã‘ÂÃ‘â€šÃ‘â‚¬ÃÂ¾ÃÂ¹ÃÂºÃÂ¸ Ã‘Æ’ÃÂ¶ÃÂµ ÃÂ´ÃÂ¾Ã‘ÂÃ‘â€šÃ‘Æ’ÃÂ¿ÃÂ½Ã‘â€¹ ÃÂ² Sosuzagram."
                } else {
                    message = "ÃÂ¤ÃÂ°ÃÂ¹ÃÂ» \(importedPlugin.name) ÃÂ¸ÃÂ¼ÃÂ¿ÃÂ¾Ã‘â‚¬Ã‘â€šÃÂ¸Ã‘â‚¬ÃÂ¾ÃÂ²ÃÂ°ÃÂ½ ÃÂ² SosuzagramPlugins, ÃÂ½ÃÂ¾ ÃÂ´ÃÂ»Ã‘Â Ã‘â‚¬ÃÂ°ÃÂ±ÃÂ¾Ã‘â€šÃ‘â€¹ ÃÂ½Ã‘Æ’ÃÂ¶ÃÂµÃÂ½ ÃÂ¾Ã‘â€šÃÂ´ÃÂµÃÂ»Ã‘Å’ÃÂ½Ã‘â€¹ÃÂ¹ ÃÂ½ÃÂ°Ã‘â€šÃÂ¸ÃÂ²ÃÂ½Ã‘â€¹ÃÂ¹ ÃÂ¿ÃÂ¾Ã‘â‚¬Ã‘â€š ÃÂ¿ÃÂ¾ÃÂ´ iOS."
                }

                controller.present(textAlertController(context: context, title: "ÃËœÃÂ¼ÃÂ¿ÃÂ¾Ã‘â‚¬Ã‘â€š ÃÂ¿ÃÂ»ÃÂ°ÃÂ³ÃÂ¸ÃÂ½ÃÂ°", text: message, actions: actions), in: .window(.root))
            } catch {
                controller.present(textAlertController(context: context, title: "ÃËœÃÂ¼ÃÂ¿ÃÂ¾Ã‘â‚¬Ã‘â€š ÃÂ¿ÃÂ»ÃÂ°ÃÂ³ÃÂ¸ÃÂ½ÃÂ°", text: "ÃÂÃÂµ Ã‘Æ’ÃÂ´ÃÂ°ÃÂ»ÃÂ¾Ã‘ÂÃ‘Å’ ÃÂ¸ÃÂ¼ÃÂ¿ÃÂ¾Ã‘â‚¬Ã‘â€šÃÂ¸Ã‘â‚¬ÃÂ¾ÃÂ²ÃÂ°Ã‘â€šÃ‘Å’ Ã‘â€žÃÂ°ÃÂ¹ÃÂ»: \(error.localizedDescription)", actions: [
                    TextAlertAction(type: .defaultAction, title: presentationData.strings.Common_OK, action: {})
                ]), in: .window(.root))
            }
        })
        controller.present(pickerController, in: .window(.root))
    }
    return controller
}

private struct SosuzagramMessageMenuSettingsArguments {
    let toggle: (SosuzagramMessageMenuOption, Bool) -> Void
}

private struct SosuzagramMessageMenuSettingsEntry: ItemListNodeEntry {
    let section: ItemListSectionId
    let stableId: UInt64
    let sortId: Int32
    let signature: String
    let buildItem: (ItemListPresentationData, SosuzagramMessageMenuSettingsArguments) -> ListViewItem

    static func == (lhs: SosuzagramMessageMenuSettingsEntry, rhs: SosuzagramMessageMenuSettingsEntry) -> Bool {
        return lhs.section == rhs.section
            && lhs.stableId == rhs.stableId
            && lhs.sortId == rhs.sortId
            && lhs.signature == rhs.signature
    }

    static func < (lhs: SosuzagramMessageMenuSettingsEntry, rhs: SosuzagramMessageMenuSettingsEntry) -> Bool {
        return lhs.sortId < rhs.sortId
    }

    func item(presentationData: ItemListPresentationData, arguments: Any) -> ListViewItem {
        return self.buildItem(presentationData, arguments as! SosuzagramMessageMenuSettingsArguments)
    }
}

private func sosuzagramMessageMenuSettingsController(context: AccountContext, onUpdate: @escaping () -> Void) -> ViewController {
    let statePromise = ValuePromise<Bool>(true, ignoreRepeated: false)

    let arguments = SosuzagramMessageMenuSettingsArguments(toggle: { option, value in
        UserDefaults.standard.set(value, forKey: option.defaultsKey)
        onUpdate()
        statePromise.set(true)
    })

    let signal = combineLatest(
        context.sharedContext.presentationData,
        statePromise.get()
    )
    |> map { presentationData, _ -> (ItemListControllerState, (ItemListNodeState, Any)) in
        var entries: [SosuzagramMessageMenuSettingsEntry] = []
        entries.append(SosuzagramMessageMenuSettingsEntry(
            section: 0,
            stableId: 0,
            sortId: 0,
            signature: "info",
            buildItem: { presentationData, _ in
                ItemListTextItem(
                    presentationData: presentationData,
                    text: .plain("Ð’Ñ‹Ð±Ð¸Ñ€Ð°ÐµÑ‚, ÐºÐ°ÐºÐ¸Ðµ Ð¾ÑÐ½Ð¾Ð²Ð½Ñ‹Ðµ Ð´ÐµÐ¹ÑÑ‚Ð²Ð¸Ñ Ð¾ÑÑ‚Ð°ÑŽÑ‚ÑÑ Ð² Ð¼ÐµÐ½ÑŽ ÑÐ¾Ð¾Ð±Ñ‰ÐµÐ½Ð¸Ñ, ÐºÐ¾Ð³Ð´Ð° Ð²ÐºÐ»ÑŽÑ‡ÐµÐ½Ð° ÐºÐ°ÑÑ‚Ð¾Ð¼Ð¸Ð·Ð°Ñ†Ð¸Ñ Ð¼ÐµÐ½ÑŽ."),
                    sectionId: 0
                )
            }
        ))

        var stableId: UInt64 = 1
        var sortId: Int32 = 1
        for option in SosuzagramMessageMenuOption.allCases {
            let value = sosuzagramMessageMenuOptionEnabled(option)
            entries.append(SosuzagramMessageMenuSettingsEntry(
                section: 1,
                stableId: stableId,
                sortId: sortId,
                signature: "\(option.rawValue):\(value)",
                buildItem: { presentationData, arguments in
                    ItemListSwitchItem(
                        presentationData: presentationData,
                        systemStyle: sosuzagramSettingsSystemStyle(),
                        title: option.title,
                        value: value,
                        sectionId: 1,
                        style: .blocks,
                        updated: { updated in
                            arguments.toggle(option, updated)
                        }
                    )
                }
            ))
            stableId += 1
            sortId += 1
        }

        entries.append(SosuzagramMessageMenuSettingsEntry(
            section: 2,
            stableId: stableId,
            sortId: sortId,
            signature: "summary:\(sosuzagramMessageMenuEnabledCount())",
            buildItem: { presentationData, _ in
                ItemListTextItem(
                    presentationData: presentationData,
                    text: .plain("Ð¡ÐµÐ¹Ñ‡Ð°Ñ Ð°ÐºÑ‚Ð¸Ð²Ð½Ð¾ \(sosuzagramMessageMenuEnabledCount()) Ð¸Ð· \(SosuzagramMessageMenuOption.allCases.count) Ð¾ÑÐ½Ð¾Ð²Ð½Ñ‹Ñ… Ð´ÐµÐ¹ÑÑ‚Ð²Ð¸Ð¹."),
                    sectionId: 2
                )
            }
        ))

        return (
            ItemListControllerState(
                presentationData: ItemListPresentationData(presentationData),
                title: .text("ÐœÐµÐ½ÑŽ ÑÐ¾Ð¾Ð±Ñ‰ÐµÐ½Ð¸Ñ"),
                leftNavigationButton: nil,
                rightNavigationButton: nil,
                backNavigationButton: ItemListBackButton(title: presentationData.strings.Common_Back)
            ),
            (
                ItemListNodeState(
                    presentationData: ItemListPresentationData(presentationData),
                    entries: entries,
                    style: .blocks,
                    animateChanges: true
                ),
                arguments
            )
        )
    }

    return ItemListController(context: context, state: signal)
}
