import ArgumentParser
import Foundation

extension RandomPairs {
    struct Generate: ParsableCommand {
        static var configuration: CommandConfiguration = .init(
            abstract: "Generates a new set of random pairs weighted by how recently they last paired."
        )
        
        @Option(
            parsing: .upToNextOption,
            help: .init(
                "One or more items to exclude from the generation.",
                discussion: "Useful for when someone will not be available for pairing.",
                valueName: "item..."
            ),
            completion: .custom { _ in (try? Config().items) ?? [] }
        )
        var excluding: [String] = []
        
        @Flag(
            name: .customLong("no-save"),
            help: "Generate pairs without savings the results to the history."
        )
        var skipSaving = false
        
        @OptionGroup
        var globalOptions: GlobalOptions
        
        func run() throws {
            var storage = try GeneratedPairsHistoryStorage()
            
            var items = globalOptions.config.items
            items.removeAll(where: excluding.contains)
            
            let generator = PairsGenerator(
                history: storage.history,
                items: items,
                randomizationWeighting: globalOptions.config.randomizationWeighting
            )
            
            let generatedPairs = generator.next()
            
            print(generatedPairs.formatted(using: globalOptions.config))
            
            if !skipSaving {
                storage.append(generatedPairs)
                try storage.save()
            }
        }
    }
}
