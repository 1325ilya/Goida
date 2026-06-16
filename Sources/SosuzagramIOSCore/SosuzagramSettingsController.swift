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
import SettingsUI

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
            return "ÐžÑÐ½Ð¾Ð²Ð½Ñ‹Ðµ"
        case .appearance:
            return "ÐžÑ„Ð¾Ñ€Ð¼Ð»ÐµÐ½Ð¸Ðµ"
        case .chats:
            return "Ð§Ð°Ñ‚Ñ‹"
        case .plugins:
            return "ÐŸÐ»Ð°Ð³Ð¸Ð½Ñ‹"
        case .other:
            return "Ð”Ñ€ÑƒÐ³Ð¾Ðµ"
        }
    }

    var subtitle: String {
        switch self {
        case .basics:
            return "ÐŸÐµÑ€ÐµÐ²Ð¾Ð´, Ð°Ñ€Ñ…Ð¸Ð², Ñ„Ð¾Ñ€Ð¼Ð°Ñ‚Ð¸Ñ€Ð¾Ð²Ð°Ð½Ð¸Ðµ, Ð¿Ñ€Ð¸Ð²Ð°Ñ‚Ð½Ð¾ÑÑ‚ÑŒ Ð¿Ñ€Ð¾Ñ„Ð¸Ð»Ñ, ÐºÐ°Ñ€Ñ‚Ñ‹ Ð¸ Ð¾Ð±Ñ‰Ð¸Ðµ Ñ‚Ð²Ð¸ÐºÐ¸."
        case .appearance:
            return "Ð˜ÐºÐ¾Ð½ÐºÐ¸, Ð¸ÑÑ‚Ð¾Ñ€Ð¸Ð¸, Ð²ÐºÐ»Ð°Ð´ÐºÐ¸, Ð·Ð°Ð³Ð¾Ð»Ð¾Ð²Ð¾Ðº Ð¸ Ð²Ð¸Ð·ÑƒÐ°Ð»ÑŒÐ½Ñ‹Ðµ Ð½Ð°ÑÑ‚Ñ€Ð¾Ð¹ÐºÐ¸ ÑÐ¿Ð¸ÑÐºÐ° Ñ‡Ð°Ñ‚Ð¾Ð²."
        case .chats:
            return "Ð¡Ð¾Ð¾Ð±Ñ‰ÐµÐ½Ð¸Ñ, Ñ€ÐµÐ°ÐºÑ†Ð¸Ð¸, ÑÑ‚Ð¸ÐºÐµÑ€Ñ‹, Ð¿Ð¾Ð´Ñ‚Ð²ÐµÑ€Ð¶Ð´ÐµÐ½Ð¸Ñ Ð¸ Ð¿Ð¾Ð²ÐµÐ´ÐµÐ½Ð¸Ðµ Ð²Ð½ÑƒÑ‚Ñ€Ð¸ Ñ‡Ð°Ñ‚Ð¾Ð²."
        case .plugins:
            return "Ð’ÑÑ‚Ñ€Ð¾ÐµÐ½Ð½Ñ‹Ðµ Ð¿Ð»Ð°Ð³Ð¸Ð½Ñ‹ Extera Ð¸ Ð¸Ð¼Ð¿Ð¾Ñ€Ñ‚ .plugin Ñ„Ð°Ð¹Ð»Ð¾Ð²."
        case .other:
            return "Ghost mode, Ð°Ð½Ñ‚Ð¸ÑƒÐ´Ð°Ð»ÐµÐ½Ð¸Ðµ Ð¸ Ð¿Ñ€Ð¾Ñ‡Ð¸Ðµ Ð´Ð¾Ð¿Ð¾Ð»Ð½Ð¸Ñ‚ÐµÐ»ÑŒÐ½Ñ‹Ðµ Ð²Ð¾Ð·Ð¼Ð¾Ð¶Ð½Ð¾ÑÑ‚Ð¸."
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
            return "Ответ"
        case .copy:
            return "Копирование"
        case .translate:
            return "Перевод"
        case .speak:
            return "Озвучивание"
        case .save:
            return "Сохранение"
        case .forward:
            return "Пересылка"
        case .select:
            return "Выделение"
        case .delete:
            return "Удаление"
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
        return "ÐœÐ°Ð»ÐµÐ½ÑŒÐºÐ¸Ð¹"
    case "large":
        return "Ð‘Ð¾Ð»ÑŒÑˆÐ¾Ð¹"
    default:
        return "Ð¡Ñ€ÐµÐ´Ð½Ð¸Ð¹"
    }
}

private func sosuzagramDoubleTapActionLabel(_ action: SosuzagramDoubleTapAction) -> String {
    switch action {
    case .reactions:
        return "Ð ÐµÐ°ÐºÑ†Ð¸Ð¸"
    case .none:
        return "ÐÐµÑ‚"
    }
}

private func sosuzagramDownloadAccelerationLabel(_ value: String) -> String {
    switch value {
    case "fast":
        return "Быстро"
    case "faster":
        return "Быстрее"
    default:
        return "Обычная"
    }
}

private func sosuzagramVoiceRecognitionLocaleLabel(_ value: String) -> String {
    switch value {
    case "ru-RU":
        return "Русский"
    case "en-US":
        return "English"
    case "uk-UA":
        return "Українська"
    default:
        return "Системный"
    }
}

private func sosuzagramTranslationProviderLabel(_ value: String) -> String {
    switch value {
    case "google":
        return "Google"
    case "system":
        return "Системный"
    default:
        return "Telegram"
    }
}

private func sosuzagramTranslationTargetLabel(_ value: String) -> String {
    switch value {
    case "app":
        return "Язык приложения"
    case "system":
        return "Язык системы"
    case "ru":
        return "Русский"
    case "en":
        return "English"
    case "uk":
        return "Українська"
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
        return "Ð¤Ñ€Ð¾Ð½Ñ‚Ð°Ð»ÑŒÐ½Ð°Ñ"
    case "back":
        return "ÐžÑÐ½Ð¾Ð²Ð½Ð°Ñ"
    case "last":
        return "ÐŸÐ¾ÑÐ»ÐµÐ´Ð½ÑÑ"
    default:
        return "Ð¡Ð¸ÑÑ‚ÐµÐ¼Ð½Ð¾"
    }
}

private func sosuzagramCameraTypeLabel(_ value: String) -> String {
    switch value {
    case "camera1":
        return "Camera 1"
    case "camera2":
        return "Camera 2"
    default:
        return "Системно"
    }
}

private func sosuzagramAvatarShapeLabel(_ value: String) -> String {
    switch value {
    case "circle":
        return "ÐšÑ€ÑƒÐ³"
    case "rounded":
        return "Ð¡ÐºÑ€ÑƒÐ³Ð»Ñ‘Ð½Ð½Ð°Ñ"
    case "square":
        return "ÐšÐ²Ð°Ð´Ñ€Ð°Ñ‚"
    default:
        return "Ð¡Ð¸ÑÑ‚ÐµÐ¼Ð½Ð¾"
    }
}

private func sosuzagramChatListTitleTextLabel(_ value: String) -> String {
    switch value {
    case "username":
        return "Username"
    case "name_and_username":
        return "Ð˜Ð¼Ñ Ð¸ username"
    default:
        return "Ð˜Ð¼Ñ"
    }
}

private func sosuzagramFolderTabTitlesLabel(_ value: String) -> String {
    switch value {
    case "icon":
        return "Ð¢Ð¾Ð»ÑŒÐºÐ¾ Ð¸ÐºÐ¾Ð½ÐºÐ°"
    case "title_and_icon":
        return "ÐÐ°Ð·Ð²Ð°Ð½Ð¸Ðµ Ð¸ Ð¸ÐºÐ¾Ð½ÐºÐ°"
    default:
        return "ÐÐ°Ð·Ð²Ð°Ð½Ð¸Ðµ"
    }
}

private func sosuzagramMaterialDesignLevelLabel(_ value: Int) -> String {
    let clampedValue = max(0, min(3, value))
    return "\(clampedValue)/3"
}

private func sosuzagramReplyStyleLabel(_ value: String) -> String {
    switch value {
    case "rounded":
        return "Закруглённые"
    case "message":
        return "Сообщения"
    default:
        return "По умолчанию"
    }
}

private func sosuzagramStickerShapeLabel(_ value: String) -> String {
    switch value {
    case "rounded":
        return "Закруглённая"
    case "message":
        return "Сообщение"
    default:
        return "По умолчанию"
    }
}

