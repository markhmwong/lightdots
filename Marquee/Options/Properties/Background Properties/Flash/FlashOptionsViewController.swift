//
//  FlashOptionsViewController.swift
//  Marquee
//
//  Created by Mark Wong on 16/10/2022.
//

import UIKit

class FlashOptionsViewController: UIViewController {
    
    private lazy var previewLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Alternates between white a a choice of your colour and speed"
        label.alpha = 0.5
        label.font = UIFont.preferredFont(forTextStyle: .caption2).with(weight: .bold)
        return label
    }()
    
    private lazy var backgroundLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Background Colour"
        label.font = UIFont.preferredFont(forTextStyle: .body).with(weight: .bold)
        return label
    }()
    
    private lazy var foregroundLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Flash Speed"
        label.font = UIFont.preferredFont(forTextStyle: .body).with(weight: .bold)
        return label
    }()
    
    
    
    private lazy var flashSpeedSlider: UISlider = {
        let slider = UISlider(frame: .zero)
        slider.translatesAutoresizingMaskIntoConstraints = false
        slider.minimumValue = 0
        slider.maximumValue = 5
        slider.isContinuous = true
        slider.addTarget(self, action: #selector(flashSpeedDidChange), for: .valueChanged)
        return slider
    }()
    
    private lazy var backgroundColourSlider: UISlider = {
        let slider = UISlider(frame: .zero)
        slider.translatesAutoresizingMaskIntoConstraints = false
        slider.minimumValue = 0
        slider.maximumValue = 1
        slider.isContinuous = true
        slider.addTarget(self, action: #selector(backgroundDidChange), for: .valueChanged)
        return slider
    }()
    
    private lazy var previewBox: PreviewBox = {
        let view = PreviewBox(frame: self.view.bounds, type: .flash)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    
    override func loadView() {
        super.loadView()
        view.backgroundColor = .background
        title = "Flash"
        self.initSliderValues()
        
        self.view.addSubview(flashSpeedSlider)
        self.view.addSubview(backgroundColourSlider)
        self.view.addSubview(backgroundLabel)
        self.view.addSubview(foregroundLabel)
        self.view.addSubview(previewBox)
        self.view.addSubview(previewLabel)
        
        previewLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        previewLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        let lateralPadding = 25.0
        foregroundLabel.topAnchor.constraint(equalTo: previewBox.bottomAnchor, constant: 20.0).isActive = true
        foregroundLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: lateralPadding).isActive = true
        foregroundLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -lateralPadding).isActive = true
        
        flashSpeedSlider.topAnchor.constraint(equalTo: foregroundLabel.bottomAnchor, constant: 10).isActive = true
        flashSpeedSlider.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: lateralPadding).isActive = true
        flashSpeedSlider.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -lateralPadding).isActive = true
        
        backgroundLabel.topAnchor.constraint(equalTo: flashSpeedSlider.bottomAnchor, constant: 25).isActive = true
        backgroundLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: lateralPadding).isActive = true
        backgroundLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -lateralPadding).isActive = true
        
        backgroundColourSlider.topAnchor.constraint(equalTo: backgroundLabel.bottomAnchor, constant: 10).isActive = true
        backgroundColourSlider.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: lateralPadding).isActive = true
        backgroundColourSlider.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -lateralPadding).isActive = true
        
        previewBox.topAnchor.constraint(equalTo: self.previewLabel.safeAreaLayoutGuide.bottomAnchor, constant: 10).isActive = true
        previewBox.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        previewBox.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        previewBox.heightAnchor.constraint(equalToConstant: view.bounds.height * 0.15).isActive = true
    }
    
    func initSliderValues() {
        let flashSpeed = LedOptions.shared.loadFlashSpeed()
        flashSpeedSlider.value = flashSpeed
        
        let backgroundHex = LedOptions.shared.loadFlashBackground()
        backgroundColourSlider.minimumTrackTintColor = UIColor.hexStringToUIColor(hex: backgroundHex)
        backgroundColourSlider.maximumTrackTintColor = backgroundColourSlider.minimumTrackTintColor
        backgroundColourSlider.value = Float(backgroundColourSlider.minimumTrackTintColor?.hsba.h ?? 0.5)
    }
    
    @objc func flashSpeedDidChange(sender: UISlider) {
        LedOptions.shared.updateFlashSpeed(value: sender.value)
        let backgroundHex = LedOptions.shared.loadFlashBackground()
        previewBox.updateFlash(color: UIColor.hexStringToUIColor(hex: backgroundHex), duration: sender.value)
    }
    
    @objc func backgroundDidChange(sender: UISlider) {
        backgroundColourSlider.minimumTrackTintColor = UIColor.init(hue: CGFloat(sender.value), saturation: 1.0, brightness: 1.0, alpha: 1.0)
        backgroundColourSlider.maximumTrackTintColor = backgroundColourSlider.minimumTrackTintColor
        
//        previewBox.backgroundColor = backgroundColourSlider.minimumTrackTintColor!
        LedOptions.shared.updateFlashBackground(hue: CGFloat(sender.value))
        previewBox.updateFlash(color: backgroundColourSlider.minimumTrackTintColor!, duration: LedOptions.shared.loadFlashSpeed())
    }
}
