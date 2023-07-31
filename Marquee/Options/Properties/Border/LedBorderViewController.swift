//
//  LedBorderViewController.swift
//  Ledify
//
//  Created by Mark Wong on 26/11/2022.
//

import UIKit

class LedBorderViewModel: NSObject {
    
    let range: ClosedRange = 0.3...2
    
    override init() {
        super.init()
    }
    
}

class LedBorderViewController: UIViewController {
    
    private let vm: LedBorderViewModel
    
    private let coordinator: Coordinator
    
    private lazy var previewBox: PreviewBox = {
        let view = PreviewBox(frame: self.view.bounds, type: .solid)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var borderHueColor: UISlider = {
        let slider = UISlider()
        slider.minimumValue = 0
        slider.maximumValue = 1
        slider.addTarget(self, action: #selector(handleHue), for: .valueChanged)
        slider.translatesAutoresizingMaskIntoConstraints = false
        return slider
    }()
    
    private lazy var borderBrightnessColor: UISlider = {
        let slider = UISlider()
        slider.minimumValue = 0
        slider.maximumValue = 1
        slider.isContinuous = true
        slider.addTarget(self, action: #selector(handleBrightness), for: .valueChanged)
        slider.translatesAutoresizingMaskIntoConstraints = false
        return slider
    }()
    
    private lazy var borderWidth: UISlider = {
        let slider = UISlider()
        slider.minimumValue = 0.3
        slider.maximumValue = 2
        slider.addTarget(self, action: #selector(handleBorderWidth), for: .valueChanged)
        slider.translatesAutoresizingMaskIntoConstraints = false
        return slider
    }()
    
    private lazy var borderHueLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Hue"
        label.font = UIFont.preferredFont(forTextStyle: .body).with(weight: .bold)
        return label
    }()
    
    private lazy var borderBrightnessLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Brightness"
        label.font = UIFont.preferredFont(forTextStyle: .body).with(weight: .bold)
        return label
    }()
    
    private lazy var borderWidthLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Width"
        label.font = UIFont.preferredFont(forTextStyle: .body).with(weight: .bold)
        return label
    }()
    
    init(viewModel: LedBorderViewModel, coordinator: Coordinator) {
        self.vm = viewModel
        self.coordinator = coordinator
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.default.post(name: .optionsEnableKeyboard, object: nil, userInfo: nil)
    }
    
    override func loadView() {
        super.loadView()
        view.backgroundColor = .background
        title = "Border Properties"
        self.view.addSubview(borderHueLabel)
        self.view.addSubview(borderHueColor)
        self.view.addSubview(borderBrightnessLabel)
        self.view.addSubview(borderBrightnessColor)
        self.view.addSubview(borderWidthLabel)
        self.view.addSubview(borderWidth)
        self.view.addSubview(previewBox)
        
        previewBox.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive = true
        previewBox.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 10).isActive = true
        previewBox.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -10).isActive = true
        previewBox.heightAnchor.constraint(equalToConstant: view.bounds.height * 0.15).isActive = true

        borderHueLabel.topAnchor.constraint(equalTo: previewBox.bottomAnchor).isActive = true
        borderHueLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 10).isActive = true
        borderHueLabel.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -10).isActive = true
        
        borderHueColor.topAnchor.constraint(equalTo: borderHueLabel.bottomAnchor, constant: 5).isActive = true
        borderHueColor.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 10).isActive = true
        borderHueColor.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -10).isActive = true
        
        borderBrightnessLabel.topAnchor.constraint(equalTo: borderHueColor.bottomAnchor, constant: 5).isActive = true
        borderBrightnessLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 10).isActive = true
        borderBrightnessLabel.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -10).isActive = true
        
        borderBrightnessColor.topAnchor.constraint(equalTo: borderBrightnessLabel.bottomAnchor, constant: 10).isActive = true
        borderBrightnessColor.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 10).isActive = true
        borderBrightnessColor.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -10).isActive = true
        
        borderWidthLabel.topAnchor.constraint(equalTo: borderBrightnessColor.bottomAnchor, constant: 10).isActive = true
        borderWidthLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 10).isActive = true
        borderWidthLabel.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -10).isActive = true
        
        borderWidth.topAnchor.constraint(equalTo: borderWidthLabel.bottomAnchor, constant: 5).isActive = true
        borderWidth.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 10).isActive = true
        borderWidth.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -10).isActive = true
        
        initSliders()
    }
    
    func initSliders() {
        let color = LedOptions.shared.loadBorderColor()
        let width = LedOptions.shared.loadBorderWidth()
        
        borderHueColor.minimumTrackTintColor = UIColor.init(hue: color.hsba.h, saturation: 1.0, brightness: 1.0, alpha: 1.0)
        borderHueColor.maximumTrackTintColor = borderHueColor.minimumTrackTintColor
        borderHueColor.value = Float(color.hsba.h)
        
        borderBrightnessColor.minimumTrackTintColor = UIColor.init(hue: color.hsba.h, saturation: 1.0, brightness: color.hsba.b, alpha: 1.0)
        borderBrightnessColor.maximumTrackTintColor = borderBrightnessColor.minimumTrackTintColor
        borderBrightnessColor.value = Float(color.hsba.b)
        
        borderWidth.value = width
    }
    
    @objc func handleHue(slider: UISlider) {
        // update colour slider
        borderHueColor.minimumTrackTintColor = UIColor.init(hue: CGFloat(slider.value), saturation: 1.0, brightness: 1.0, alpha: 1.0)
        borderHueColor.maximumTrackTintColor = borderHueColor.minimumTrackTintColor
        
//        previewBox.backgroundReset(borderHueColor.minimumTrackTintColor!)

        // update brightness slider hue
        borderBrightnessColor.minimumTrackTintColor = UIColor.init(hue: CGFloat(borderHueColor.value), saturation: 1.0, brightness: CGFloat(borderBrightnessColor.value), alpha: 1.0)
        borderBrightnessColor.maximumTrackTintColor = borderBrightnessColor.minimumTrackTintColor
        
        previewBox.borderColourPreview(UIColor.init(hue: CGFloat(borderHueColor.value), saturation: 1.0, brightness: CGFloat(borderBrightnessColor.value), alpha: 1.0))
        // save
        LedOptions.shared.updateBorderColour(hue: CGFloat(slider.value), brightness: CGFloat(borderBrightnessColor.value))
    }
    
    @objc func handleBrightness(slider: UISlider) {
        // update brightness slider
        borderBrightnessColor.minimumTrackTintColor = UIColor.init(hue: CGFloat(borderHueColor.value), saturation: 1.0, brightness: CGFloat(slider.value), alpha: 1.0)
        borderBrightnessColor.maximumTrackTintColor = borderBrightnessColor.minimumTrackTintColor
        
        previewBox.borderColourPreview(borderBrightnessColor.minimumTrackTintColor!)
        // save
        LedOptions.shared.updateBorderColour(hue: CGFloat(borderHueColor.value), brightness: CGFloat(slider.value))
    }
    
    @objc func handleBorderWidth(slider: UISlider) {
        previewBox.borderWidthPreview(CGFloat(slider.value))
        LedOptions.shared.updateBorderWidth(value: slider.value)
    }
}
