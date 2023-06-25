import ArgumentParser
import Foundation

struct Config: Codable, Hashable {
    var items: [String] = []
    
    var randomizationWeighting: RandomizationWeighting = .exponential
    var oddItemAppearance: OddItemAppearance = .hidden
    
    init(url: URL = Self.defaultURL) throws {
        if FileManager.default.fileExists(atPath: url.path) {
            let data = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            self = try decoder.decode(Self.self, from: data)
        } else {
            let encoder = JSONEncoder()
            encoder.outputFormatting = .prettyPrinted
            let data = try encoder.encode(self)
            try data.write(to: url)
        }
    }
    
    func item2Name(for item2: String?) -> String? {
        if let item2 {
            return item2
        }
        
        switch oddItemAppearance {
        case .hidden:
            return nil
        case let .shown(name):
            return name
        }
    }
}

extension Config {
    enum RandomizationWeighting: String, Codable, Hashable {
        case exponential
        case linear
        case uniform
    }
    
    enum OddItemAppearance: Codable, Hashable {
        case hidden
        case shown(name: String)
    }
}

extension Config {
    static var defaultURL: URL {
        #if DEBUG
        let fileName = "config-debug.json"
        #else
        let fileName = "config.json"
        #endif
        
        return .applicationSupportDirectory
            .appending(components: "RandomPairs", fileName)
    }
}
