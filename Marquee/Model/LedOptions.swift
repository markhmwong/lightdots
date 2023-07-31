//
//  KC.swift
//  Marquee
//
//  Created by Mark Wong on 3/10/2022.
//

import KeychainSwift
import UIKit

// most if not all the temporary
class LedOptions: NSObject {

    private let hasMigrated: String = "hasMigrated"
    
    enum OptionKey: String, CaseIterable {
        // the text to be displayed
        case message
        case scrollSpeed
        
        case feedback
        case textShadow
        case fontShadowColour
        case textShadowType
        
        case fontName
        case fontSize
        case fontBold
        case fontItalic
        case fontUnderline
        
        case fontColour
        case backgroundColor
        case backgroundType // not used 20/11/2022
        
        case shimmerBackground
        case shimmerForeground
        
        case rainbowSpeed
        
        case flashBackground
        case flashSpeed
        
        case selectedBackground
        
        case resolution
        case ledShape
        
        case idle
        
        case borderWidth
        case borderColor
    }
    
    private let subscriptionService = SubscriptionService.shared
    
    static var shared: LedOptions = LedOptions()
    
    private let keychain = KeychainSwift()
    
    private let standard = UserDefaults.standard
    
    // initalise all keys
    func initialiseDeftaulsForAllKeys() {

        if standard.value(forKey: OptionKey.feedback.rawValue) == nil {
            for key in OptionKey.allCases {
                switch key {
                case .message:
                    standard.set("Awesome text message", forKey: key.rawValue)
                case .fontShadowColour:
                    let color = UIColor.init(hue: 0.5, saturation: 0.0, brightness: 1.0, alpha: 1.0)
                    standard.set(color.hexStringFromColor(), forKey: OptionKey.fontShadowColour.rawValue)
                case .scrollSpeed:
                    standard.set(30.0, forKey: key.rawValue)
                case .feedback:
                    standard.set(false, forKey: key.rawValue)
                case .fontName:
                    standard.set(FontList.Futura.rawValue, forKey: key.rawValue)
                case .textShadow:
                    standard.set(false, forKey: OptionKey.textShadow.rawValue)
                case .textShadowType:
                    standard.set(TextShadow.off.rawValue, forKey: key.rawValue)
                case .fontSize:
                    standard.set(TextSize.mango.rawValue, forKey: key.rawValue)
                case .fontBold:
                    standard.set(false, forKey: key.rawValue)
                case .fontItalic:
                    standard.set(false, forKey: key.rawValue)
                case .fontUnderline:
                    standard.set(false, forKey: key.rawValue)
                case .fontColour:
                    let color = UIColor(red: 0, green: 0, blue: 0, alpha: 1.0)
                    standard.set(color.hexStringFromColor(), forKey: key.rawValue)
                case .backgroundColor:
                    let color = UIColor(red: 1, green: 1, blue: 1, alpha: 1.0)
                    standard.set(color.hexStringFromColor(), forKey: key.rawValue)
                case .backgroundType:
                    ()//??
                case .shimmerBackground:
                    let color = UIColor.init(hue: 0.6, saturation: 1.0, brightness: 1.0, alpha: 1.0)
                    standard.set(color.hexStringFromColor(), forKey: key.rawValue)

                case .shimmerForeground:
                    let color = UIColor.init(hue: 0.8, saturation: 1.0, brightness: 1.0, alpha: 1.0)
                    standard.set(color.hexStringFromColor(), forKey: key.rawValue)
                case .flashBackground:
                    let color = UIColor.systemYellow
                    standard.set(color.hexStringFromColor(), forKey: key.rawValue)
                case .flashSpeed:
                    standard.set(0.3, forKey: key.rawValue)
                case .selectedBackground:
                    let color = UIColor.init(hue: 0.4, saturation: 1.0, brightness: 1.0, alpha: 1.0)
                    standard.set(color.hexStringFromColor(), forKey: key.rawValue)
                case .resolution:
                    standard.set(Resolution.sd.rawValue, forKey: key.rawValue)
                case .ledShape:
                    standard.set(LedShape.square.rawValue, forKey: key.rawValue)
                case .rainbowSpeed:
                    standard.set(0.3, forKey: key.rawValue)
                case .idle:
                    standard.set(false, forKey: key.rawValue)
                case .borderWidth:
                    standard.set(0.3, forKey: key.rawValue)
                case .borderColor:
                    let color = UIColor.init(hue: 1.0, saturation: 1.0, brightness: 0.1, alpha: 1.0)
                    standard.set(color.hexStringFromColor(), forKey: key.rawValue)
                }
            }
        }
    }
    
    /*
     
     MARK: Rainbow Speed
     */
    func loadRainbowNoiseSpeed() -> Float {
        if subscriptionService.proStatus() {
            return standard.float(forKey: OptionKey.rainbowSpeed.rawValue)
        } else {
            return 0
        }
    }
    
