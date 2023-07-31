//
//  Replay.swift
//  Marquee
//
//  Created by Mark Wong on 13/11/2022.
//

import Foundation

// Exports the generated image
class Exporter: NSObject {
    
    // https://bradgayman.com/blog/recordingAView/
    // use UIGraphicsImageRenderer
    
    private let message: String
    
    init(message: String) {
        self.message = message
        super.init()
    }
    
    
}
