import Foundation

struct Pair: Codable {
    let item1: String
    
    /// Can be nil when there is an odd number of items available for pairing. Is shown depending
    /// on Config.oddItemAppearance.
    let item2: String?
    
    var participation: Participation = .unknown
}

extension Pair {
    enum Participation: String, Codable {
        case yes
        case no
        case unknown
    }
}
