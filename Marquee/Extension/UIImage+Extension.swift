//
//  UIImage+Extension.swift
//  Marquee
//
//  Created by Mark Wong on 4/8/2022.
//

import UIKit

extension UIImage {

    static func textToImageConverter(
        string: String = "",
        fontAttributes: [NSAttributedString.Key : Any] = [
        NSAttributedString.Key.foregroundColor: UIColor.black,
        NSAttributedString.Key.font: UIFont(name: "Arial", size: 8)!.with(weight: .bold)
    ],
        shadowAttributes: [NSAttributedString.Key : Any]? = [
        NSAttributedString.Key.foregroundColor: UIColor.black,
        NSAttributedString.Key.font: UIFont(name: "Arial", size: 2)!.with(weight: .bold)
    ] ) -> UIImage? {
        let textSize = string.size(withAttributes: fontAttributes)
        //1
        // not entirely sure how the + 2 works. but it gives it enough canvas to draw the whole text.
        UIGraphicsBeginImageContextWithOptions(CGSize.init(width: textSize.width, height: textSize.height + 2), false, 0)
        // y = 3 fixes emoji clipping, nfi idea why
        let textOrigin = CGPoint(x: 0, y: 1.0)
        
        // shadow - must be declared first to be placed behind text
        if shadowAttributes != nil {
            let shadowOrigin = CGPoint(x: textOrigin.x + 0.3, y: textOrigin.y + 0.5)
            string.draw(at: shadowOrigin, withAttributes: shadowAttributes)
        }
        // actual text
        string.draw(at: textOrigin, withAttributes: fontAttributes)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        return image
    }
    
    class func labelToImage(_ label: UILabel, handler: (UIImage?) -> ()) {
        let size = label.frame.size.applying(.init(scaleX: 1, y: 1))
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        label.frame.size = size
        label.font = label.font.withSize(label.font.pointSize * 1)
        defer { UIGraphicsEndImageContext() }
        label.draw(.init(origin: .zero, size: size))
        handler(UIGraphicsGetImageFromCurrentImageContext())
    }
}

extension CGImage {
    func colors(at: [CGPoint]) -> [UIColor]? {
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let bytesPerPixel = 4
        let bytesPerRow = bytesPerPixel * width
        let bitsPerComponent = 8
        let bitmapInfo: UInt32 = CGImageAlphaInfo.premultipliedLast.rawValue | CGBitmapInfo.byteOrder32Big.rawValue
    
        guard let context = CGContext(data: nil, width: width, height: height, bitsPerComponent: bitsPerComponent, bytesPerRow: bytesPerRow, space: colorSpace, bitmapInfo: bitmapInfo),
            let ptr = context.data?.assumingMemoryBound(to: UInt8.self) else {
            return nil
        }
    
        context.draw(self, in: CGRect(x: 0, y: 0, width: width, height: height))
    
        return at.map { p in
            let i = bytesPerRow * Int(p.y) + bytesPerPixel * Int(p.x)
            
            let a = CGFloat(ptr[i + 3]) / 255.0
            let r = (CGFloat(ptr[i]) / a) / 255.0
            let g = (CGFloat(ptr[i + 1]) / a) / 255.0
            let b = (CGFloat(ptr[i + 2]) / a) / 255.0
            
            return UIColor(red: r, green: g, blue: b, alpha: a)
        }
    }
}
