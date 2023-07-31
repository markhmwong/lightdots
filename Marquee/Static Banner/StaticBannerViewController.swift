//
//  StaticBannerViewController.swift
//  Ledify
//
//  Created by Mark Wong on 2/1/2023.
//

import UIKit
import MetalKit

class StaticBannerViewController: UIViewController {
   
    // for debugging original image
    internal var convertedTextImageView: UIImageView! = nil
    
    internal var tickerView: StaticLedTickerView! = nil
    
    internal var ledGridView: LEDGridView! = nil
    
    override func loadView() {
        super.loadView()
        view.backgroundColor = .background
        
        let paddedString = "太った猫" // actual message

        if let previewImage = UIImage.textToImageConverter(string: paddedString, shadowAttributes: nil) {
            let asciiEngine = AsciiEngine(message: paddedString)
            let borderColour = LedOptions.shared.loadBorderColor()
            let borderWidth = CGFloat(LedOptions.shared.loadBorderWidth())
            let ledShape = LedOptions.shared.loadLedShape()

            let mapping: [[UIColor?]] = asciiEngine.imageToMapping(viewSize: view.bounds.size.applying(CGAffineTransform(scaleX: 0.5, y: 0.5)))
//            self.ledGridView = LEDGridView(frame: view.frame, numRows: 0, numCols: 0, colorMap: mapping)
//            let device = MTLCreateSystemDefaultDevice()
//            let mtkView = StaticMetalView(frame: view.bounds, device: device)
//            mtkView.backgroundColor = UIColor.blue
            self.tickerView = StaticLedTickerView(frame: view.frame, colorMapping: mapping, resolution: LedOptions.shared.loadResolution(), ledShape: ledShape, borderWidth: borderWidth, borderColour: borderColour, orientation: .landscape)
            let radians: CGFloat = CGFloat(atan2f(Float(tickerView.transform.b), Float(tickerView.transform.a)));
            let degrees: CGFloat = radians * (90 / Double.pi);
            let transform = CGAffineTransformMakeRotation((270 + degrees) * Double.pi/180)
            self.view.transform = transform
//            self.view.addSubview(mtkView)
            self.view.addSubview(self.tickerView)
//            self.view.addSubview(self.ledGridView)
            debuggingImage(previewImage: previewImage)
        }

    }
    
    func debuggingImage(previewImage: UIImage) {
        //debugging
        convertedTextImageView = UIImageView(image: UIImage(cgImage: (previewImage.cgImage)!))
        convertedTextImageView.translatesAutoresizingMaskIntoConstraints = false
        convertedTextImageView.isHidden = false
        
        self.view.addSubview(convertedTextImageView)
        
        convertedTextImageView.topAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        convertedTextImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
    }
}

class StaticBannerViewModel: NSObject {
    
    private var cds: CoreDataStack
    
    init(cds: CoreDataStack) {
        self.cds = cds
        super.init()
    }
}
