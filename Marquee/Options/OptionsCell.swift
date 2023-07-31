//
//  OptionsCell.swift
//  Marquee
//
//  Created by Mark Wong on 5/10/2022.
//

import UIKit

class OptionsCell: UICollectionViewCell {
    
    var item: LedOptionsViewModel.OptionItem? = nil //{
//        didSet {
//            self.configure()
//        }
//    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
//        self.item = nil
    }
    
//    func configure() {
//        guard let item = item else { return }
//
//    }
    
    override func updateConfiguration(using state: UICellConfigurationState) {
        guard let item = item else { return }
        let section = item.section as! LedOptionsViewModel.Section
        switch section {
        case .message:
            var content = MessageConfiguration().updated(for: state)
            content.section = section
            contentConfiguration = content
        case .textProperties:
            var content = TextPropertiesConfiguration().updated(for: state)
            content.section = section
            contentConfiguration = content
        case .backgroundProperties:
            ()
        case .ledProperties:
            ()
        }
    }
}


class OptionsTextCell: UICollectionViewCell, UITextViewDelegate {
    
    var item: LedOptionsViewModel.OptionItem? = nil {
        didSet {
            self.configure()
        }
    }

    override init(frame: CGRect) {
        super.init(frame: .zero)
    }
    
    
    private lazy var countLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .caption1)
        label.textColor = UIColor.white
        label.text = "0"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var textField: AutoExpandingTextView = {
        let tf = AutoExpandingTextView(frame: .zero, textContainer: nil)
        tf.textColor = .white
        tf.isScrollEnabled = false
        tf.font = UIFont.preferredFont(forTextStyle: .title3)
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.backgroundColor = UIColor.systemBackground
        tf.textAlignment = .left
        tf.delegate = self
        return tf
    }()

//    init(configuration: UIContentConfiguration) {
//        self.configuration = configuration
//        super.init(frame: .zero)
//        self.configure()
//    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        self.backgroundColor = textField.backgroundColor
        self.clipsToBounds = false
        self.layer.cornerRadius = 10.0
        self.layer.borderColor = UIColor.white.cgColor
        self.layer.borderWidth = 1.5
        
        addSubview(textField)
        addSubview(countLabel)
        
        textField.topAnchor.constraint(equalTo: readableContentGuide.topAnchor, constant: 0).isActive = true
        textField.leadingAnchor.constraint(equalTo: readableContentGuide.leadingAnchor, constant: 0).isActive = true
        textField.bottomAnchor.constraint(equalTo: readableContentGuide.bottomAnchor, constant: 0).isActive = true
        textField.trailingAnchor.constraint(equalTo: readableContentGuide.trailingAnchor, constant: 0).isActive = true

        countLabel.topAnchor.constraint(equalTo: bottomAnchor).isActive = true
        countLabel.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        
//        guard let config = self.configuration as? MessageConfiguration else { return }
//        countLabel.text = "\(config.event?.name.count ?? 0)"
    }

    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        textField.invalidateIntrinsicContentSize()
//        textField.layoutIfNeeded()
        let currentCharacterCount = textView.text?.count ?? 0
        if range.length + range.location > currentCharacterCount {
            return false
        }
        let newLength = currentCharacterCount + text.count - range.length
        self.countLabel.text = "\(newLength)"
        
        let threshold = MessageRestrictions.name.rawValue - newLength
        
        if (threshold <= 10) {
            self.countLabel.textColor = .systemOrange
        }
        return newLength <= MessageRestrictions.name.rawValue - 1
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.item = nil
    }
}
