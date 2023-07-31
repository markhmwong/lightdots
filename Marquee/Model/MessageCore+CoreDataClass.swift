//
//  MessageCore+CoreDataClass.swift
//  LightDots
//
//  Created by Mark Wong on 20/11/2022.
//
//

import Foundation
import CoreData
import UIKit

@objc(MessageCore)
public class MessageCore: NSManagedObject {
    func createMessageCore(message: String, config: MessageConfig) {
        self.message = message
        self.id = UUID()
        self.date = Date()
        self.toMessageConfig = config
    }

    func loadtoLedOptions() {
        guard let toMessageConfig = self.toMessageConfig else { return }
        print(self.message)
        LedOptions.shared.updateMessage(string: self.message ?? "Error")
        LedOptions.shared.updateScrollSpeed(speed: toMessageConfig.scrollSpeed)
        LedOptions.shared.updateFeedback(state: toMessageConfig.feedback)
        LedOptions.shared.updateFont(font: FontList.init(rawValue: Int(toMessageConfig.fontName)) ?? .Arial)
        LedOptions.shared.updateShadow(state: toMessageConfig.textShadow)
        LedOptions.shared.updateShadowType(value: Int(toMessageConfig.textShadowType))
        let shadowColour = UIColor.hexStringToUIColor(hex: toMessageConfig.textShadowColour ?? "#FFFFFF")
        LedOptions.shared.updateShadowColour(hue: shadowColour.hsba.h, brightness: shadowColour.hsba.b)
        LedOptions.shared.updateFontSize(size: Int(toMessageConfig.fontSize))
        LedOptions.shared.updateFontPropertyBold(state: toMessageConfig.fontBold)
        LedOptions.shared.updateFontPropertyItalic(state: toMessageConfig.fontItalic)
        LedOptions.shared.updateFontPropertyUnderline(state: toMessageConfig.fontUnderline)
        LedOptions.shared.updateFontColour(hexColor: toMessageConfig.fontColour ?? "#FFFFFF")
        LedOptions.shared.updateBackgroundColour(hexColor: toMessageConfig.fontColour ?? "#FFFFFF")
        LedOptions.shared.updateIdle(state: toMessageConfig.idle)
        let shimmerBackground = UIColor.hexStringToUIColor(hex: toMessageConfig.shimmerBackground ?? "#FFFFFF")
        LedOptions.shared.updateShimmerBackground(hue: shimmerBackground.hsba.h)
        let shimmerForeground = UIColor.hexStringToUIColor(hex: toMessageConfig.shimmerForeground ?? "#FFFFFF")
        LedOptions.shared.updateShimmerForeground(hue: shimmerForeground.hsba.h, brightness: shimmerForeground.hsba.b)
        LedOptions.shared.updateRainbowNoiseSpeed(toMessageConfig.rainbowSpeed)
        let flashBackground = UIColor.hexStringToUIColor(hex: toMessageConfig.flashBackground ?? "#FFFFFF")
        LedOptions.shared.updateFlashBackground(hue: flashBackground.hsba.h)
        LedOptions.shared.updateFlashSpeed(value: toMessageConfig.flashSpeed)
        LedOptions.shared.updateSelectedBackground(value: BackgroundProperties.init(rawValue: Int(toMessageConfig.selectedBackground)) ?? .solid)
        LedOptions.shared.updateResolution(resolution: Int(toMessageConfig.resolution))
        LedOptions.shared.updateLedShape(shape: LedShape.init(rawValue: Int(toMessageConfig.ledShape)) ?? .square)
    }
}
