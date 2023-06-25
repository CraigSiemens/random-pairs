import ArgumentParser
import Foundation

extension RandomPairs {
    struct Participation: ParsableCommand {
        static var configuration: CommandConfiguration = .init(
            abstract: "Track pair participation for the previously generated set of pairs.",
            discussion: """
            Can be called multiple times to modify the previously entered values.
            
            For each pair it reads either 'y' or 'n' followed by enter to indicate whether they
            paired. Pressing just enter will use the default value, indicated by the capital letter
            in the prompt.
            """
        )
        
        @OptionGroup
        var globalOptions: GlobalOptions
        
        func run() throws {
            var storage = try GeneratedPairsHistoryStorage()
            
            guard var last = storage.history.last else { return }
            
            print("Did the following pairs participate?")
            
            for index in last.pairs.indices {
                
                var pair = last.pairs[index]
                defer { last.pairs[index] = pair }
                
                guard let item2 = globalOptions.config.item2Name(for: pair.item2)
                else { continue }
                
                let defaultParticipation: Pair.Participation
                let prompt: String
                
                switch pair.participation {
                case .yes:
                    defaultParticipation = .yes
                    prompt = "(Y/n)"
                case .no:
                    defaultParticipation = .no
                    prompt = "(y/N)"
                case .unknown:
                    defaultParticipation = .yes
                    prompt = "(Y/n)"
                }
                
                print("\(pair.item1) and \(item2)? \(prompt)")
                
                repeat {
                    switch readLine() {
                    case "y":
                        pair.participation = .yes
                    case "n":
                        pair.participation = .no
                    case "":
                        pair.participation = defaultParticipation
                    default:
                        print("Unknown input.")
                    }
                } while pair.participation == .unknown
            }
            
            storage.append(last)
            try storage.save()
        }
    }
}
