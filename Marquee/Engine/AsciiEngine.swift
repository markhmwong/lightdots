//
//  AsciiEngine.swift
//  Marquee
//
//  Created by Mark Wong on 29/9/2022.
//

import UIKit
import MetalKit

class AsciiEngine: NSObject {

    private let textToConvert: String
    
    private let fontAttributes: [NSAttributedString.Key : Any]
    
    private let shadowAttributes: [NSAttributedString.Key : Any]?

    // font size - don't use more than 10
    init(
        message: String = "",
        fontAttributes: [NSAttributedString.Key : Any] = [
            NSAttributedString.Key.foregroundColor: UIColor.black,
            NSAttributedString.Key.backgroundColor: UIColor.clear,
            NSAttributedString.Key.font: UIFont(name: "Arial", size: 5)!.with(weight: .bold)
        ],
        shadowAttributes: [NSAttributedString.Key : Any]? = [
            NSAttributedString.Key.foregroundColor: UIColor.clear,
            NSAttributedString.Key.backgroundColor: UIColor.clear,
            NSAttributedString.Key.font: UIFont(name: "Arial", size: 5)!.with(weight: .bold)
        ]
    ) {
        self.textToConvert = message
        self.fontAttributes = fontAttributes
        self.shadowAttributes = shadowAttributes
        super.init()
    }
    
    // creates 2D Mapping of what coordinates to highlight
    func imageToMapping(viewSize: CGSize) -> [[UIColor?]] {
        
        let startTime = measureTime()
        
        if let oImage = UIImage.textToImageConverter(string: self.textToConvert, fontAttributes: self.fontAttributes, shadowAttributes: self.shadowAttributes) {
            let inputImage = oImage.imageConstrainedToMaxSize(viewSize)
            
            guard let cgImage = inputImage.cgImage,
                let data = cgImage.dataProvider?.data,
                let pixelPointer = CFDataGetBytePtr(data) else {
                fatalError("Couldn't access image data")
            }
            
            let bytesPerRow = cgImage.bytesPerRow
            let bytesPerPixel = cgImage.bitsPerPixel / 8
            var ledGrid = [[UIColor?]](repeating: [UIColor?](repeating: nil, count: Int(cgImage.width)), count: Int(cgImage.height))
            

            for indexY in 0..<cgImage.height {
                for indexX in 0..<cgImage.width {
                    let offset = (indexY * bytesPerRow) + (indexX * bytesPerPixel)
                    let components = (r: pixelPointer[offset], g: pixelPointer[offset + 1], b: pixelPointer[offset + 2], a: pixelPointer[offset + 3])
                    
                    let r = CGFloat(components.b) / CGFloat(255.0)
                    let g = CGFloat(components.g) / CGFloat(255.0)
                    let b = CGFloat(components.r) / CGFloat(255.0)
                    let a = CGFloat(components.a) / CGFloat(255.0)
                    
                    // bgr so i've swapped the r and b from the components below
                    ledGrid[indexY][indexX] = UIColor(red: r, green: g, blue: b, alpha: a)
                }
            }
            
            let cleanGrid = self.cleanUpPass(grid: ledGrid)

            return cleanGrid
        } else {
            fatalError("Image could be converted")
        }
        
        let timeElapsed = (measureTime() ?? 0) - (startTime ?? 0)
        print("Time elapsed CPU Method \(String(format: "%.05f", timeElapsed)) seconds")
    }
    
    func cleanUpPass(grid: [[UIColor?]]) -> [[UIColor?]] {
        var tempGrid = grid
        for indexY in 0..<grid.count {

            let reducedSet = grid[indexY].reduce(into: Set<String>()) { partialResult, obj in
                let hex = obj?.hexStringFromColor()
                partialResult.insert(hex ?? "")
            }

            // remove excess areas from the top and bottom of the mapping once more than one color is detected
//            print("adjustment might only be needed for standard definition")
            if (reducedSet.count >= 1) {
//                print("clean up to be fine tuned")
                let fineTune = 2
                tempGrid.removeFirst(indexY + fineTune)
                tempGrid.removeLast(indexY + fineTune)
                return tempGrid
            }
        }
        return tempGrid
    }
    
    //MARK: - GPU
    func initialiseGPU() {
        let gpu = GpuRenderer()
        
    }
    
    func measureTime() -> CFAbsoluteTime? {
        #if DEBUG
        return CFAbsoluteTimeGetCurrent()
        #else
        return nil
        #endif
    }
}
