import Foundation

struct GeneratedPairs: Codable {
    let date: Date
    var pairs: [Pair] = []
    
    init() {
        self.date = Calendar.current.startOfDay(for: Date())
    }
}

// MARK: - FormatStyle
extension GeneratedPairs {
    struct FormatStyle: Foundation.FormatStyle {
        typealias FormatInput = GeneratedPairs
        typealias FormatOutput = String
        
        let config: Config
        
        func format(_ value: GeneratedPairs) -> String {
            var formatted = "Generated \(value.date.formatted(date: .long, time: .omitted))\n"
            for pair in value.pairs {
                guard let item2 = config.item2Name(for: pair.item2) else { continue }
                formatted += "- \(pair.item1) and \(item2)\n"
            }
            return formatted
        }
    }
    
    func formatted(using config: Config) -> String {
        FormatStyle(config: config).format(self)
    }
}
