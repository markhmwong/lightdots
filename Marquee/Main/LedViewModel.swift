//
//  LedViewModel.swift
//  Marquee
//
//  Created by Mark Wong on 3/10/2022.
//

import UIKit

class LedViewModel: NSObject {
    
    var hideDebuggingImage: Bool = true
    
    private var cds: CoreDataStack
    
    var overlayState: OverlayState = .off
    
    enum OverlayState: Int {
        case on
        case off
    }
    
    var asciiEngine: AsciiEngine? = nil
    
    init(cds: CoreDataStack) {
        self.cds = cds
        super.init()
    }
    
    func overlayToggle(view: UIView) {
        
        switch overlayState {
        case .off:
            self.overlayState = .on
            UIView.animate(withDuration: 1.2, delay: 0.0, usingSpringWithDamping: 0.9, initialSpringVelocity: 0.1, options: [.curveEaseInOut, .allowUserInteraction]) {
                view.alpha = 0.6
            } completion: { state in
                UIView.animate(withDuration: 0.7, delay: 2.2, usingSpringWithDamping: 0.9, initialSpringVelocity: 0.1, options: [.curveEaseInOut, .allowUserInteraction]) {
                    view.alpha = 0.0
                } completion: { finished in
                    if finished {
                        self.overlayState = .off
                    }
                }
            }            
        case .on:
            view.layer.removeAllAnimations()
            UIView.animate(withDuration: 0.7, delay: 0.0, usingSpringWithDamping: 0.9, initialSpringVelocity: 0.1, options: [.curveEaseInOut, .allowUserInteraction]) {
                view.alpha = 0.0
                
            } completion: { finished in
                self.overlayState = .off
            }
        }
    }
    
    func loadTextFormatting() -> [NSAttributedString.Key : Any] {
        let fontSize = TextSize.init(rawValue: LedOptions.shared.loadFontSize())!.fontSize(resolution: LedOptions.shared.loadResolution())

        var font = UIFont(name: LedOptions.shared.loadFont().name, size: fontSize)

        // BOLD
        if LedOptions.shared.loadBold() {
            font = font!.with(.traitBold)
        } else {
            font = font!.without(.traitBold)
        }
        
        // ITALIC
        if LedOptions.shared.loadItalic() {
            font = font!.with(.traitItalic)
        } else {
            font = font!.without(.traitItalic)
        }
        
        var attributedText: [NSAttributedString.Key : Any] = [:]
        // UNDERLINE
        if LedOptions.shared.loadUnderline() {
            attributedText[NSAttributedString.Key.underlineStyle] = NSUnderlineStyle.single.rawValue
        }
        
        let foregroundColour = LedOptions.shared.loadFontColour()
        attributedText[NSAttributedString.Key.foregroundColor] = foregroundColour
        attributedText[NSAttributedString.Key.font] = font

        return attributedText
    }
    
    func loadShadowFormatting() -> [NSAttributedString.Key : Any] {
        let fontSize = TextSize.init(rawValue: LedOptions.shared.loadFontSize())!.fontSize(resolution: LedOptions.shared.loadResolution())

        var font = UIFont(name: LedOptions.shared.loadFont().name, size: fontSize)

        // BOLD
        if LedOptions.shared.loadBold() {
            font = font!.with(.traitBold)
        } else {
            font = font!.without(.traitBold)
        }
        
        // ITALIC
        if LedOptions.shared.loadItalic() {
            font = font!.with(.traitItalic)
        } else {
            font = font!.without(.traitItalic)
        }
        
        var attributedText: [NSAttributedString.Key : Any] = [:]
        // UNDERLINE
        if LedOptions.shared.loadUnderline() {
            attributedText[NSAttributedString.Key.underlineStyle] = NSUnderlineStyle.single.rawValue
        }
        
        let foregroundColour = LedOptions.shared.loadShadowColour()
        attributedText[NSAttributedString.Key.foregroundColor] = foregroundColour
        attributedText[NSAttributedString.Key.font] = font
        
        return attributedText
    }
    
    func loadAndPadString() -> String {
        let string = LedOptions.shared.loadMessage()
        return "     \(string)" + "          "
    }
}
