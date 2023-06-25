import ArgumentParser
import Foundation

extension RandomPairs {
    struct History: ParsableCommand {
        static var configuration: CommandConfiguration = .init(
            abstract: "Shows the previously generated set of pairs."
        )
        
        @Flag(
            help: "Shows the path to the file containing the history."
        )
        var showPath: Bool = false
        
        @OptionGroup
        var globalOptions: GlobalOptions
        
        func run() throws {
            let storage = try GeneratedPairsHistoryStorage()
            
            if showPath {
                print(storage.url.path(percentEncoded: false))
            } else {
                guard let last = storage.history.last else { return }
                print(last.formatted(using: globalOptions.config))
            }
        }
    }
}
