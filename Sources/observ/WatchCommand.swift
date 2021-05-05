//
//  File.swift
//  
//
//  Created by Palmer, Ben EX1 on 5/5/21.
//

import Foundation
import SwiftCLI
import Files

class WatchCommand: Command {

    let name = "watch"
    let shortDescription = "Watches a file tree for changes, and invokes"
    
    @Param(completion: .filename)
    var watchFile: String
    
    @Param(completion: .filename)
    var scriptFile: String
    
    @Flag("-v", "--verbose")
    var flag: Bool

    func execute() throws {
        stdout <<< "Watching \(watchFile)... will invoke \(scriptFile)"
    }
}