private func sosuzagramPillStackModeLabel(_ value: String) -> String {
    switch value {
    case "compact":
        return "Компактный"
    case "stacked":
        return "Стек"
    default:
        return "Отключено"
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
        return "ÐÐ²Ñ‚Ð¾"
    }
    let normalized = ignoredLanguages.filter { !$0.isEmpty }
    guard !normalized.isEmpty else {
        return "ÐÐ²Ñ‚Ð¾"
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
            ItemListSectionHeaderItem(presentationData: presentationData, text: "ÐšÐ°Ñ‚ÐµÐ³Ð¾Ñ€Ð¸Ð¸", sectionId: 0)
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
                text: .plain("ÐÐ°ÑÑ‚Ñ€Ð¾Ð¹ÐºÐ¸ Sosuzagram Ñ€Ð°Ð·Ð»Ð¾Ð¶ÐµÐ½Ñ‹ Ð¿Ð¾ ÐºÐ°Ñ‚ÐµÐ³Ð¾Ñ€Ð¸ÑÐ¼. Ð’Ð½ÑƒÑ‚Ñ€Ð¸ Ñ€Ð°Ð·Ð´ÐµÐ»Ð¾Ð² Ð´Ð¾ÑÑ‚ÑƒÐ¿Ð½Ñ‹ Ð²ÑÐµ ÑƒÐ¶Ðµ Ð¿ÐµÑ€ÐµÐ½ÐµÑÑ‘Ð½Ð½Ñ‹Ðµ Ð½Ð°Ñ‚Ð¸Ð²Ð½Ñ‹Ðµ Ñ„ÑƒÐ½ÐºÑ†Ð¸Ð¸ Ð¸ Ð¿Ð°Ñ€Ð°Ð¼ÐµÑ‚Ñ€Ñ‹ Ð²ÑÑ‚Ñ€Ð¾ÐµÐ½Ð½Ñ‹Ñ… Ð¿Ð»Ð°Ð³Ð¸Ð½Ð¾Ð²."),
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
        throw NSError(domain: "SosuzagramPluginImport", code: 2, userInfo: [NSLocalizedDescriptionKey: "Ð¤Ð°Ð¹Ð» Ð½Ðµ ÑÐ¾Ð´ÐµÑ€Ð¶Ð¸Ñ‚ ÐºÐ¾Ñ€Ñ€ÐµÐºÑ‚Ð½Ñ‹Ðµ Ð¼ÐµÑ‚Ð°Ð´Ð°Ð½Ð½Ñ‹Ðµ Ð¿Ð»Ð°Ð³Ð¸Ð½Ð°."])
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
            ItemListSectionHeaderItem(presentationData: presentationData, text: "Ð ÐµÐ¶Ð¸Ð¼ Ð¿Ñ€Ð¸Ð·Ñ€Ð°ÐºÐ°", sectionId: SosuzagramSettingsSection.ghost.rawValue)
        }
    ))
    entries.append(SosuzagramSettingsEntry(
        section: SosuzagramSettingsSection.ghost.rawValue,
        stableId: 1,
        sortId: 1,
        signature: "skip:\(skipReadHistory)",
        buildItem: { presentationData, arguments in
            ItemListSwitchItem(presentationData: presentationData, systemStyle: sosuzagramSettingsSystemStyle(), title: "ÐÐµ Ð¾Ñ‚Ð¼ÐµÑ‡Ð°Ñ‚ÑŒ Ð¸ÑÑ‚Ð¾Ñ€Ð¸ÑŽ ÐºÐ°Ðº Ð¿Ñ€Ð¾Ñ‡Ð¸Ñ‚Ð°Ð½Ð½ÑƒÑŽ", value: skipReadHistory, sectionId: SosuzagramSettingsSection.ghost.rawValue, style: .blocks, updated: { value in
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
            ItemListSwitchItem(presentationData: presentationData, systemStyle: sosuzagramSettingsSystemStyle(), title: "Ð¡ÐºÑ€Ñ‹Ð²Ð°Ñ‚ÑŒ Ð¿Ñ€Ð¾ÑÐ¼Ð¾Ñ‚Ñ€Ñ‹ Ð¸ÑÑ‚Ð¾Ñ€Ð¸Ð¹", value: hideStoryViews, sectionId: SosuzagramSettingsSection.ghost.rawValue, style: .blocks, updated: { value in
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
            ItemListSwitchItem(presentationData: presentationData, systemStyle: sosuzagramSettingsSystemStyle(), title: "Ð¡ÐºÑ€Ñ‹Ð²Ð°Ñ‚ÑŒ ÑÑ‚Ð°Ñ‚ÑƒÑ Ð½Ð°Ð±Ð¾Ñ€Ð° Ñ‚ÐµÐºÑÑ‚Ð°", value: hideTyping, sectionId: SosuzagramSettingsSection.ghost.rawValue, style: .blocks, updated: { value in
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
            ItemListTextItem(presentationData: presentationData, text: .plain("ÐŸÐ¾Ð·Ð²Ð¾Ð»ÑÐµÑ‚ Ñ‡Ð¸Ñ‚Ð°Ñ‚ÑŒ ÑÐ¾Ð¾Ð±Ñ‰ÐµÐ½Ð¸Ñ, ÑÐ¼Ð¾Ñ‚Ñ€ÐµÑ‚ÑŒ Ð¸ÑÑ‚Ð¾Ñ€Ð¸Ð¸ Ð¸ Ð¿Ð¸ÑÐ°Ñ‚ÑŒ Ð±ÐµÐ· Ð»Ð¸ÑˆÐ½Ð¸Ñ… ÑƒÐ²ÐµÐ´Ð¾Ð¼Ð»ÐµÐ½Ð¸Ð¹ Ð´Ð»Ñ ÑÐ¾Ð±ÐµÑÐµÐ´Ð½Ð¸ÐºÐ°."), sectionId: SosuzagramSettingsSection.ghost.rawValue)
        }
    ))

    entries.append(SosuzagramSettingsEntry(
        section: SosuzagramSettingsSection.antiDelete.rawValue,
        stableId: 5,
        sortId: 5,
        signature: "anti-header",
        buildItem: { presentationData, _ in
            ItemListSectionHeaderItem(presentationData: presentationData, text: "ÐÐ½Ñ‚Ð¸ÑƒÐ´Ð°Ð»ÐµÐ½Ð¸Ðµ", sectionId: SosuzagramSettingsSection.antiDelete.rawValue)
        }
    ))
    entries.append(SosuzagramSettingsEntry(
        section: SosuzagramSettingsSection.antiDelete.rawValue,
        stableId: 6,
        sortId: 6,
        signature: "history:\(keepLocalHistory)",
        buildItem: { presentationData, arguments in
            ItemListSwitchItem(presentationData: presentationData, systemStyle: sosuzagramSettingsSystemStyle(), title: "Ð¡Ð¾Ñ…Ñ€Ð°Ð½ÑÑ‚ÑŒ ÑƒÐ´Ð°Ð»Ñ‘Ð½Ð½Ñ‹Ðµ ÑÐ¾Ð¾Ð±Ñ‰ÐµÐ½Ð¸Ñ", value: keepLocalHistory, sectionId: SosuzagramSettingsSection.antiDelete.rawValue, style: .blocks, updated: { value in
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
            ItemListSwitchItem(presentationData: presentationData, systemStyle: sosuzagramSettingsSystemStyle(), title: "ÐŸÐ¾ÐºÐ°Ð·Ñ‹Ð²Ð°Ñ‚ÑŒ Ð¼ÐµÑ‚ÐºÑƒ ÑƒÐ´Ð°Ð»ÐµÐ½Ð¸Ñ", value: showMarker, sectionId: SosuzagramSettingsSection.antiDelete.rawValue, style: .blocks, updated: { value in
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
            ItemListTextItem(presentationData: presentationData, text: .plain("Ð›Ð¾ÐºÐ°Ð»ÑŒÐ½Ð¾ ÑÐ¾Ñ…Ñ€Ð°Ð½ÑÐµÑ‚ ÑƒÐ´Ð°Ð»Ñ‘Ð½Ð½Ñ‹Ðµ Ð¸ Ð¾Ñ‚Ñ€ÐµÐ´Ð°ÐºÑ‚Ð¸Ñ€Ð¾Ð²Ð°Ð½Ð½Ñ‹Ðµ ÑÐ¾Ð¾Ð±Ñ‰ÐµÐ½Ð¸Ñ. Ð£Ð´Ð°Ð»Ñ‘Ð½Ð½Ñ‹Ðµ ÑÐ¾Ð¾Ð±Ñ‰ÐµÐ½Ð¸Ñ Ð¼Ð¾Ð¶Ð½Ð¾ Ð¿Ð¾Ð¼ÐµÑ‡Ð°Ñ‚ÑŒ Ð¾Ñ‚Ð´ÐµÐ»ÑŒÐ½Ð¾Ð¹ Ð¼ÐµÑ‚ÐºÐ¾Ð¹."), sectionId: SosuzagramSettingsSection.antiDelete.rawValue)
        }
    ))

    entries.append(SosuzagramSettingsEntry(
        section: SosuzagramSettingsSection.translation.rawValue,
        stableId: 40,
        sortId: 15,
        signature: "translate-header",
        buildItem: { presentationData, _ in
            ItemListSectionHeaderItem(presentationData: presentationData, text: "ÐŸÐµÑ€ÐµÐ²Ð¾Ð´", sectionId: SosuzagramSettingsSection.translation.rawValue)
        }
    ))
    entries.append(SosuzagramSettingsEntry(
        section: SosuzagramSettingsSection.translation.rawValue,
        stableId: 41,
        sortId: 16,
        signature: "showtranslate:\(showTranslateMessages)",
        buildItem: { presentationData, arguments in
            ItemListSwitchItem(presentationData: presentationData, systemStyle: sosuzagramSettingsSystemStyle(), title: "ÐŸÐ¾ÐºÐ°Ð·Ñ‹Ð²Ð°Ñ‚ÑŒ ÐºÐ½Ð¾Ð¿ÐºÑƒ Â«ÐŸÐµÑ€ÐµÐ²ÐµÑÑ‚Ð¸Â»", value: showTranslateMessages, sectionId: SosuzagramSettingsSection.translation.rawValue, style: .blocks, updated: { value in
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
            ItemListSwitchItem(presentationData: presentationData, systemStyle: sosuzagramSettingsSystemStyle(), title: "ÐŸÐµÑ€ÐµÐ²Ð¾Ð´Ð¸Ñ‚ÑŒ Ñ‡Ð°Ñ‚Ñ‹ Ñ†ÐµÐ»Ð¸ÐºÐ¾Ð¼", value: translateEntireChats, sectionId: SosuzagramSettingsSection.translation.rawValue, style: .blocks, updated: { value in
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
                title: "Провайдер перевода",
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
                title: "Целевой язык",
                label: sosuzagramTranslationTargetLabel(translationTarget),
                additionalDetailLabel: "Используется как язык по умолчанию для ручного перевода и экранов перевода Sosuzagram.",
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
                title: "ÐÐµ Ð¿ÐµÑ€ÐµÐ²Ð¾Ð´Ð¸Ñ‚ÑŒ",
                label: doNotTranslateSummary,
                additionalDetailLabel: "Ð’Ñ‹Ð±ÐµÑ€Ð¸ ÑÐ·Ñ‹ÐºÐ¸, ÐºÐ¾Ñ‚Ð¾Ñ€Ñ‹Ðµ Ð½Ðµ Ð½ÑƒÐ¶Ð½Ð¾ Ð¿ÐµÑ€ÐµÐ²Ð¾Ð´Ð¸Ñ‚ÑŒ Ð°Ð²Ñ‚Ð¾Ð¼Ð°Ñ‚Ð¸Ñ‡ÐµÑÐºÐ¸.",
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
                title: "Ð¯Ð·Ñ‹Ðº Ð¿Ñ€Ð¸Ð»Ð¾Ð¶ÐµÐ½Ð¸Ñ Ð¸ Ð¿ÐµÑ€ÐµÐ²Ð¾Ð´",
                additionalDetailLabel: "ÐžÑ‚ÐºÑ€Ñ‹Ð²Ð°ÐµÑ‚ ÑÐ¸ÑÑ‚ÐµÐ¼Ð½Ñ‹Ð¹ ÑÐºÑ€Ð°Ð½ Telegram Ñ ÑÐ·Ñ‹ÐºÐ¾Ð¼ Ð¿Ñ€Ð¸Ð»Ð¾Ð¶ÐµÐ½Ð¸Ñ Ð¸ Ð´Ð¾Ð¿Ð¾Ð»Ð½Ð¸Ñ‚ÐµÐ»ÑŒÐ½Ñ‹Ð¼Ð¸ ÑÐ·Ñ‹ÐºÐ¾Ð²Ñ‹Ð¼Ð¸ Ð½Ð°ÑÑ‚Ñ€Ð¾Ð¹ÐºÐ°Ð¼Ð¸.",
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
            ItemListSectionHeaderItem(presentationData: presentationData, text: "Ð˜Ð½Ñ‚ÐµÑ€Ñ„ÐµÐ¹Ñ Ð¸ Ð¿Ð¾Ð´Ñ‚Ð²ÐµÑ€Ð¶Ð´ÐµÐ½Ð¸Ñ", sectionId: SosuzagramSettingsSection.ui.rawValue)
        }
    ))
    entries.append(SosuzagramSettingsEntry(
        section: SosuzagramSettingsSection.ui.rawValue,
        stableId: 10,
        sortId: 10,
        signature: "stories:\(hideStories)",
        buildItem: { presentationData, arguments in
            ItemListSwitchItem(presentationData: presentationData, systemStyle: sosuzagramSettingsSystemStyle(), title: "Ð¡ÐºÑ€Ñ‹Ð²Ð°Ñ‚ÑŒ Ð¸ÑÑ‚Ð¾Ñ€Ð¸Ð¸ Ð² ÑÐ¿Ð¸ÑÐºÐµ Ñ‡Ð°Ñ‚Ð¾Ð²", value: hideStories, sectionId: SosuzagramSettingsSection.ui.rawValue, style: .blocks, updated: { value in
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
            ItemListSwitchItem(presentationData: presentationData, systemStyle: sosuzagramSettingsSystemStyle(), title: "ÐŸÐ¾Ð´Ñ‚Ð²ÐµÑ€Ð¶Ð´Ð°Ñ‚ÑŒ Ð³Ð¾Ð»Ð¾ÑÐ¾Ð²Ñ‹Ðµ Ð¸ Ð²Ð¸Ð´ÐµÐ¾Ð·Ð²Ð¾Ð½ÐºÐ¸", value: confirmCalls, sectionId: SosuzagramSettingsSection.ui.rawValue, style: .blocks, updated: { value in
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
            ItemListSwitchItem(presentationData: presentationData, systemStyle: sosuzagramSettingsSystemStyle(), title: "ÐŸÐ¾Ð´Ñ‚Ð²ÐµÑ€Ð¶Ð´Ð°Ñ‚ÑŒ Ð¾Ñ‚Ð¿Ñ€Ð°Ð²ÐºÑƒ Ð³Ð¾Ð»Ð¾ÑÐ¾Ð²Ñ‹Ñ…", value: confirmVoiceMessages, sectionId: SosuzagramSettingsSection.ui.rawValue, style: .blocks, updated: { value in
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
            ItemListSwitchItem(presentationData: presentationData, systemStyle: sosuzagramSettingsSystemStyle(), title: "Ð¡ÐºÑ€Ñ‹Ð²Ð°Ñ‚ÑŒ Ð±Ð¾ÐºÐ¾Ð²ÑƒÑŽ ÐºÐ½Ð¾Ð¿ÐºÑƒ Â«ÐŸÐ¾Ð´ÐµÐ»Ð¸Ñ‚ÑŒÑÑÂ»", value: hideShareButton, sectionId: SosuzagramSettingsSection.ui.rawValue, style: .blocks, updated: { value in
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
            ItemListSwitchItem(presentationData: presentationData, systemStyle: sosuzagramSettingsSystemStyle(), title: "ÐŸÐ¾ÐºÐ°Ð·Ñ‹Ð²Ð°Ñ‚ÑŒ Ð¸Ñ‚Ð¾Ð³Ð¸ Ð¾Ð¿Ñ€Ð¾ÑÐ¾Ð² Ð´Ð¾ Ð³Ð¾Ð»Ð¾ÑÐ¾Ð²Ð°Ð½Ð¸Ñ", value: pollResultsBeforeVoting, sectionId: SosuzagramSettingsSection.ui.rawValue, style: .blocks, updated: { value in
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
            ItemListSwitchItem(presentationData: presentationData, systemStyle: sosuzagramSettingsSystemStyle(), title: "Ð¡ÐºÑ€Ñ‹Ð²Ð°Ñ‚ÑŒ ÐºÐ»Ð°Ð²Ð¸Ð°Ñ‚ÑƒÑ€Ñƒ Ð¿Ñ€Ð¸ Ð¿Ñ€Ð¾ÐºÑ€ÑƒÑ‚ÐºÐµ", value: hideKeyboardOnScroll, sectionId: SosuzagramSettingsSection.ui.rawValue, style: .blocks, updated: { value in
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
            ItemListSwitchItem(presentationData: presentationData, systemStyle: sosuzagramSettingsSystemStyle(), title: "Ð¡ÐºÑ€Ñ‹Ñ‚ÑŒ ÐºÐ½Ð¾Ð¿ÐºÑƒ Â«ÐžÑ‚Ð¿Ñ€Ð°Ð²Ð¸Ñ‚ÑŒ ÐºÐ°Ðº...Â»", value: hideSendAsButton, sectionId: SosuzagramSettingsSection.ui.rawValue, style: .blocks, updated: { value in
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
            ItemListSwitchItem(presentationData: presentationData, systemStyle: sosuzagramSettingsSystemStyle(), title: "Ð—Ð°Ð¼ÐµÐ½ÑÑ‚ÑŒ Â«Ð¸Ð·Ð¼ÐµÐ½ÐµÐ½Ð¾Â» Ð¸ÐºÐ¾Ð½ÐºÐ¾Ð¹", value: replaceEditedWithIcon, sectionId: SosuzagramSettingsSection.ui.rawValue, style: .blocks, updated: { value in
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
            ItemListSwitchItem(presentationData: presentationData, systemStyle: sosuzagramSettingsSystemStyle(), title: "Ð¡ÐºÑ€Ñ‹Ñ‚ÑŒ Ð¿Ð»Ð°Ð²Ð°ÑŽÑ‰ÑƒÑŽ ÐºÐ½Ð¾Ð¿ÐºÑƒ", value: hideFloatingButton, sectionId: SosuzagramSettingsSection.ui.rawValue, style: .blocks, updated: { value in
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
            ItemListSwitchItem(presentationData: presentationData, systemStyle: sosuzagramSettingsSystemStyle(), title: "Ð¡ÐºÑ€Ñ‹Ñ‚ÑŒ Ð²ÐºÐ»Ð°Ð´ÐºÑƒ Â«Ð’ÑÐµ Ñ‡Ð°Ñ‚Ñ‹Â»", value: hideAllChatsTab, sectionId: SosuzagramSettingsSection.ui.rawValue, style: .blocks, updated: { value in
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
            ItemListSwitchItem(presentationData: presentationData, systemStyle: sosuzagramSettingsSystemStyle(), title: "Ð¡ÐºÑ€Ñ‹Ñ‚ÑŒ Ð¿Ñ€Ð¸Ð²ÐµÑ‚ÑÑ‚Ð²ÐµÐ½Ð½Ñ‹Ð¹ ÑÑ‚Ð¸ÐºÐµÑ€", value: hideGreetingSticker, sectionId: SosuzagramSettingsSection.ui.rawValue, style: .blocks, updated: { value in
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
            ItemListSwitchItem(presentationData: presentationData, systemStyle: sosuzagramSettingsSystemStyle(), title: "Ð¡ÐºÑ€Ñ‹Ñ‚ÑŒ Ð²Ñ€ÐµÐ¼Ñ Ð½Ð° ÑÑ‚Ð¸ÐºÐµÑ€Ð°Ñ…", value: hideStickerTimestamp, sectionId: SosuzagramSettingsSection.ui.rawValue, style: .blocks, updated: { value in
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
            ItemListSwitchItem(presentationData: presentationData, systemStyle: sosuzagramSettingsSystemStyle(), title: "ÐÐµ Ð¾ÐºÑ€ÑƒÐ³Ð»ÑÑ‚ÑŒ Ð±Ð¾Ð»ÑŒÑˆÐ¸Ðµ Ñ‡Ð¸ÑÐ»Ð°", value: disableCompactNumericCounts, sectionId: SosuzagramSettingsSection.ui.rawValue, style: .blocks, updated: { value in
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
            ItemListSwitchItem(presentationData: presentationData, systemStyle: sosuzagramSettingsSystemStyle(), title: "ÐŸÐ¾ÐºÐ°Ð·Ñ‹Ð²Ð°Ñ‚ÑŒ Ð²Ñ€ÐµÐ¼Ñ Ñ ÑÐµÐºÑƒÐ½Ð´Ð°Ð¼Ð¸", value: formatTimeWithSeconds, sectionId: SosuzagramSettingsSection.ui.rawValue, style: .blocks, updated: { value in
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
            ItemListSwitchItem(presentationData: presentationData, systemStyle: sosuzagramSettingsSystemStyle(), title: "Ð—Ð°Ð¿ÑÑ‚Ð°Ñ Ð¿Ð¾ÑÐ»Ðµ ÑƒÐ¿Ð¾Ð¼Ð¸Ð½Ð°Ð½Ð¸Ñ", value: commaAfterMention, sectionId: SosuzagramSettingsSection.ui.rawValue, style: .blocks, updated: { value in
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
            ItemListSwitchItem(presentationData: presentationData, systemStyle: sosuzagramSettingsSystemStyle(), title: "ÐŸÐ¾ÐºÐ°Ð·Ñ‹Ð²Ð°Ñ‚ÑŒ Ð¸Ð½Ð´Ð¸ÐºÐ°Ñ‚Ð¾Ñ€ Ð¾Ð½Ð»Ð°Ð¹Ð½Ð°", value: showOnlineIndicator, sectionId: SosuzagramSettingsSection.ui.rawValue, style: .blocks, updated: { value in
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
            ItemListSwitchItem(presentationData: presentationData, systemStyle: sosuzagramSettingsSystemStyle(), title: "Ð£Ð±Ñ€Ð°Ñ‚ÑŒ Ñ…Ð²Ð¾ÑÑ‚ Ñƒ ÑÐ¾Ð¾Ð±Ñ‰ÐµÐ½Ð¸Ð¹", value: hideMessageTail, sectionId: SosuzagramSettingsSection.ui.rawValue, style: .blocks, updated: { value in
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
            ItemListSwitchItem(presentationData: presentationData, systemStyle: sosuzagramSettingsSystemStyle(), title: "Ð—Ð°Ð³Ð¾Ð»Ð¾Ð²Ð¾Ðº Ð¿Ð¾ Ñ†ÐµÐ½Ñ‚Ñ€Ñƒ", value: centerChatListTitle, sectionId: SosuzagramSettingsSection.ui.rawValue, style: .blocks, updated: { value in
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
            ItemListSwitchItem(presentationData: presentationData, systemStyle: sosuzagramSettingsSystemStyle(), title: "Ð˜ÑÐ¿Ð¾Ð»ÑŒÐ·Ð¾Ð²Ð°Ñ‚ÑŒ Ð¯Ð½Ð´ÐµÐºÑ ÐšÐ°Ñ€Ñ‚Ñ‹", value: useYandexMaps, sectionId: SosuzagramSettingsSection.ui.rawValue, style: .blocks, updated: { value in
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
            ItemListSwitchItem(presentationData: presentationData, systemStyle: sosuzagramSettingsSystemStyle(), title: "Ð¡ÐºÑ€Ñ‹Ð²Ð°Ñ‚ÑŒ ÑÑ‚Ð°Ñ‚ÑƒÑ Ð² ÑÐ¿Ð¸ÑÐºÐµ Ñ‡Ð°Ñ‚Ð¾Ð²", value: hideChatListStatus, sectionId: SosuzagramSettingsSection.ui.rawValue, style: .blocks, updated: { value in
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
            ItemListSwitchItem(presentationData: presentationData, systemStyle: sosuzagramSettingsSystemStyle(), title: "Ð¡ÐºÑ€Ñ‹Ñ‚ÑŒ Ð°Ñ€Ñ…Ð¸Ð² Ð¸Ð· ÑÐ¿Ð¸ÑÐºÐ° Ñ‡Ð°Ñ‚Ð¾Ð²", value: hideArchiveFromList, sectionId: SosuzagramSettingsSection.ui.rawValue, style: .blocks, updated: { value in
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
            ItemListSwitchItem(presentationData: presentationData, systemStyle: sosuzagramSettingsSystemStyle(), title: "ÐžÑ‚ÐºÑ€Ñ‹Ð²Ð°Ñ‚ÑŒ Ð°Ñ€Ñ…Ð¸Ð² ÑÐ²Ð°Ð¹Ð¿Ð¾Ð¼ Ð²Ð½Ð¸Ð·", value: openArchiveOnPull, sectionId: SosuzagramSettingsSection.ui.rawValue, style: .blocks, updated: { value in
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
            ItemListSwitchItem(presentationData: presentationData, systemStyle: sosuzagramSettingsSystemStyle(), title: "ÐžÑ‚ÐºÐ»ÑŽÑ‡Ð¸Ñ‚ÑŒ Ð²Ð¾Ð·Ð²Ñ€Ð°Ñ‚ Ð¸Ð· Ð°Ñ€Ñ…Ð¸Ð²Ð° ÑÐ²Ð°Ð¹Ð¿Ð¾Ð¼", value: disableArchiveReturnGesture, sectionId: SosuzagramSettingsSection.ui.rawValue, style: .blocks, updated: { value in
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
            ItemListSwitchItem(presentationData: presentationData, systemStyle: sosuzagramSettingsSystemStyle(), title: "ÐžÑ‚Ð½Ð¾ÑÐ¸Ñ‚ÐµÐ»ÑŒÐ½Ð¾Ðµ Ð²Ñ€ÐµÐ¼Ñ Ð¾Ð½Ð»Ð°Ð¹Ð½Ð°", value: relativeOnlineTime, sectionId: SosuzagramSettingsSection.ui.rawValue, style: .blocks, updated: { value in
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
            ItemListSwitchItem(presentationData: presentationData, systemStyle: sosuzagramSettingsSystemStyle(), title: "Ð¡ÐºÑ€Ñ‹Ð²Ð°Ñ‚ÑŒ Ð½Ð¾Ð¼ÐµÑ€ Ñ‚ÐµÐ»ÐµÑ„Ð¾Ð½Ð°", value: hidePhoneNumber, sectionId: SosuzagramSettingsSection.ui.rawValue, style: .blocks, updated: { value in
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
            ItemListSwitchItem(presentationData: presentationData, systemStyle: sosuzagramSettingsSystemStyle(), title: "ÐŸÐ¾ÐºÐ°Ð·Ñ‹Ð²Ð°Ñ‚ÑŒ ID / DC", value: showIdDc, sectionId: SosuzagramSettingsSection.ui.rawValue, style: .blocks, updated: { value in
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
            ItemListSwitchItem(presentationData: presentationData, systemStyle: sosuzagramSettingsSystemStyle(), title: "Ð¤Ð¸Ð»ÑŒÑ‚Ñ€ Zalgo", value: filterZalgo, sectionId: SosuzagramSettingsSection.ui.rawValue, style: .blocks, updated: { value in
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
            ItemListSwitchItem(presentationData: presentationData, systemStyle: sosuzagramSettingsSystemStyle(), title: "Ð’Ð¸Ð±Ñ€Ð°Ñ†Ð¸Ñ Ð¿Ñ€Ð¸Ð»Ð¾Ð¶ÐµÐ½Ð¸Ñ", value: appVibration, sectionId: SosuzagramSettingsSection.ui.rawValue, style: .blocks, updated: { value in
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
                title: "Ускорение загрузки",
                label: sosuzagramDownloadAccelerationLabel(downloadAcceleration),
                additionalDetailLabel: "Увеличивает число параллельных частей при скачивании файлов и медиа.",
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
            ItemListSwitchItem(presentationData: presentationData, systemStyle: sosuzagramSettingsSystemStyle(), title: "Ускорение отправки", value: uploadAcceleration, sectionId: SosuzagramSettingsSection.ui.rawValue, style: .blocks, updated: { value in
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
                title: "Язык распознавания",
                label: sosuzagramVoiceRecognitionLocaleLabel(voiceRecognitionLocale),
                additionalDetailLabel: "Используется для локальной транскрибации голосовых и видеосообщений.",
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
            ItemListSwitchItem(presentationData: presentationData, systemStyle: sosuzagramSettingsSystemStyle(), title: "Использовать ИИ для постобработки", value: voiceRecognitionOnDevice, sectionId: SosuzagramSettingsSection.ui.rawValue, style: .blocks, updated: { value in
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
            ItemListSwitchItem(presentationData: presentationData, systemStyle: sosuzagramSettingsSystemStyle(), title: "Ð¡ÐºÑ€Ñ‹Ñ‚ÑŒ Ñ€ÐµÐ°ÐºÑ†Ð¸Ð¸", value: hideReactions, sectionId: SosuzagramSettingsSection.ui.rawValue, style: .blocks, updated: { value in
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
                title: "Ð”Ð²Ð¾Ð¹Ð½Ð¾Ð¹ Ñ‚Ð°Ð¿ Ð¿Ð¾ Ð²Ñ…Ð¾Ð´ÑÑ‰Ð¸Ð¼",
                label: sosuzagramDoubleTapActionLabel(incomingDoubleTapAction),
                additionalDetailLabel: "Ð’Ñ‹Ð±Ð¸Ñ€Ð°ÐµÑ‚ Ð´ÐµÐ¹ÑÑ‚Ð²Ð¸Ðµ Ð¿Ð¾ Ð´Ð²Ð¾Ð¹Ð½Ð¾Ð¼Ñƒ Ð½Ð°Ð¶Ð°Ñ‚Ð¸ÑŽ Ð½Ð° Ð²Ñ…Ð¾Ð´ÑÑ‰ÐµÐµ ÑÐ¾Ð¾Ð±Ñ‰ÐµÐ½Ð¸Ðµ.",
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
                title: "Ð”Ð²Ð¾Ð¹Ð½Ð¾Ð¹ Ñ‚Ð°Ð¿ Ð¿Ð¾ Ð¸ÑÑ…Ð¾Ð´ÑÑ‰Ð¸Ð¼",
                label: sosuzagramDoubleTapActionLabel(outgoingDoubleTapAction),
                additionalDetailLabel: "Ð’Ñ‹Ð±Ð¸Ñ€Ð°ÐµÑ‚ Ð´ÐµÐ¹ÑÑ‚Ð²Ð¸Ðµ Ð¿Ð¾ Ð´Ð²Ð¾Ð¹Ð½Ð¾Ð¼Ñƒ Ð½Ð°Ð¶Ð°Ñ‚Ð¸ÑŽ Ð½Ð° Ð¸ÑÑ…Ð¾Ð´ÑÑ‰ÐµÐµ ÑÐ¾Ð¾Ð±Ñ‰ÐµÐ½Ð¸Ðµ.",
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
                title: "Ð Ð°Ð·Ð¼ÐµÑ€ ÑÑ‚Ð¸ÐºÐµÑ€Ð¾Ð²",
                label: sosuzagramStickerSizePresetLabel(stickerSizePreset),
                additionalDetailLabel: "ÐœÐµÐ½ÑÐµÑ‚ Ð¼Ð°ÑÑˆÑ‚Ð°Ð± Ð¾Ð±Ñ‹Ñ‡Ð½Ñ‹Ñ… Ð¸ Ð°Ð½Ð¸Ð¼Ð¸Ñ€Ð¾Ð²Ð°Ð½Ð½Ñ‹Ñ… ÑÑ‚Ð¸ÐºÐµÑ€Ð¾Ð² Ð² Ñ‡Ð°Ñ‚Ðµ.",
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
            ItemListSwitchItem(presentationData: presentationData, systemStyle: sosuzagramSettingsSystemStyle(), title: "Ð’ÑÐµÐ³Ð´Ð° Ð¾Ñ‚Ð¿Ñ€Ð°Ð²Ð»ÑÑ‚ÑŒ Ñ„Ð¾Ñ‚Ð¾ Ð² HD", value: alwaysSendHd, sectionId: SosuzagramSettingsSection.ui.rawValue, style: .blocks, updated: { value in
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
            ItemListSwitchItem(presentationData: presentationData, systemStyle: sosuzagramSettingsSystemStyle(), title: "ÐŸÑ€ÐµÐ´Ð¿Ð¾Ñ‡Ð¸Ñ‚Ð°Ñ‚ÑŒ original quality", value: preferOriginalQuality, sectionId: SosuzagramSettingsSection.ui.rawValue, style: .blocks, updated: { value in
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
            ItemListSwitchItem(presentationData: presentationData, systemStyle: sosuzagramSettingsSystemStyle(), title: "Ð¡ÐºÑ€Ñ‹Ñ‚ÑŒ ÑÑ‡Ñ‘Ñ‚Ñ‡Ð¸Ðº Ñ„Ð¾Ñ‚Ð¾", value: hidePhotoCounter, sectionId: SosuzagramSettingsSection.ui.rawValue, style: .blocks, updated: { value in
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
            ItemListSwitchItem(presentationData: presentationData, systemStyle: sosuzagramSettingsSystemStyle(), title: "Ð¡ÐºÑ€Ñ‹Ñ‚ÑŒ camera tile", value: hideCameraTile, sectionId: SosuzagramSettingsSection.ui.rawValue, style: .blocks, updated: { value in
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
                title: "Расширенные настройки камеры",
                text: "Включает расширенный выбор стартовой камеры, режима видеосообщений, статичного зума и запоминания последней камеры.",
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
            ItemListSwitchItem(presentationData: presentationData, systemStyle: sosuzagramSettingsSystemStyle(), title: "Включение звука кнопками громкости", text: "Разрешает быстро включать звук голосовых и кружков аппаратными кнопками громкости.", value: enableSoundWithVolumeButtons, sectionId: SosuzagramSettingsSection.ui.rawValue, style: .blocks, updated: { value in
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
                title: "Тип камеры",
                label: sosuzagramCameraTypeLabel(cameraType),
                additionalDetailLabel: "Определяет стартовый режим камеры: обычная или dual-camera, если устройство её поддерживает.",
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
            ItemListSwitchItem(presentationData: presentationData, systemStyle: sosuzagramSettingsSystemStyle(), title: "Картинка-картинке по свайпу", value: pictureInPictureSwipe, sectionId: SosuzagramSettingsSection.ui.rawValue, style: .blocks, updated: { value in
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
            ItemListSwitchItem(presentationData: presentationData, systemStyle: sosuzagramSettingsSystemStyle(), title: "Ð¡Ñ‚Ð°Ñ‚Ð¸Ñ‡ÐµÑÐºÐ¸Ð¹ zoom ÐºÐ°Ð¼ÐµÑ€Ñ‹", value: staticZoom, sectionId: SosuzagramSettingsSection.ui.rawValue, style: .blocks, updated: { value in
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
            ItemListSwitchItem(presentationData: presentationData, systemStyle: sosuzagramSettingsSystemStyle(), title: "Ð—Ð°Ð¿Ð¾Ð¼Ð¸Ð½Ð°Ñ‚ÑŒ Ð¿Ð¾ÑÐ»ÐµÐ´Ð½ÑŽÑŽ ÐºÐ°Ð¼ÐµÑ€Ñƒ", value: rememberLastCamera, sectionId: SosuzagramSettingsSection.ui.rawValue, style: .blocks, updated: { value in
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
                title: "ÐšÐ°Ð¼ÐµÑ€Ð° Ð² Ð²Ð¸Ð´ÐµÐ¾ÑÐ¾Ð¾Ð±Ñ‰ÐµÐ½Ð¸ÑÑ…",
                label: sosuzagramVideoMessageCameraLabel(videoMessageCamera),
                additionalDetailLabel: "Ð’Ñ‹Ð±Ð¸Ñ€Ð°ÐµÑ‚ ÑÑ‚Ð°Ñ€Ñ‚Ð¾Ð²ÑƒÑŽ ÐºÐ°Ð¼ÐµÑ€Ñƒ Ð´Ð»Ñ ÐºÑ€ÑƒÐ¶ÐºÐ¾Ð² Ð¸ ÑÐºÑ€Ð°Ð½Ð° ÐºÐ°Ð¼ÐµÑ€Ñ‹.",
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
            ItemListSwitchItem(presentationData: presentationData, systemStyle: sosuzagramSettingsSystemStyle(), title: "Ð‘ÐµÑÐºÐ¾Ð½ÐµÑ‡Ð½Ñ‹Ðµ recent stickers", value: infiniteRecentStickers, sectionId: SosuzagramSettingsSection.ui.rawValue, style: .blocks, updated: { value in
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
            ItemListSwitchItem(presentationData: presentationData, systemStyle: sosuzagramSettingsSystemStyle(), title: "Нижняя кнопка навигации", value: lowerNavigationButton, sectionId: SosuzagramSettingsSection.ui.rawValue, style: .blocks, updated: { value in
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
                title: "Ответы",
                label: sosuzagramReplyStyleLabel(replyStyle),
                additionalDetailLabel: "Меняет форму и подачу reply-блоков в сообщениях и панели ответа.",
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
                title: "Быстрые админ-действия",
                text: "Добавляет отдельный пункт админ-действий в меню сообщения там, где у аккаунта есть права модерации.",
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
                title: "Форма стикеров",
                label: sosuzagramStickerShapeLabel(stickerShape),
                additionalDetailLabel: "Переключает фон и форму bubble у стикеров между системным видом, закруглённой карточкой и обычным сообщением.",
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
                title: "Меню сообщения",
                text: "Включает кастомизацию основных действий в контекстном меню сообщения.",
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
                title: "Настроить меню сообщения",
                label: "\(sosuzagramMessageMenuEnabledCount())/8",
                additionalDetailLabel: "Управляет набором основных действий: ответ, копирование, перевод, озвучивание, сохранение, пересылка, выделение и удаление.",
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
                title: "Группировать меню сообщения",
                text: "Перемещает основные действия в нижнюю часть меню сообщения отдельным блоком.",
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
                title: "Ð¤Ð¾Ñ€Ð¼Ð° Ð°Ð²Ð°Ñ‚Ð°Ñ€Ð¾Ð²",
                label: sosuzagramAvatarShapeLabel(avatarShape),
                additionalDetailLabel: "ÐœÐµÐ½ÑÐµÑ‚ Ñ„Ð¾Ñ€Ð¼Ñƒ Ð°Ð²Ð°Ñ‚Ð°Ñ€Ð¾Ð² Ð² ÑÐ¿Ð¸ÑÐºÐµ Ñ‡Ð°Ñ‚Ð¾Ð².",
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
            ItemListSwitchItem(presentationData: presentationData, systemStyle: sosuzagramSettingsSystemStyle(), title: "Ð•Ð´Ð¸Ð½Ð¾Ðµ ÑÐºÑ€ÑƒÐ³Ð»ÐµÐ½Ð¸Ðµ Ð°Ð²Ð°Ñ‚Ð°Ñ€Ð¾Ð²", value: unifiedRounding, sectionId: SosuzagramSettingsSection.icons.rawValue, style: .blocks, updated: { value in
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
            ItemListSwitchItem(presentationData: presentationData, systemStyle: sosuzagramSettingsSystemStyle(), title: "ÐœÐ¸Ð½Ð¸-Ð°Ð²Ð°Ñ‚Ð°Ñ€Ñ‹", value: miniAvatars, sectionId: SosuzagramSettingsSection.icons.rawValue, style: .blocks, updated: { value in
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
            ItemListSwitchItem(presentationData: presentationData, systemStyle: sosuzagramSettingsSystemStyle(), title: "ÐžÑ‚ÐºÐ»ÑŽÑ‡Ð¸Ñ‚ÑŒ Ñ€Ð°Ð·Ð´ÐµÐ»Ð¸Ñ‚ÐµÐ»Ð¸", value: disableSeparators, sectionId: SosuzagramSettingsSection.icons.rawValue, style: .blocks, updated: { value in
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
                title: "Отдельные заголовки",
                text: "Визуально отделяет верхний заголовок списка чатов от панели вкладок и дополнительных блоков.",
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
                title: "Различные темы в чатах",
                text: "Позволяет каждому диалогу использовать собственную тему и обои вместо глобальной темы приложения.",
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
                additionalDetailLabel: "Управляет силой Android-подобного оформления для списка чатов, вкладок и связанных элементов интерфейса.",
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
                title: "Системные эмодзи",
                text: "Упрощает отображение эмодзи и кастомных значков в превью списка чатов, ближе к системному виду iOS.",
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
                title: "\"Липкая\" анимация аватарок",
                text: "Добавляет более вязкое и плавное движение аватарок при перестроении списка чатов и связанных переходах.",
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
            ItemListSwitchItem(presentationData: presentationData, systemStyle: sosuzagramSettingsSystemStyle(), title: "Android design (Exteragram)", text: "Включает пресет внешнего вида в стиле оригинального Exteragram и может потребовать перезапуск приложения.", value: androidDesign, sectionId: SosuzagramSettingsSection.icons.rawValue, style: .blocks, updated: { value in
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
            ItemListSwitchItem(presentationData: presentationData, systemStyle: sosuzagramSettingsSystemStyle(), title: "Плавные анимации", text: "Увеличивает длительность и сглаживает переходы в Sosuzagram и списке чатов.", value: smoothAnimations, sectionId: SosuzagramSettingsSection.icons.rawValue, style: .blocks, updated: { value in
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
            ItemListSwitchItem(presentationData: presentationData, systemStyle: sosuzagramSettingsSystemStyle(), title: "Системные шрифты", value: systemFonts, sectionId: SosuzagramSettingsSection.icons.rawValue, style: .blocks, updated: { value in
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
            ItemListSwitchItem(presentationData: presentationData, systemStyle: sosuzagramSettingsSystemStyle(), title: "Счётчик уведомлений папок", value: showFolderBadges, sectionId: SosuzagramSettingsSection.icons.rawValue, style: .blocks, updated: { value in
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
                title: "Наборы иконок",
                label: "Extera style",
                additionalDetailLabel: "Быстрый выбор альтернативной иконки приложения.",
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
                additionalDetailLabel: "Настраивает плотность и форму вкладок-плашек в списке чатов.",
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
                title: "Навигация в приложении",
                label: "Настроить",
                additionalDetailLabel: "Быстрый доступ к настройкам вкладок, папок и заголовка списка чатов.",
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
                title: "Ð¢ÐµÐºÑÑ‚ Ð² Ð·Ð°Ð³Ð¾Ð»Ð¾Ð²ÐºÐµ",
                label: sosuzagramChatListTitleTextLabel(chatListTitleText),
                additionalDetailLabel: "ÐœÐµÐ½ÑÐµÑ‚ Ñ‚ÐµÐºÑÑ‚ Ð²ÐµÑ€Ñ…Ð½ÐµÐ³Ð¾ Ð·Ð°Ð³Ð¾Ð»Ð¾Ð²ÐºÐ° ÑÐ¿Ð¸ÑÐºÐ° Ñ‡Ð°Ñ‚Ð¾Ð².",
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
                title: "Ð—Ð°Ð³Ð¾Ð»Ð¾Ð²ÐºÐ¸ Ð¿Ð°Ð¿Ð¾Ðº",
                label: sosuzagramFolderTabTitlesLabel(folderTabTitles),
                additionalDetailLabel: "ÐœÐµÐ½ÑÐµÑ‚, ÐºÐ°Ðº Ð¾Ñ‚Ð¾Ð±Ñ€Ð°Ð¶Ð°ÑŽÑ‚ÑÑ Ð½Ð°Ð·Ð²Ð°Ð½Ð¸Ñ Ð¸ Ð¸ÐºÐ¾Ð½ÐºÐ¸ Ð²ÐºÐ»Ð°Ð´Ð¾Ðº.",
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
            ItemListSwitchItem(presentationData: presentationData, systemStyle: sosuzagramSettingsSystemStyle(), title: "Принудительный снег", value: forceSnow, sectionId: SosuzagramSettingsSection.icons.rawValue, style: .blocks, updated: { value in
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
                title: "Блики на элементах",
                text: "Отключает стеклянные блики и яркую обводку на blur-элементах интерфейса.",
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
                title: "Принудительное размытие",
                text: "Принудительно включает blur/glass-эффект там, где система может использовать упрощённый стиль. Для полного применения лучше перезапустить приложение.",
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
        ("Ð¡Ñ‚Ð°Ð½Ð´Ð°Ñ€Ñ‚Ð½Ð°Ñ", "nil"),
        ("ÐšÑ€Ð°ÑÐ½Ð°Ñ (Extera style)", "Red"),
        ("Ð—ÐµÐ»Ñ‘Ð½Ð°Ñ (Extera style)", "Green"),
        ("ÐžÑ€Ð°Ð½Ð¶ÐµÐ²Ð°Ñ (Extera style)", "Orange"),
        ("Ð¤Ð¸Ð¾Ð»ÐµÑ‚Ð¾Ð²Ð°Ñ (Extera style)", "Purple")
    ]
    entries.append(SosuzagramSettingsEntry(
        section: SosuzagramSettingsSection.icons.rawValue,
        stableId: 13,
        sortId: 13,
        signature: "icons-header",
        buildItem: { presentationData, _ in
            ItemListSectionHeaderItem(presentationData: presentationData, text: "Ð˜ÐºÐ¾Ð½ÐºÐ¸ Ð¿Ñ€Ð¸Ð»Ð¾Ð¶ÐµÐ½Ð¸Ñ", sectionId: SosuzagramSettingsSection.icons.rawValue)
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
                    label: isSelected ? "Ð’Ñ‹Ð±Ñ€Ð°Ð½Ð¾" : "",
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
            ItemListSectionHeaderItem(presentationData: presentationData, text: "Ð’ÑÑ‚Ñ€Ð¾ÐµÐ½Ð½Ñ‹Ðµ Ñ€Ð°Ð·Ð´ÐµÐ»Ñ‹ Telegram", sectionId: SosuzagramSettingsSection.icons.rawValue)
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
                title: "Ð¢ÐµÐ¼Ñ‹ Telegram",
                additionalDetailLabel: "ÐžÑ‚ÐºÑ€Ñ‹Ð²Ð°ÐµÑ‚ ÑÐ¸ÑÑ‚ÐµÐ¼Ð½Ñ‹Ð¹ ÑÐºÑ€Ð°Ð½ Ñ‚ÐµÐ¼ Ð¸ Ð¾Ñ„Ð¾Ñ€Ð¼Ð»ÐµÐ½Ð¸Ñ Telegram.",
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
                title: "ÐŸÐ°Ð¿ÐºÐ¸ Ð¸ Ð²ÐºÐ»Ð°Ð´ÐºÐ¸",
                additionalDetailLabel: "ÐžÑ‚ÐºÑ€Ñ‹Ð²Ð°ÐµÑ‚ ÑÐ¸ÑÑ‚ÐµÐ¼Ð½Ñ‹Ðµ Ð½Ð°ÑÑ‚Ñ€Ð¾Ð¹ÐºÐ¸ Ð¿Ð°Ð¿Ð¾Ðº, Ñ„Ð¸Ð»ÑŒÑ‚Ñ€Ð¾Ð² Ð¸ Ð²ÐºÐ»Ð°Ð´Ð¾Ðº Telegram.",
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
            ItemListSectionHeaderItem(presentationData: presentationData, text: "ÐŸÐ»Ð°Ð³Ð¸Ð½Ñ‹ Extera (iOS)", sectionId: SosuzagramSettingsSection.plugins.rawValue)
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
                title: "Ð—Ð°Ð³Ñ€ÑƒÐ·Ð¸Ñ‚ÑŒ .plugin",
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
        let status = sosuzagramPluginEnabled(plugin.id) ? "Ð’ÐºÐ»" : "Ð’Ñ‹ÐºÐ»"
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
            ItemListTextItem(presentationData: presentationData, text: .plain("ÐÐ¾Ð²Ñ‹Ðµ .plugin-Ñ„Ð°Ð¹Ð»Ñ‹ Ð½Ðµ Ð¸Ð¼Ð¿Ð¾Ñ€Ñ‚Ð¸Ñ€ÑƒÑŽÑ‚ÑÑ Ð°Ð²Ñ‚Ð¾Ð¼Ð°Ñ‚Ð¸Ñ‡ÐµÑÐºÐ¸. Ð”Ð»Ñ ÐºÐ°Ð¶Ð´Ð¾Ð³Ð¾ Ð½Ð¾Ð²Ð¾Ð³Ð¾ Ð¿Ð»Ð°Ð³Ð¸Ð½Ð° Ð½ÑƒÐ¶ÐµÐ½ Ð¾Ñ‚Ð´ÐµÐ»ÑŒÐ½Ñ‹Ð¹ Ð½Ð°Ñ‚Ð¸Ð²Ð½Ñ‹Ð¹ Ð¿Ð¾Ñ€Ñ‚ Ð¿Ð¾Ð´ Sosuzagram."), sectionId: SosuzagramSettingsSection.plugins.rawValue)
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
            text = "Android design включён. Для полного применения пресета Exteragram лучше перезапустить приложение сейчас."
        } else {
            text = "Android design выключен. Чтобы интерфейс полностью вернулся к обычному стилю, перезапусти приложение."
        }
        controller.present(textAlertController(context: context, title: "Android design", text: text, actions: [
            TextAlertAction(type: .genericAction, title: "Позже", action: {}),
            TextAlertAction(type: .defaultAction, title: "Перезапустить", action: {
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
            text = "Принудительное размытие включено. Чтобы blur/glass-элементы гарантированно пересоздались во всём приложении, лучше перезапустить его сейчас."
        } else {
            text = "Принудительное размытие выключено. Чтобы blur/glass-элементы вернулись к обычному режиму без смешанных состояний, лучше перезапустить приложение."
        }
        controller.present(textAlertController(context: context, title: "Принудительное размытие", text: text, actions: [
            TextAlertAction(type: .genericAction, title: "Позже", action: {}),
            TextAlertAction(type: .defaultAction, title: "Перезапустить", action: {
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
            ("system", "Системный"),
            ("ru-RU", "Русский"),
            ("en-US", "English"),
            ("uk-UA", "Українська")
        ]

        let actionSheet = ActionSheetController(presentationData: presentationData)
        var items: [ActionSheetItem] = [ActionSheetTextItem(title: "Язык распознавания")]
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
            ("default", "Обычная"),
            ("fast", "Быстро"),
            ("faster", "Быстрее")
        ]

        let actionSheet = ActionSheetController(presentationData: presentationData)
        var items: [ActionSheetItem] = [ActionSheetTextItem(title: "Ускорение загрузки")]
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
            ("small", "ÐœÐ°Ð»ÐµÐ½ÑŒÐºÐ¸Ð¹"),
            ("medium", "Ð¡Ñ€ÐµÐ´Ð½Ð¸Ð¹"),
            ("large", "Ð‘Ð¾Ð»ÑŒÑˆÐ¾Ð¹")
        ]

        let actionSheet = ActionSheetController(presentationData: presentationData)
        var items: [ActionSheetItem] = [ActionSheetTextItem(title: "Ð Ð°Ð·Ð¼ÐµÑ€ ÑÑ‚Ð¸ÐºÐµÑ€Ð¾Ð²")]
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
            ("default", "По умолчанию"),
            ("rounded", "Закруглённая"),
            ("message", "Сообщение")
        ]

        let actionSheet = ActionSheetController(presentationData: presentationData)
        var items: [ActionSheetItem] = [ActionSheetTextItem(title: "Форма стикеров")]
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
            ("system", "Системно"),
            ("camera1", "Camera 1"),
            ("camera2", "Camera 2")
        ]

        let actionSheet = ActionSheetController(presentationData: presentationData)
        var items: [ActionSheetItem] = [ActionSheetTextItem(title: "Тип камеры")]
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
            ("system", "Ð¡Ð¸ÑÑ‚ÐµÐ¼Ð½Ð¾"),
            ("front", "Ð¤Ñ€Ð¾Ð½Ñ‚Ð°Ð»ÑŒÐ½Ð°Ñ"),
            ("back", "ÐžÑÐ½Ð¾Ð²Ð½Ð°Ñ"),
            ("last", "ÐŸÐ¾ÑÐ»ÐµÐ´Ð½ÑÑ")
        ]

        let actionSheet = ActionSheetController(presentationData: presentationData)
        var items: [ActionSheetItem] = [ActionSheetTextItem(title: "ÐšÐ°Ð¼ÐµÑ€Ð° Ð² Ð²Ð¸Ð´ÐµÐ¾ÑÐ¾Ð¾Ð±Ñ‰ÐµÐ½Ð¸ÑÑ…")]
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
            ("system", "Ð¡Ð¸ÑÑ‚ÐµÐ¼Ð½Ð¾"),
            ("circle", "ÐšÑ€ÑƒÐ³"),
            ("rounded", "Ð¡ÐºÑ€ÑƒÐ³Ð»Ñ‘Ð½Ð½Ð°Ñ"),
            ("square", "ÐšÐ²Ð°Ð´Ñ€Ð°Ñ‚")
        ]

        let actionSheet = ActionSheetController(presentationData: presentationData)
        var items: [ActionSheetItem] = [ActionSheetTextItem(title: "Ð¤Ð¾Ñ€Ð¼Ð° Ð°Ð²Ð°Ñ‚Ð°Ñ€Ð¾Ð²")]
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
            (0, "Отключено"),
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
            ("default", "По умолчанию"),
            ("rounded", "Закруглённые"),
            ("message", "Сообщения")
        ]

        let actionSheet = ActionSheetController(presentationData: presentationData)
        var items: [ActionSheetItem] = [ActionSheetTextItem(title: "Ответы")]
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
            ("off", "Отключено"),
            ("compact", "Компактный"),
            ("stacked", "Стек")
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
            (.reactions, "Ð ÐµÐ°ÐºÑ†Ð¸Ð¸"),
            (.none, "ÐÐµÑ‚")
        ]
        var items: [ActionSheetItem] = [ActionSheetTextItem(title: "Ð”Ð²Ð¾Ð¹Ð½Ð¾Ð¹ Ñ‚Ð°Ð¿ Ð¿Ð¾ Ð²Ñ…Ð¾Ð´ÑÑ‰Ð¸Ð¼ ÑÐ¾Ð¾Ð±Ñ‰ÐµÐ½Ð¸ÑÐ¼")]
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
            (.reactions, "Ð ÐµÐ°ÐºÑ†Ð¸Ð¸"),
            (.none, "ÐÐµÑ‚")
        ]
        var items: [ActionSheetItem] = [ActionSheetTextItem(title: "Ð”Ð²Ð¾Ð¹Ð½Ð¾Ð¹ Ñ‚Ð°Ð¿ Ð¿Ð¾ Ð¸ÑÑ…Ð¾Ð´ÑÑ‰Ð¸Ð¼ ÑÐ¾Ð¾Ð±Ñ‰ÐµÐ½Ð¸ÑÐ¼")]
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
            ("name", "Ð˜Ð¼Ñ"),
            ("username", "Username"),
            ("name_and_username", "Ð˜Ð¼Ñ Ð¸ username")
        ]

        let actionSheet = ActionSheetController(presentationData: presentationData)
        var items: [ActionSheetItem] = [ActionSheetTextItem(title: "Ð¢ÐµÐºÑÑ‚ Ð² Ð·Ð°Ð³Ð¾Ð»Ð¾Ð²ÐºÐµ")]
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
            ("title_and_icon", "ÐÐ°Ð·Ð²Ð°Ð½Ð¸Ðµ Ð¸ Ð¸ÐºÐ¾Ð½ÐºÐ°"),
            ("title", "ÐÐ°Ð·Ð²Ð°Ð½Ð¸Ðµ"),
            ("icon", "Ð¢Ð¾Ð»ÑŒÐºÐ¾ Ð¸ÐºÐ¾Ð½ÐºÐ°")
        ]

        let actionSheet = ActionSheetController(presentationData: presentationData)
        var items: [ActionSheetItem] = [ActionSheetTextItem(title: "Ð—Ð°Ð³Ð¾Ð»Ð¾Ð²ÐºÐ¸ Ð¿Ð°Ð¿Ð¾Ðº")]
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
        controller?.push(translationSettingsController(context: context))
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
            ("system", "Системный")
        ]

        let actionSheet = ActionSheetController(presentationData: presentationData)
        var items: [ActionSheetItem] = [ActionSheetTextItem(title: "Провайдер перевода")]
        for (value, title) in options {
            let itemTitle = value == currentValue ? "[selected] \(title)" : title
            items.append(ActionSheetButtonItem(title: itemTitle, color: .accent, action: { [weak actionSheet] in
                actionSheet?.dismissAnimated()
                UserDefaults.standard.set(value, forKey: "sosuzagram_translation_provider")
                updateSettingsImpl?()
            }))
        }
        items.append(ActionSheetTextItem(title: "Telegram использует встроенный перевод Telegram, Google включает альтернативный перевод, а системный режим использует iOS Translate, если он доступен."))
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
            ("app", "Язык приложения"),
            ("system", "Язык системы"),
            ("ru", "Русский"),
            ("en", "English"),
            ("uk", "Українська")
        ]

        let actionSheet = ActionSheetController(presentationData: presentationData)
        var items: [ActionSheetItem] = [ActionSheetTextItem(title: "Целевой язык")]
        for (value, title) in options {
            let itemTitle = value == currentValue ? "[selected] \(title)" : title
            items.append(ActionSheetButtonItem(title: itemTitle, color: .accent, action: { [weak actionSheet] in
                actionSheet?.dismissAnimated()
                UserDefaults.standard.set(value, forKey: "sosuzagram_translation_target")
                updateSettingsImpl?()
            }))
        }
        items.append(ActionSheetTextItem(title: "Язык приложения повторяет текущую локализацию Telegram, а язык системы берётся из основных языковых настроек iOS."))
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
        controller?.push(LocalizationListController(context: context))
    }
    openThemeSettingsImpl = { [weak controller] in
        controller?.push(themeSettingsController(context: context))
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
                ActionSheetTextItem(title: "Навигация в приложении"),
                ActionSheetButtonItem(title: "Папки и вкладки", color: .accent, action: { [weak actionSheet] in
                    actionSheet?.dismissAnimated()
                    openChatFoldersSettingsImpl?()
                }),
                ActionSheetButtonItem(title: "Текст в заголовке", color: .accent, action: { [weak actionSheet] in
                    actionSheet?.dismissAnimated()
                    openChatListTitleTextImpl?()
                }),
                ActionSheetButtonItem(title: "Заголовки папок", color: .accent, action: { [weak actionSheet] in
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
            ("Стандартная", "nil"),
            ("Красная (Extera style)", "Red"),
            ("Зелёная (Extera style)", "Green"),
            ("Оранжевая (Extera style)", "Orange"),
            ("Фиолетовая (Extera style)", "Purple")
        ]

        let actionSheet = ActionSheetController(presentationData: presentationData)
        var items: [ActionSheetItem] = [ActionSheetTextItem(title: "Наборы иконок")]
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
                controller.present(textAlertController(context: context, title: "Ð˜Ð¼Ð¿Ð¾Ñ€Ñ‚ Ð¿Ð»Ð°Ð³Ð¸Ð½Ð°", text: "Ð’Ñ‹Ð±ÐµÑ€Ð¸ Ñ„Ð°Ð¹Ð» Ñ Ñ€Ð°ÑÑˆÐ¸Ñ€ÐµÐ½Ð¸ÐµÐ¼ .plugin Ð¸Ð»Ð¸ .sosuzagramplugin.", actions: [
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
                    actions.append(TextAlertAction(type: .genericAction, title: "ÐžÑ‚ÐºÑ€Ñ‹Ñ‚ÑŒ", action: {
                        controller.push(sosuzagramPluginSettingsController(context: context, pluginId: importedPlugin.id))
                    }))
                }
                actions.append(TextAlertAction(type: .defaultAction, title: presentationData.strings.Common_OK, action: {}))

                let message: String
                if supportedPlugin != nil {
                    message = "ÐŸÐ»Ð°Ð³Ð¸Ð½ \(importedPlugin.name) Ð¸Ð¼Ð¿Ð¾Ñ€Ñ‚Ð¸Ñ€Ð¾Ð²Ð°Ð½ Ð¸ Ð²ÐºÐ»ÑŽÑ‡Ñ‘Ð½. Ð•Ð³Ð¾ Ð½Ð°ÑÑ‚Ñ€Ð¾Ð¹ÐºÐ¸ ÑƒÐ¶Ðµ Ð´Ð¾ÑÑ‚ÑƒÐ¿Ð½Ñ‹ Ð² Sosuzagram."
                } else {
                    message = "Ð¤Ð°Ð¹Ð» \(importedPlugin.name) Ð¸Ð¼Ð¿Ð¾Ñ€Ñ‚Ð¸Ñ€Ð¾Ð²Ð°Ð½ Ð² SosuzagramPlugins, Ð½Ð¾ Ð´Ð»Ñ Ñ€Ð°Ð±Ð¾Ñ‚Ñ‹ Ð½ÑƒÐ¶ÐµÐ½ Ð¾Ñ‚Ð´ÐµÐ»ÑŒÐ½Ñ‹Ð¹ Ð½Ð°Ñ‚Ð¸Ð²Ð½Ñ‹Ð¹ Ð¿Ð¾Ñ€Ñ‚ Ð¿Ð¾Ð´ iOS."
                }

                controller.present(textAlertController(context: context, title: "Ð˜Ð¼Ð¿Ð¾Ñ€Ñ‚ Ð¿Ð»Ð°Ð³Ð¸Ð½Ð°", text: message, actions: actions), in: .window(.root))
            } catch {
                controller.present(textAlertController(context: context, title: "Ð˜Ð¼Ð¿Ð¾Ñ€Ñ‚ Ð¿Ð»Ð°Ð³Ð¸Ð½Ð°", text: "ÐÐµ ÑƒÐ´Ð°Ð»Ð¾ÑÑŒ Ð¸Ð¼Ð¿Ð¾Ñ€Ñ‚Ð¸Ñ€Ð¾Ð²Ð°Ñ‚ÑŒ Ñ„Ð°Ð¹Ð»: \(error.localizedDescription)", actions: [
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
                    text: .plain("Выбирает, какие основные действия остаются в меню сообщения, когда включена кастомизация меню."),
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
                    text: .plain("Сейчас активно \(sosuzagramMessageMenuEnabledCount()) из \(SosuzagramMessageMenuOption.allCases.count) основных действий."),
                    sectionId: 2
                )
            }
        ))

        return (
            ItemListControllerState(
                presentationData: ItemListPresentationData(presentationData),
                title: .text("Меню сообщения"),
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
