//
//  GradientOptionsViewController.swift
//  Marquee
//
//  Created by Mark Wong on 14/10/2022.
//

import UIKit



class ShimmerOptionsViewController: UIViewController {
    
    private lazy var previewLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Random LEDs fade in/out"
        label.alpha = 0.5
        label.font = UIFont.preferredFont(forTextStyle: .caption1).with(weight: .bold)
        return label
    }()
                                                                                                                                                                  
    private lazy var backgroundLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Background Solid Colour"
        label.font = UIFont.preferredFont(forTextStyle: .body).with(weight: .bold)
        return label
    }()
    
    private lazy var foregroundLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Foreground Shimmer Colour"
        label.font = UIFont.preferredFont(forTextStyle: .body).with(weight: .bold)
        return label
    }()
    
    private lazy var foregroundBrightnessLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Foreground Brightness"
        label.font = UIFont.preferredFont(forTextStyle: .body).with(weight: .bold)
        return label
    }()
    
    private lazy var backgroundBrightnessLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Background Brightness"
        label.font = UIFont.preferredFont(forTextStyle: .body).with(weight: .bold)
        return label
    }()
    
    private lazy var foregroundColourSlider: UISlider = {
        let slider = UISlider(frame: .zero)
        slider.translatesAutoresizingMaskIntoConstraints = false
        slider.minimumValue = 0
        slider.maximumValue = 1
        slider.isContinuous = true
        slider.addTarget(self, action: #selector(foregroundDidChange), for: .valueChanged)
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
    
    private lazy var foregroundBrightnessSlider: UISlider = {
        let slider = UISlider(frame: .zero)
        slider.translatesAutoresizingMaskIntoConstraints = false
        slider.minimumValue = 0
        slider.maximumValue = 1
        slider.isContinuous = true
        slider.addTarget(self, action: #selector(foregroundBrightnessDidChange), for: .valueChanged)
        return slider
    }()
    
    private lazy var backgroundBrightnessSlider: UISlider = {
        let slider = UISlider(frame: .zero)
        slider.translatesAutoresizingMaskIntoConstraints = false
        slider.minimumValue = 0
        slider.maximumValue = 1
        slider.isContinuous = true
        slider.addTarget(self, action: #selector(backgroundBrightnessDidChange), for: .valueChanged)
        return slider
    }()
    
    private lazy var previewBox: PreviewBox = {
        let view = PreviewBox(frame: self.view.bounds, type: .shimmer)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    
    override func loadView() {
        super.loadView()
        title = "Shimmer"
        view.backgroundColor = .background
        self.initSliderValues()
        
        self.view.addSubview(foregroundColourSlider)
        self.view.addSubview(backgroundColourSlider)
        self.view.addSubview(backgroundLabel)
        self.view.addSubview(foregroundLabel)
        
        self.view.addSubview(foregroundBrightnessSlider)
        self.view.addSubview(backgroundBrightnessSlider)
        self.view.addSubview(backgroundBrightnessLabel)
        self.view.addSubview(foregroundBrightnessLabel)
        
        self.view.addSubview(previewBox)
        self.view.addSubview(previewLabel)
        
        previewLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        previewLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        let lateralPadding = 25.0
        foregroundLabel.topAnchor.constraint(equalTo: previewBox.bottomAnchor, constant: 20.0).isActive = true
        foregroundLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: lateralPadding).isActive = true
        foregroundLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -lateralPadding).isActive = true
        
        foregroundColourSlider.topAnchor.constraint(equalTo: foregroundLabel.bottomAnchor, constant: 10).isActive = true
        foregroundColourSlider.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: lateralPadding).isActive = true
        foregroundColourSlider.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -lateralPadding).isActive = true
        
        foregroundBrightnessLabel.topAnchor.constraint(equalTo: foregroundColourSlider.bottomAnchor, constant: 20.0).isActive = true
        foregroundBrightnessLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: lateralPadding).isActive = true
        foregroundBrightnessLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -lateralPadding).isActive = true
        
        foregroundBrightnessSlider.topAnchor.constraint(equalTo: foregroundBrightnessLabel.bottomAnchor, constant: 20.0).isActive = true
        foregroundBrightnessSlider.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: lateralPadding).isActive = true
        foregroundBrightnessSlider.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -lateralPadding).isActive = true

        
        backgroundLabel.topAnchor.constraint(equalTo: foregroundBrightnessSlider.bottomAnchor, constant: 25).isActive = true
        backgroundLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: lateralPadding).isActive = true
        backgroundLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -lateralPadding).isActive = true
        
        backgroundColourSlider.topAnchor.constraint(equalTo: backgroundLabel.bottomAnchor, constant: 10).isActive = true
        backgroundColourSlider.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: lateralPadding).isActive = true
        backgroundColourSlider.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -lateralPadding).isActive = true
        
        backgroundBrightnessLabel.topAnchor.constraint(equalTo: backgroundColourSlider.bottomAnchor, constant: 25).isActive = true
        backgroundBrightnessLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: lateralPadding).isActive = true
        backgroundBrightnessLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -lateralPadding).isActive = true
        
        backgroundBrightnessSlider.topAnchor.constraint(equalTo: backgroundBrightnessLabel.bottomAnchor, constant: 10).isActive = true
        backgroundBrightnessSlider.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: lateralPadding).isActive = true
        backgroundBrightnessSlider.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -lateralPadding).isActive = true
        
        previewBox.topAnchor.constraint(equalTo: self.previewLabel.safeAreaLayoutGuide.bottomAnchor, constant: 10).isActive = true
        previewBox.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        previewBox.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        previewBox.heightAnchor.constraint(equalToConstant: view.bounds.height * 0.15).isActive = true
    }
    
    func initSliderValues() {
        let fColor = LedOptions.shared.loadShimmerForeground()
        foregroundColourSlider.minimumTrackTintColor = UIColor.init(hue: fColor.hsba.h, saturation: 1.0, brightness: 1.0, alpha: 1.0)
        foregroundColourSlider.maximumTrackTintColor = foregroundColourSlider.minimumTrackTintColor
        foregroundColourSlider.value = Float(foregroundColourSlider.minimumTrackTintColor?.hsba.h ?? 0.5)
        
        foregroundBrightnessSlider.minimumTrackTintColor = fColor
        foregroundBrightnessSlider.maximumTrackTintColor = foregroundBrightnessSlider.minimumTrackTintColor
        foregroundBrightnessSlider.value = Float(foregroundBrightnessSlider.minimumTrackTintColor?.hsba.b ?? 0.5)
        
        let bColor = LedOptions.shared.loadShimmerBackground()
        backgroundColourSlider.minimumTrackTintColor = bColor
        backgroundColourSlider.maximumTrackTintColor = backgroundColourSlider.minimumTrackTintColor
        backgroundColourSlider.value = Float(backgroundColourSlider.minimumTrackTintColor?.hsba.h ?? 0.5)
        
        backgroundBrightnessSlider.minimumTrackTintColor = bColor
        backgroundBrightnessSlider.maximumTrackTintColor = backgroundBrightnessSlider.minimumTrackTintColor
        backgroundBrightnessSlider.value = Float(backgroundBrightnessSlider.minimumTrackTintColor?.hsba.b ?? 0.5)
    }
    
    @objc func foregroundDidChange(sender: UISlider) {
        foregroundColourSlider.minimumTrackTintColor = UIColor.init(hue: CGFloat(sender.value), saturation: 1.0, brightness: 1.0, alpha: 1.0)
        foregroundColourSlider.maximumTrackTintColor = foregroundColourSlider.minimumTrackTintColor
        
        // update foreground brightness
        foregroundBrightnessSlider.minimumTrackTintColor = UIColor.init(hue: CGFloat(foregroundColourSlider.value), saturation: 1.0, brightness: CGFloat(foregroundBrightnessSlider.value), alpha: 1.0)
        foregroundBrightnessSlider.maximumTrackTintColor = foregroundBrightnessSlider.minimumTrackTintColor
        
        LedOptions.shared.updateShimmerForeground(hue: CGFloat(sender.value), brightness: CGFloat(foregroundBrightnessSlider.value))

        previewBox.backgroundReset(foregroundColourSlider.minimumTrackTintColor!)
    }
    
    @objc func foregroundBrightnessDidChange(_ slider: UISlider) {
        // update brightness slider
        foregroundBrightnessSlider.minimumTrackTintColor = UIColor.init(hue: CGFloat(foregroundColourSlider.value), saturation: 1.0, brightness: CGFloat(slider.value), alpha: 1.0)
        foregroundBrightnessSlider.maximumTrackTintColor = foregroundBrightnessSlider.minimumTrackTintColor

        LedOptions.shared.updateShimmerForeground(hue: CGFloat(foregroundColourSlider.value), brightness: CGFloat(slider.value))
    }
    
    @objc func backgroundDidChange(sender: UISlider) {
        backgroundColourSlider.minimumTrackTintColor = UIColor.init(hue: CGFloat(sender.value), saturation: 1.0, brightness: 1.0, alpha: 1.0)
        backgroundColourSlider.maximumTrackTintColor = backgroundColourSlider.minimumTrackTintColor
        
        // update brightness for background
        backgroundBrightnessSlider.minimumTrackTintColor = UIColor.init(hue: CGFloat(backgroundColourSlider.value), saturation: 1.0, brightness: CGFloat(backgroundBrightnessSlider.value), alpha: 1.0)
        backgroundBrightnessSlider.maximumTrackTintColor = backgroundBrightnessSlider.minimumTrackTintColor
        
        previewBox.backgroundColor = backgroundColourSlider.minimumTrackTintColor!
        
        LedOptions.shared.updateShimmerBackground(hue: CGFloat(sender.value))
    }
    
    @objc func backgroundBrightnessDidChange(_ slider: UISlider) {
        // update brightness slider
        backgroundBrightnessSlider.minimumTrackTintColor = UIColor.init(hue: CGFloat(backgroundColourSlider.value), saturation: 1.0, brightness: CGFloat(slider.value), alpha: 1.0)
        backgroundBrightnessSlider.maximumTrackTintColor = backgroundBrightnessSlider.minimumTrackTintColor
        
        // save
        LedOptions.shared.updateShadowColour(hue: CGFloat(backgroundColourSlider.value), brightness: CGFloat(slider.value))
    }
}
