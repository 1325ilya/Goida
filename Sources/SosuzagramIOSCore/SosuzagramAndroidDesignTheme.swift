import Foundation
import UIKit

public struct SosuzagramAndroidDesignTheme {
    public let chatListCardInsets: UIEdgeInsets
    public let chatListCardCornerRadius: CGFloat
    public let chatListCardShadowOpacity: Float
    public let usesLegacyListSystemStyle: Bool
    public let replyPanelInsets: UIEdgeInsets
    public let replyPanelCornerRadius: CGFloat
    public let replyPanelBackgroundAlpha: CGFloat
}

public enum SosuzagramAndroidDesignThemeProvider {
    public static func current() -> SosuzagramAndroidDesignTheme? {
        guard SosuzagramAndroidDesignManager.isEnabled else {
            return nil
        }

        let materialLevel = SosuzagramAndroidDesignManager.materialDesignLevel()
        let cornerRadius: CGFloat
        let shadowOpacity: Float
        switch materialLevel {
        case 3:
            cornerRadius = 26.0
            shadowOpacity = 0.0
        case 2:
            cornerRadius = 22.0
            shadowOpacity = 0.0
        default:
            cornerRadius = 20.0
            shadowOpacity = 0.0
        }

        return SosuzagramAndroidDesignTheme(
            chatListCardInsets: UIEdgeInsets(top: 3.0, left: 10.0, bottom: 3.0, right: 10.0),
            chatListCardCornerRadius: cornerRadius,
            chatListCardShadowOpacity: shadowOpacity,
            usesLegacyListSystemStyle: true,
            replyPanelInsets: UIEdgeInsets(top: 4.0, left: 8.0, bottom: 4.0, right: 4.0),
            replyPanelCornerRadius: 22.0,
            replyPanelBackgroundAlpha: materialLevel >= 3 ? 0.92 : 0.82
        )
    }

    public static func filterBackgroundHeight(pillStackMode: String) -> CGFloat {
        switch pillStackMode {
        case "compact":
            return 40.0
        case "stacked":
            return 48.0
        default:
            return 44.0
        }
    }

    public static func filterCornerRadius(backgroundHeight: CGFloat, pillStackMode: String) -> CGFloat {
        switch pillStackMode {
        case "compact":
            return 16.0
        case "stacked":
            return 20.0
        default:
            break
        }
        switch SosuzagramAndroidDesignManager.materialDesignLevel() {
        case 3:
            return 16.0
        case 2:
            return 18.0
        case 1:
            return 20.0
        default:
            return backgroundHeight * 0.5
        }
    }

    public static func filterSelectedHeight(pillStackMode: String) -> CGFloat {
        switch pillStackMode {
        case "compact":
            return 32.0
        case "stacked":
            return 38.0
        default:
            return 36.0
        }
    }

    public static func filterSelectedHorizontalInset(pillStackMode: String) -> CGFloat {
        switch pillStackMode {
        case "compact":
            return 8.0
        case "stacked":
            return 12.0
        default:
            return 10.0
        }
    }

    public static func filterSelectedCornerRadius(selectedHeight: CGFloat, pillStackMode: String) -> CGFloat {
        switch (SosuzagramAndroidDesignManager.materialDesignLevel(), pillStackMode) {
        case (_, "compact"):
            return 12.0
        case (_, "stacked"):
            return 18.0
        case (3, _):
            return 14.0
        case (2, _):
            return 15.0
        case (1, _):
            return 16.0
        default:
            return selectedHeight * 0.5
        }
    }

    public static func replyPanelCornerRadius(replyStyle: String) -> CGFloat {
        if let theme = current() {
            return theme.replyPanelCornerRadius
        }
        switch replyStyle {
        case "rounded":
            return 11.0
        case "message":
            return 16.0
        default:
            return 0.0
        }
    }

    public static func replyPanelBackgroundAlpha(replyStyle: String) -> CGFloat {
        if let theme = current() {
            return theme.replyPanelBackgroundAlpha
        }
        switch replyStyle {
        case "rounded":
            return 0.45
        case "message":
            return 0.8
        default:
            return 0.0
        }
    }
}
