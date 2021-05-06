//
//  File.swift
//  
//
//  Created by Palmer, Ben EX1 on 5/5/21.
//

import Foundation
import SwiftCLI
import Files
import ShellOut
import Rainbow

class WatchCommand: Command {

    let name = "watch"
    let shortDescription = "Watches a file tree for changes and then invokes `publish`."
    
    @Param(completion: .filename)
    var folder: String
    
    @Flag("-v", "--verbose")
    var flag: Bool
    

    func execute() throws {
        setupSigInt()
        publish()
        
        do {
            let watchFolder = try Folder(path: folder)
            stdout <<< "--- Watching \(watchFolder.path).".lightBlue
            watch(folder: watchFolder)
        } catch {
            stderr <<< error.localizedDescription;
            exit(EXIT_FAILURE)
        }
        
        dispatchMain()
    }
    
    private var watchTask: Task?
    private var publishTask: Task?
    
    private func watch(folder: Folder) {
        let output = PipeStream()
        watchTask = Task(executable: "/usr/local/bin/fswatch", arguments: ["-x", folder.path], directory: Folder.current.path, stdout: output)
        watchTask?.runAsync()
        output.readHandle.readabilityHandler = { [weak self] handle in
            guard !handle.availableData.isEmpty else { return }
            DispatchQueue.main.async {
                if let output = String(data: handle.availableData, encoding: .ascii)?.yellow {
                    self?.stdout <<< output
                } else {
                    self?.stderr <<< "Could not resolve fswatch output as ascii string data".red
                }
                self?.publish()
            }
        }
    }
    private func publish() {
        publishTask?.interrupt()
        publishTask = Task(executable: "publish", arguments: ["run"], directory: Folder.current.path)
        publishTask?.runAsync()
    }
    
    
    private func stop() {
        stdout <<< "--- Stopping fswatch.".yellow
        watchTask?.interrupt()
        publishTask?.interrupt()
    }
    
    private func setupSigInt() {
        signal(SIGINT, SIG_IGN)
        let sigintSrc = DispatchSource.makeSignalSource(signal: SIGINT, queue: .main)
        sigintSrc.setEventHandler { [weak self] in
            self?.stop()
            exit(0)
        }
        sigintSrc.resume()
    }
}
