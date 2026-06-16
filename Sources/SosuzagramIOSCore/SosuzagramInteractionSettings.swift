import Foundation

public enum SosuzagramDoubleTapAction: String, CaseIterable {
    case reactions
    case none
}

public func sosuzagramDoubleTapAction(incoming: Bool) -> SosuzagramDoubleTapAction {
    let key = incoming ? "sosuzagram_double_tap_action_incoming" : "sosuzagram_double_tap_action_outgoing"
    let rawValue = UserDefaults.standard.string(forKey: key) ?? SosuzagramDoubleTapAction.reactions.rawValue
    return SosuzagramDoubleTapAction(rawValue: rawValue) ?? .reactions
}

public func sosuzagramSetDoubleTapAction(incoming: Bool, action: SosuzagramDoubleTapAction) {
    let key = incoming ? "sosuzagram_double_tap_action_incoming" : "sosuzagram_double_tap_action_outgoing"
    UserDefaults.standard.set(action.rawValue, forKey: key)
}
