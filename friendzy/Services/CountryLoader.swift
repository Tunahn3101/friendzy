import Foundation

final class CountryLoader {
    // simple in-memory cache so we only parse once
    private static var cached: [Country]?

    static func load() -> [Country] {
        if let c = cached { return c }

        // Load raw file from bundle
        guard let url = Bundle.main.url(forResource: "country", withExtension: "json"),
              let data = try? Data(contentsOf: url) else {
            cached = []
            return []
        }

        // First try to decode as proper JSON [Country]
        if let decoded = try? JSONDecoder().decode([Country].self, from: data) {
            let sorted = decoded.sorted { $0.name.localizedCaseInsensitiveCompare($1.name) == .orderedAscending }
            cached = sorted
            return sorted
        }

        // Otherwise parse the JS-like content using regex
        guard let s = String(data: data, encoding: .utf8) else { cached = []; return [] }
        do {
            let pattern = "\\{\\s*name:\\s*'([^']+)'\\s*,\\s*code:\\s*'([^']+)'\\s*\\}"
            let re = try NSRegularExpression(pattern: pattern, options: [])
            let matches = re.matches(in: s, options: [], range: NSRange(location: 0, length: s.utf16.count))
            var countries: [Country] = []
            for m in matches {
                if m.numberOfRanges >= 3,
                   let r1 = Range(m.range(at: 1), in: s),
                   let r2 = Range(m.range(at: 2), in: s) {
                    let name = String(s[r1])
                    let code = String(s[r2])
                    countries.append(Country(name: name, code: code))
                }
            }
            let sorted = countries.sorted { $0.name.localizedCaseInsensitiveCompare($1.name) == .orderedAscending }
            cached = sorted
            return sorted
        } catch {
            cached = []
            return []
        }
    }

    static func clearCache() {
        cached = nil
    }
}
