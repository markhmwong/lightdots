//
//  TextShadowCell.swift
//  Marquee
//
//  Created by Mark Wong on 18/10/2022.
//

import UIKit

/*
 
 MARK: Solid Cell
 
 */
class TextShadowCell: BackgroundPropertyCell {
    
    var item: ShadowViewModel.TextShadowItem! = nil {
        didSet {
            self.configure()
        }
    }

    var coordinator: TextShadowCoordinator! = nil
    
    private var backgroundTypeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.preferredFont(forTextStyle: .body).with(weight: .bold)
        label.textColor = UIColor.white
        return label
    }()
    
    lazy var optionsButton: UIButton = {
        var config = UIButton.Configuration.borderless()
        config.image = SubscriptionService.shared.lockImage(Symbol.backgroundOptionsSymbol)
        let button = UIButton(configuration: config)
        button.alpha = 0.7
        button.tintColor = .white
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(handleSolidColour), for: .touchDown)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureLayout() {
        contentView.addSubview(backgroundTypeLabel)

        backgroundTypeLabel.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor).isActive = true
        backgroundTypeLabel.centerXAnchor.constraint(equalTo: self.contentView.centerXAnchor).isActive = true
    }
    
    private func configure() {
        if item.section != .off {
            contentView.addSubview(optionsButton)
            
            optionsButton.topAnchor.constraint(equalTo: self.contentView.topAnchor).isActive = true
            optionsButton.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor).isActive = true
            optionsButton.heightAnchor.constraint(equalToConstant: 20).isActive = true
        }
        backgroundTypeLabel.text = item.name
    }
    
    @objc func handleSolidColour() {
        if SubscriptionService.shared.proStatus() {
            coordinator.showShadow()
        } else {
            coordinator.showProPurchase()
        }
    }
}

