import Foundation

struct GeneratedPairsHistoryStorage {
    let url: URL = .historyFile
    
    private(set) var history: [GeneratedPairs]
    
    init() throws {
        guard let data = try? Data(contentsOf: url) else {
            self.history = []
            return
        }
        
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        self.history = try decoder.decode([GeneratedPairs].self, from: data)
    }
    
    mutating func append(_ pairs: GeneratedPairs) {
        history.removeAll { $0.date == pairs.date }
        history.append(pairs)
    }
    
    func save() throws {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        encoder.outputFormatting = .prettyPrinted
        try encoder.encode(history).write(to: url)
    }
}

private extension URL {
    static var historyFile: URL {
        #if DEBUG
        let fileName = "history-debug.json"
        #else
        let fileName = "history.json"
        #endif
        
        return .applicationSupportDirectory
            .appending(components: "RandomPairs", fileName)
    }
}
