//
//  ShadowViewController.swift
//  Marquee
//
//  Created by Mark Wong on 8/11/2022.
//

import UIKit

class StaticShadowViewController: UIViewController {
    
    private lazy var hueTitle: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Hue"
        label.font = UIFont.preferredFont(forTextStyle: .body).with(weight: .bold)
        return label
    }()
    
    private lazy var brightnessTitle: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Brightness"
        label.font = UIFont.preferredFont(forTextStyle: .body).with(weight: .bold)
        return label
    }()
    
    private lazy var hueColourSlider: UISlider = {
        let slider = UISlider(frame: .zero)
        slider.translatesAutoresizingMaskIntoConstraints = false
        slider.minimumValue = 0
        slider.maximumValue = 1
        slider.isContinuous = true
        slider.addTarget(self, action: #selector(foregroundDidChange), for: .valueChanged)
        return slider
    }()
    
    private lazy var shadowbrightnessSlider: UISlider = {
        let slider = UISlider(frame: .zero)
        slider.translatesAutoresizingMaskIntoConstraints = false
        slider.minimumValue = 0
        slider.maximumValue = 1
        slider.isContinuous = true
        slider.addTarget(self, action: #selector(brightnessDidChange), for: .valueChanged)
        return slider
    }()
    
    private lazy var previewBox: PreviewBox = {
        let view = PreviewBox(frame: self.view.bounds, type: .shimmer)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var previewLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Preview"
        label.alpha = 0.5
        label.font = UIFont.preferredFont(forTextStyle: .caption1).with(weight: .bold)
        return label
    }()
    
    override func loadView() {
        super.loadView()
        view.backgroundColor = .background
        view.addSubview(hueColourSlider)
        view.addSubview(shadowbrightnessSlider)
        view.addSubview(hueTitle)
        view.addSubview(brightnessTitle)
        
        hueTitle.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant:20).isActive = true
        hueTitle.leadingAnchor.constraint(equalTo: view.readableContentGuide.leadingAnchor).isActive = true
        
        hueColourSlider.topAnchor.constraint(equalTo: hueTitle.safeAreaLayoutGuide.bottomAnchor).isActive = true
        hueColourSlider.leadingAnchor.constraint(equalTo: view.readableContentGuide.leadingAnchor).isActive = true
        hueColourSlider.trailingAnchor.constraint(equalTo: view.readableContentGuide.trailingAnchor).isActive = true
        
        brightnessTitle.topAnchor.constraint(equalTo: hueColourSlider.safeAreaLayoutGuide.bottomAnchor, constant:10).isActive = true
        brightnessTitle.leadingAnchor.constraint(equalTo: view.readableContentGuide.leadingAnchor).isActive = true
        
        shadowbrightnessSlider.topAnchor.constraint(equalTo: brightnessTitle.safeAreaLayoutGuide.bottomAnchor).isActive = true
        shadowbrightnessSlider.leadingAnchor.constraint(equalTo: view.readableContentGuide.leadingAnchor).isActive = true
        shadowbrightnessSlider.trailingAnchor.constraint(equalTo: view.readableContentGuide.trailingAnchor).isActive = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initSliderValues()
    }
    
    func initSliderValues() {
        let shadowColour = LedOptions.shared.loadShadowColour()
        let colour = UIColor.init(hue: shadowColour.hsba.h, saturation: 1.0, brightness: 1.0, alpha: 1.0)
        hueColourSlider.minimumTrackTintColor = colour
        hueColourSlider.maximumTrackTintColor = hueColourSlider.minimumTrackTintColor
        hueColourSlider.value = Float(hueColourSlider.minimumTrackTintColor?.hsba.h ?? 0.5)
        
        let brightnessColour = UIColor.init(hue: shadowColour.hsba.h, saturation: 1.0, brightness: shadowColour.hsba.b, alpha: 1.0)

        shadowbrightnessSlider.minimumTrackTintColor = brightnessColour
        shadowbrightnessSlider.maximumTrackTintColor = shadowbrightnessSlider.minimumTrackTintColor
        shadowbrightnessSlider.value = Float(shadowbrightnessSlider.minimumTrackTintColor?.hsba.b ?? 0.5)
    }
    
    @objc func foregroundDidChange(_ slider: UISlider) {
        // update colour slider
        hueColourSlider.minimumTrackTintColor = UIColor.init(hue: CGFloat(slider.value), saturation: 1.0, brightness: 1.0, alpha: 1.0)
        hueColourSlider.maximumTrackTintColor = hueColourSlider.minimumTrackTintColor
        
        previewBox.backgroundReset(hueColourSlider.minimumTrackTintColor!)
        
        // save
        LedOptions.shared.updateShadowColour(hue: CGFloat(slider.value), brightness: CGFloat(shadowbrightnessSlider.value))
        
        // update brightness slider hue
        shadowbrightnessSlider.minimumTrackTintColor = UIColor.init(hue: CGFloat(hueColourSlider.value), saturation: 1.0, brightness: CGFloat(shadowbrightnessSlider.value), alpha: 1.0)
        shadowbrightnessSlider.maximumTrackTintColor = shadowbrightnessSlider.minimumTrackTintColor
    }
    
    @objc func brightnessDidChange(_ slider: UISlider) {
        // update brightness slider
        shadowbrightnessSlider.minimumTrackTintColor = UIColor.init(hue: CGFloat(hueColourSlider.value), saturation: 1.0, brightness: CGFloat(slider.value), alpha: 1.0)
        shadowbrightnessSlider.maximumTrackTintColor = shadowbrightnessSlider.minimumTrackTintColor
        
        // save
        LedOptions.shared.updateShadowColour(hue: CGFloat(hueColourSlider.value), brightness: CGFloat(slider.value))
    }
}
