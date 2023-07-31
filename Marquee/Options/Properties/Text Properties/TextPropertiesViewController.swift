//
//  TextPropertiesViewController.swift
//  Marquee
//
//  Created by Mark Wong on 5/10/2022.
//

import UIKit



class TextPropertiesViewController: UIViewController {
    
    enum FontFormatting: Int, CaseIterable {
        case bold
        case italic
        case underline
        
        var imageName: String {
            switch self {
            case .underline:
                return "underline"
            case .italic:
                return "italic"
            case .bold:
                return "bold"
            }
        }
    }
    
    private let step: Float = 1
    
    private lazy var textSizeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Grape"
        label.textColor = UIColor.textColor
        label.font = UIFont.preferredFont(forTextStyle: .body).with(weight: .bold)
        return label
    }()
    
    private lazy var textSize: UISlider = {
        let slider = UISlider()
        slider.minimumValue = 0
        slider.maximumValue = Float(TextSize.allCases.count - 1)
        slider.addTarget(self, action: #selector(handleSize), for: .valueChanged)
        slider.translatesAutoresizingMaskIntoConstraints = false
        return slider
    }()
    
    private lazy var textSpeedLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "0"
        label.textColor = UIColor.textColor
        label.font = UIFont.preferredFont(forTextStyle: .body).with(weight: .bold)
        return label
    }()
    
    private lazy var textSpeed: UISlider = {
        let slider = UISlider()
        slider.minimumValue = 0
        slider.maximumValue = 60
        slider.addTarget(self, action: #selector(handleSpeed), for: .valueChanged)
        slider.translatesAutoresizingMaskIntoConstraints = false
        return slider
    }()
    
    private var svFont = UIStackView()

    override func loadView() {
        super.loadView()
        title = "Properties"
        // layout
        view.backgroundColor = .background
        
        view.addSubview(textSize)
        view.addSubview(textSizeLabel)
        view.addSubview(textSpeed)
        view.addSubview(textSpeedLabel)
        
        textSpeedLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        textSpeedLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        textSpeed.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        textSpeed.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        textSpeed.topAnchor.constraint(equalTo: textSpeedLabel.bottomAnchor).isActive = true
        
        textSizeLabel.topAnchor.constraint(equalTo: textSpeed.safeAreaLayoutGuide.bottomAnchor, constant: 20).isActive = true
        textSizeLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        textSize.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        textSize.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        textSize.topAnchor.constraint(equalTo: textSizeLabel.bottomAnchor).isActive = true


        let styleButtons = prepareFontStyle()
        
        let stackView = UIStackView(arrangedSubviews: styleButtons)
        stackView.distribution = .fillEqually
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.spacing = 10
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stackView)
        
        stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10).isActive = true
        stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10).isActive = true
        stackView.topAnchor.constraint(equalTo: textSize.bottomAnchor, constant: 30).isActive = true

        // must declare height after stackview
        for s in styleButtons {
            s.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.20).isActive = true
        }
        
        let scrollView = UIScrollView(frame: .zero)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        
        scrollView.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 20).isActive = true
        scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10).isActive = true
        scrollView.heightAnchor.constraint(equalToConstant: view.bounds.height * 0.25).isActive = true
        
        svFont = UIStackView()
        svFont.alignment = .fill
        svFont.distribution = .fillProportionally
        svFont.axis = .horizontal
        svFont.spacing = 10
        svFont.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(svFont)
        
        svFont.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor).isActive = true
        svFont.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor).isActive = true
        svFont.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        
        prepareFonts()
        let fontSize = LedOptions.shared.loadFontSize()
        self.formattedFontSize(value: TextSize.init(rawValue: Int(fontSize)) ?? .mango)
        self.formatScrollSpeed(value: LedOptions.shared.loadScrollSpeed())
    }
    
    
    func prepareFontStyle() -> [UIButton] {
        var styleButtons: [UIButton] = []
        
        for s in FontFormatting.allCases {
            var config = UIButton.Configuration.gray()
            config.image = UIImage(systemName: s.imageName)
            let b = UIButton(configuration: config)
            b.tag = s.rawValue
            
            switch s {
            case .italic:
                b.isSelected = LedOptions.shared.loadItalic()
            case .underline:
                b.isSelected = LedOptions.shared.loadUnderline()
            case .bold:
                b.isSelected = LedOptions.shared.loadBold()
            }
            
            b.addTarget(self, action: #selector(handleFontFormatting), for: .touchDown)
            styleButtons.append(b)
        }
        return styleButtons
    }
    
    func prepareFonts() {
        let loadedFont = LedOptions.shared.loadFont()
        
        for f in FontList.allCases {
            var config = UIButton.Configuration.gray()
            config.title = f.name
            config.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { incoming in
                var outgoing = incoming
                outgoing.font = UIFont(name: f.name, size: UIFont.preferredFont(forTextStyle: .body).pointSize)
                outgoing.foregroundColor = .textColor
                return outgoing
            }
            let b = UIButton(configuration: config)
            b.addTarget(self, action: #selector(handleFontStyle), for: .touchDown)
            b.tag = f.rawValue
            b.isSelected = loadedFont == f
            
            b.translatesAutoresizingMaskIntoConstraints = false
            svFont.addArrangedSubview(b)
        }
    }
    
    @objc func handleFontStyle(sender: UIButton) {
        
        //deselect all buttons
        for b in svFont.arrangedSubviews as! [UIButton] {
            b.isSelected = false
        }
        
        if let font = FontList.init(rawValue: sender.tag) {
            sender.isSelected = true
            LedOptions.shared.updateFont(font: font)
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.default.post(name: .optionsEnableKeyboard, object: nil, userInfo: nil)
    }
    
    @objc func handleSize(sender: UISlider) {
        let roundedValue = round(sender.value / step) * step
        sender.value = roundedValue
        
        self.formattedFontSize(value: TextSize.init(rawValue: Int(roundedValue)) ?? .mango)
        LedOptions.shared.updateFontSize(size: Int(roundedValue))
    }
    
    @objc func handleSpeed(sender: UISlider) {
        let speedStep: Float = 1
        let roundedValue = round(sender.value / speedStep) * speedStep
        sender.value = roundedValue
        
        self.formatScrollSpeed(value: roundedValue)
        LedOptions.shared.updateScrollSpeed(speed: roundedValue)
    }
    
    @objc func handleFontFormatting(sender: UIButton) {
        
        let bp = FontFormatting(rawValue: sender.tag)
        sender.isSelected = !sender.isSelected
        switch bp {
        case .bold:
            LedOptions.shared.updateFontPropertyBold(state: sender.isSelected)
        case .italic:
            LedOptions.shared.updateFontPropertyItalic(state: sender.isSelected)
        case .underline:
            LedOptions.shared.updateFontPropertyUnderline(state: sender.isSelected)
        case .none:
            ()
        }
    }
    
    private func buttonSelected(imageName: String, sender: UIButton) {
        if sender.isSelected {
            
//            var config = UIButton.Configuration.bordered()
//            config.image = UIImage(systemName: imageName)
//            sender.configuration = config
        } else {
//            var config = UIButton.Configuration.filled()
//            config.image = UIImage(systemName: imageName)
//            sender.configuration = config
        }
    }
    
    func formatScrollSpeed(value: Float) {
        self.textSpeed.value = value
        self.textSpeedLabel.text = "Scroll Speed \(value)"
    }
    
    func formattedFontSize(value: TextSize) {
        self.textSize.value = Float(value.rawValue)
        self.textSizeLabel.text = "Text quality - \(value.str)"
    }
    
}
