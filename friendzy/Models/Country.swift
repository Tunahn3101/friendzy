import Foundation

struct Country: Identifiable, Codable, Hashable {
    var id: String { code }
    let name: String
    let code: String
}

extension Country {
    /// Returns the regional indicator emoji flag for the country code, e.g. "US" -> 🇺🇸
    var flagEmoji: String {
        let upper = code.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        var scalarString = ""
        for ch in upper.unicodeScalars {
            guard let v = UnicodeScalar(127397 + Int(ch.value)) else { continue }
            scalarString.unicodeScalars.append(v)
        }
        return scalarString
    }
}
