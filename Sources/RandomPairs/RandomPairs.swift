import ArgumentParser
import Foundation

@main
struct RandomPairs: AsyncParsableCommand {
    static var configuration = CommandConfiguration(
        abstract: "Tools for randomly pairing items together.",
        subcommands: [
            Generate.self,
            History.self,
            Participation.self,
            Stats.self
        ]
    )
}

struct GlobalOptions: ParsableArguments {
    @Option(
        name: [.customLong("config"), .customShort("c")],
        help: "The path to the config file to use.",
        completion: .file(extensions: ["json"])
    )
    private var configURL: URL = Config.defaultURL
    
    var config: Config!
    
    mutating func validate() throws {
        config = try .init(url: configURL)
    }
}

extension URL: ExpressibleByArgument {
    public init?(argument: String) {
        self.init(filePath: argument)
    }
    
    public var defaultValueDescription: String {
        self.formatted(.url.scheme(.never))
    }
}
