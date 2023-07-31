//
//  TextPropertiesConfiguration.swift
//  Marquee
//
//  Created by Mark Wong on 5/10/2022.
//

import UIKit

enum TextPropertyItem {
    case size
}

struct TextPropertiesConfiguration : UIContentConfiguration {
    var item: LedOptionsViewModel.OptionItem! = nil
    var section: LedOptionsViewModel.Section? = nil
    
    func makeContentView() -> UIView & UIContentView {
        let c = TextPropertiesView(configuration: self)
        return c
    }
    
    func updated(for state: UIConfigurationState) -> Self {
        guard state is UICellConfigurationState else { return self }
        
        let updatedConfig = self
        return updatedConfig
    }
}

class TextPropertiesView: UIView, UIContentView, UITextViewDelegate {
    var configuration: UIContentConfiguration {
        didSet {
            self.configureSize()
        }
    }
    
    private lazy var textSize: UISlider = {
        let slider = UISlider(frame: .zero)
        slider.translatesAutoresizingMaskIntoConstraints = false
        return slider
    }()
    
    private lazy var textSizeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Grape"
        return label
    }()
    
    init(configuration: UIContentConfiguration) {
        self.configuration = configuration
        super.init(frame: .zero)
        self.configureSize()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let step: Float = 1
    

    
    private func configureSize() {
        self.clipsToBounds = false
        self.layer.cornerRadius = 10.0
        self.layer.borderColor = UIColor.white.cgColor
        self.layer.borderWidth = 1.5
        
        addSubview(textSize)
        addSubview(textSizeLabel)
//        textSizeLabel.topAnchor.constraint(equalTo: readableContentGuide.topAnchor, constant: 15).isActive = true
//        textSizeLabel.centerXAnchor.constraint(equalTo: centerXAnchor, constant: 0).isActive = true
//        textSizeLabel.bottomAnchor.constraint(equalTo: textSize.topAnchor, constant: 15).isActive = true
        
        textSize.topAnchor.constraint(equalTo: topAnchor, constant: 10).isActive = true
        textSize.leadingAnchor.constraint(equalTo: readableContentGuide.leadingAnchor, constant: 0).isActive = true
        textSize.bottomAnchor.constraint(equalTo: readableContentGuide.bottomAnchor, constant: 0).isActive = true
        textSize.trailingAnchor.constraint(equalTo: readableContentGuide.trailingAnchor, constant: 0).isActive = true
        

        textSize.addTarget(self, action: #selector(handleSize), for: .valueChanged)
        textSize.maximumValue = 4
        textSize.minimumValue = 0
        textSizeLabel.text = TextSize.init(rawValue: Int(textSize.value))?.str
        guard let _ = self.configuration as? MessageConfiguration else { return }
        
        //        switch config.section {
        //        case .name:
        //            textField.placeholder = "Birthday, Graduation, Anniversary"
        //            textField.font = UIFont.preferredFont(forTextStyle: .title1).with(weight: .bold)
        //            textField.text = config.event.name
        //            textField.becomeFirstResponder()
        //        case .note:
        //            textField.placeholder = "Enter a short description"
        //            textField.font = UIFont.preferredFont(forTextStyle: .body).with(weight: .bold)
        //            textField.text = config.event.note
        //        case .category, .none, .redact:
        //            ()
        //        }
    }
    
    @objc func handleSize(sender: UISlider) {
        let roundedValue = round(sender.value / step) * step
        sender.value = roundedValue
        
        textSizeLabel.text = TextSize.init(rawValue: Int(roundedValue))?.str
    }
}
