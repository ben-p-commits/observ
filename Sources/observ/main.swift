import Foundation
import SwiftCLI

let cli = CLI(
    name: "observ",
    version: "0.1.0",
    description: "observ - file watching + script invocation helper"
)

cli.commands = [WatchCommand()]
cli.go()
