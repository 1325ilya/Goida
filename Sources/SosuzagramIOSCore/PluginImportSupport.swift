import Foundation

public struct ImportedPlugin {
    public let id: String
    public let name: String
    public let desc: String
    public let author: String
    public let version: String
}

private func extractPluginMetadataValue(from line: String) -> String? {
    let parts = line.components(separatedBy: "=")
    guard parts.count >= 2 else {
        return nil
    }

    let value = parts[1...].joined(separator: "=").trimmingCharacters(in: .whitespaces)
    if (value.hasPrefix("\"") && value.hasSuffix("\"")) || (value.hasPrefix("'") && value.hasSuffix("'")) {
        return String(value.dropFirst().dropLast())
    }

    return value
}

public func parsePlugin(at url: URL) -> ImportedPlugin? {
    guard let content = try? String(contentsOf: url, encoding: .utf8) else {
        return nil
    }

    var id: String?
    var name: String?
    var desc: String?
    var author: String?
    var version: String?

    for line in content.components(separatedBy: .newlines) {
        let trimmed = line.trimmingCharacters(in: .whitespaces)
        if trimmed.hasPrefix("__id__") {
            id = extractPluginMetadataValue(from: trimmed)
        } else if trimmed.hasPrefix("__name__") {
            name = extractPluginMetadataValue(from: trimmed)
        } else if trimmed.hasPrefix("__description__") {
            desc = extractPluginMetadataValue(from: trimmed)
        } else if trimmed.hasPrefix("__author__") {
            author = extractPluginMetadataValue(from: trimmed)
        } else if trimmed.hasPrefix("__version__") {
            version = extractPluginMetadataValue(from: trimmed)
        }
    }

    guard let id, let name else {
        return nil
    }

    return ImportedPlugin(
        id: id,
        name: name,
        desc: desc ?? "",
        author: author ?? "",
        version: version ?? ""
    )
}