    func updateRainbowNoiseSpeed(_ value: Float) {
        standard.set(value, forKey: OptionKey.rainbowSpeed.rawValue)
    }
    
    /*
     
     MARK: LED Shape
     
     */
    func loadLedShape() -> LedShape {
        if subscriptionService.proStatus() {
            let v = standard.integer(forKey: OptionKey.ledShape.rawValue)
            return LedShape.init(rawValue: v) ?? .square
        } else {
            return .square
        }

    }
    
    func updateLedShape(shape: LedShape) {
        standard.set(shape.rawValue, forKey: OptionKey.ledShape.rawValue)
    }
    
    
    /*
     MARK: Background
     hex string
    */
    func updateSelectedBackground(value: BackgroundProperties) {
        standard.set(value.rawValue, forKey: OptionKey.selectedBackground.rawValue)
    }
    
    func loadSelectedBackground() -> BackgroundProperties {
        let v = standard.integer(forKey: OptionKey.selectedBackground.rawValue)
        return BackgroundProperties.init(rawValue: v) ?? .solid
    }
    
    func loadShimmerForeground() -> UIColor {
        if subscriptionService.proStatus() {
            let hex = standard.string(forKey: OptionKey.shimmerForeground.rawValue) ?? "#FFFFFF"
            return UIColor.hexStringToUIColor(hex: hex)
        } else {
            return UIColor.white
        }
    }
    
    func updateShimmerForeground(hue: CGFloat, brightness: CGFloat) {
        let color = UIColor.init(hue: hue, saturation: 1.0, brightness: brightness, alpha: 1.0)
        standard.set(color.hexStringFromColor(), forKey: OptionKey.shimmerForeground.rawValue)
    }
    
    func loadShimmerBackground() -> UIColor {
        let hex = standard.string(forKey: OptionKey.shimmerBackground.rawValue) ?? "#FFFFFF"
        return UIColor.hexStringToUIColor(hex: hex)
    }
    
    func updateShimmerBackground(hue: CGFloat) {
        let color = UIColor.init(hue: hue, saturation: 1.0, brightness: 1.0, alpha: 1.0)
        standard.set(color.hexStringFromColor(), forKey: OptionKey.shimmerBackground.rawValue)
    }
    
    func updateFlashBackground(hue: CGFloat) {
        let color = UIColor.init(hue: hue, saturation: 1.0, brightness: 1.0, alpha: 1.0)
        standard.set(color.hexStringFromColor(), forKey: OptionKey.flashBackground.rawValue)
    }
    
    func loadFlashBackground() -> String {
        if subscriptionService.proStatus() {
            return standard.string(forKey: OptionKey.flashBackground.rawValue) ?? "#FFFFFF"
        } else {
            return "#FFFFFF"
        }
    }
    
    func loadFlashSpeed() -> Float {
        if subscriptionService.proStatus() {
            return standard.float(forKey: OptionKey.flashSpeed.rawValue)
        } else {
            return 10
        }
    }
    
    func updateFlashSpeed(value: Float) {
        standard.set(value, forKey: OptionKey.flashSpeed.rawValue)
    }
    
    /*
     
     MARK: Text Options
     
     */
    
    func updateScrollSpeed(speed: Float) {
        standard.set(speed, forKey: OptionKey.scrollSpeed.rawValue)
    }
    
    func loadScrollSpeed() -> Float {
        return standard.float(forKey: OptionKey.scrollSpeed.rawValue)
    }
    
    // used on startup
    func loadMessage() -> String {
        if let message = standard.string(forKey: OptionKey.message.rawValue) {
            return message
        } else {
            return "Add Text"
        }
    }
    
    func updateMessage(string: String) {
        standard.set(string, forKey: OptionKey.message.rawValue)
    }
    
    /*
     
     MARK: Font Properties
     */
    func loadFont() -> FontList {
        let fontNumber = standard.integer(forKey: OptionKey.fontName.rawValue)
        return FontList.init(rawValue: fontNumber) ?? .Helvetica
    }

    func updateFont(font: FontList) {
        standard.set(font.rawValue, forKey: OptionKey.fontName.rawValue)
    }
    
    func updateFontPropertyBold(state: Bool) {
        standard.set(state, forKey: OptionKey.fontBold.rawValue)
    }
    
    func updateFontPropertyUnderline(state: Bool) {
        standard.set(state, forKey: OptionKey.fontUnderline.rawValue)
    }
    
    func updateFontPropertyItalic(state: Bool) {
        standard.set(state, forKey: OptionKey.fontItalic.rawValue)
    }

    func loadItalic() -> Bool {
        return standard.bool(forKey: OptionKey.fontItalic.rawValue)
    }
    
