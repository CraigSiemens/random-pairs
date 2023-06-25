import ArgumentParser
import Foundation

extension RandomPairs {
    struct Stats: ParsableCommand {
        static var configuration: CommandConfiguration = .init(
            abstract: "Show stats for the previously generated sets of pairs."
        )
        
        @OptionGroup
        var globalOptions: GlobalOptions
        
        func run() throws {
            let storage = try GeneratedPairsHistoryStorage()
            
            var stats: [String: [String: Int]] = [:]
            
            for week in storage.history {
                for pair in week.pairs where pair.participation == .yes {
                    if let item2 = globalOptions.config.item2Name(for: pair.item2) {
                        stats[pair.item1, default: [:]][item2, default: 0] += 1
                        stats[item2, default: [:]][pair.item1, default: 0] += 1
                    }
                }
            }
            
            for (item1, stats) in stats.sorted(by: { $0.key < $1.key }) {
                print(item1)
                for (item2, count) in stats.sorted(by: { $0.value > $1.value }) {
                    print("  -", count, item2)
                }
            }
        }
    }
}
