//
//  AddEventNameView.swift
//  Celebrate
//
//  Created by Mark Wong on 13/3/2022.
//

import UIKit

struct MessageConfiguration : UIContentConfiguration {
    var event: LedOptionsViewModel.OptionItem! = nil
    var section: LedOptionsViewModel.Section? = nil
    
    func makeContentView() -> UIView & UIContentView {
        let c = MessageView(configuration: self)
        return c
    }
    
    func updated(for state: UIConfigurationState) -> Self {
        guard state is UICellConfigurationState else { return self }
        
        let updatedConfig = self
        return updatedConfig
    }
}

/*
 
 MARK: - Name
 
 */
// created to support ipad for font sizing

class MessageView: UIView, UIContentView, UITextViewDelegate {
    var configuration: UIContentConfiguration {
        didSet {
            self.configure()
        }
    }

    private lazy var countLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .caption1)
        label.textColor = UIColor.white
        label.text = "0"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var message: AutoExpandingTextView = {
        let tf = AutoExpandingTextView(frame: .zero, textContainer: nil)
        tf.isScrollEnabled = true
        tf.textColor = .white
        tf.font = UIFont.preferredFont(forTextStyle: .title3)
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.backgroundColor = UIColor.systemBackground
        tf.textAlignment = .left
        tf.text = "test"
        tf.delegate = self
        return tf
    }()

    init(configuration: UIContentConfiguration) {
        self.configuration = configuration
        super.init(frame: .zero)
        self.configure()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        self.backgroundColor = message.backgroundColor
        self.clipsToBounds = false
        self.layer.cornerRadius = 10.0
        self.layer.borderColor = UIColor.white.cgColor
        self.layer.borderWidth = 1.5
        
        addSubview(message)
        addSubview(countLabel)
        
        message.topAnchor.constraint(equalTo: readableContentGuide.topAnchor, constant: 0).isActive = true
        message.leadingAnchor.constraint(equalTo: readableContentGuide.leadingAnchor, constant: 0).isActive = true
//        message.bottomAnchor.constraint(equalTo: readableContentGuide.bottomAnchor, constant: 0).isActive = true
        message.trailingAnchor.constraint(equalTo: readableContentGuide.trailingAnchor, constant: 0).isActive = true

        countLabel.topAnchor.constraint(equalTo: bottomAnchor).isActive = true
        countLabel.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        
        guard let config = self.configuration as? MessageConfiguration else { return }
        countLabel.text = "\(config.event?.name.count ?? 0)"
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        message.layoutIfNeeded()
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
        return newLength <= MessageRestrictions.name.rawValue
    }
    
    
}


class AutoExpandingTextView: UITextView {

    private var heightConstraint: NSLayoutConstraint!

    var maxHeight: CGFloat = 50 {
        didSet {
//            heightConstraint?.constant = maxHeight
        }
    }
    
    

    private var observer: NSObjectProtocol?

    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        commonInit()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }

    private func commonInit() {
        heightConstraint = heightAnchor.constraint(equalToConstant: maxHeight)

//        observer = NotificationCenter.default.addObserver(forName: UITextView.textDidChangeNotification, object: nil, queue: .main) { [weak self] _ in
//            guard let self = self else { return }
//            self.heightConstraint.isActive = self.contentSize.height > self.maxHeight
//            self.isScrollEnabled = self.contentSize.height > self.maxHeight
//            self.invalidateIntrinsicContentSize()
//        }
    }
}