    func loadBold() -> Bool {
        return standard.bool(forKey: OptionKey.fontBold.rawValue)
    }
    
    func loadUnderline() -> Bool {
        return standard.bool(forKey: OptionKey.fontUnderline.rawValue)
    }
    
    func updateResolution(resolution: Int) {
        standard.set(resolution, forKey: OptionKey.resolution.rawValue)
    }
    
    func loadResolution() -> Resolution {
        if subscriptionService.proStatus() {
            let r = standard.integer(forKey: OptionKey.resolution.rawValue)
            return Resolution.init(rawValue: r) ?? .sd
        } else {
            return .sd
        }

    }
    
    /*
     
     MARK: Shadow
     
     */
    func loadShadowColour() -> UIColor {
        let hexColour = standard.value(forKey: OptionKey.fontShadowColour.rawValue) as? String ?? "#000000"
        return UIColor.hexStringToUIColor(hex: hexColour)
    }
    
    func updateShadowColour(hue: CGFloat, brightness: CGFloat) {
        // save as hex
        let color = UIColor.init(hue: hue, saturation: 1.0, brightness: brightness, alpha: 1.0)
        standard.set(color.hexStringFromColor(), forKey: OptionKey.fontShadowColour.rawValue)
    }
    
    func loadShadow() -> Bool {
        let shadow = standard.value(forKey: OptionKey.textShadow.rawValue) as? Bool ?? false
        return shadow
    }
    
    func updateShadow(state: Bool) {
        standard.set(state, forKey: OptionKey.textShadow.rawValue)
    }
    
    func loadShadowType() -> TextShadow {
        let ts = standard.value(forKey: OptionKey.textShadowType.rawValue) as? Int ?? 0
        return TextShadow(rawValue: ts) ?? .off
    }
    
    func updateShadowType(value: Int) {
        standard.set(value, forKey: OptionKey.textShadowType.rawValue)
    }
    
    
    func loadFontSize() -> Int {
        return standard.value(forKey: OptionKey.fontSize.rawValue) as? Int ?? 0
    }
    
    func updateFontSize(size: Int) {
        standard.set(size, forKey: OptionKey.fontSize.rawValue)
    }
    
    func loadFontColour() -> UIColor {
        let hexColour = standard.value(forKey: OptionKey.fontColour.rawValue) as? String ?? "#000000"
        return UIColor.hexStringToUIColor(hex: hexColour)
    }
    
    func updateFontColour(hexColor: String) {
        // save as hex
        standard.set(hexColor, forKey: OptionKey.fontColour.rawValue)
    }
    
    func updateBackgroundColour(hexColor: String) {
        standard.set(hexColor, forKey: OptionKey.backgroundColor.rawValue)
    }
    
    // return hex string
    func loadSolidBackgroundColour() -> String {
        return standard.value(forKey: OptionKey.backgroundColor.rawValue) as? String ?? "#FFFFFF"
    }
    
    func updateScrollSpeed(speed: String) {
        standard.set(speed, forKey: OptionKey.scrollSpeed.rawValue)
    }
    
//    func updateBackgroundType(type: String) {
//        standard.set(type, forKey: OptionKeys.backgroundType.rawValue)
//    }
    
    /*
     Feedback
     */
    func loadFeedback() -> Bool {
        return standard.value(forKey: OptionKey.feedback.rawValue) as? Bool ?? false
    }
    
    func updateFeedback(state: Bool) {
        standard.set(state, forKey: OptionKey.feedback.rawValue)
    }
    
    func loadIdleTime() -> Bool {
        if let idle = standard.value(forKey: OptionKey.idle.rawValue) as? Bool {
            return idle
        } else {
            self.updateIdle(state: false)
            return false
        }
    }
    
    func updateIdle(state: Bool) {
        standard.set(state, forKey: OptionKey.idle.rawValue)
    }
    
    func loadBorderWidth() -> Float {
        if let value = standard.value(forKey: OptionKey.borderWidth.rawValue) as? Float {
            return value
        } else {
            return 0.3
        }
    }
    
    func updateBorderWidth(value: Float) {
        standard.set(value, forKey: OptionKey.borderWidth.rawValue)
    }
    
    func loadBorderColor() -> UIColor {
        let hex = standard.value(forKey: OptionKey.borderColor.rawValue) as? String ?? "#000000"
        return UIColor.hexStringToUIColor(hex: hex)
    }
    
    func updateBorderColour(hue: CGFloat, brightness: CGFloat) {
        // save as hex
        let color = UIColor.init(hue: hue, saturation: 1.0, brightness: brightness, alpha: 1.0)
        standard.set(color.hexStringFromColor(), forKey: OptionKey.borderColor.rawValue)
    }
}
