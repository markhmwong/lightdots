//
//  FeatureView.swift
//  Marquee
//
//  Created by Mark Wong on 28/10/2022.
//

import UIKit

class FeatureView: UIView {
    
    // image
    lazy var image: UIImageView = {
        let image = UIImage(systemName: "", withConfiguration: UIImage.SymbolConfiguration(scale: .large))
        let imageView = UIImageView(image: image)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    // feature
    lazy var featureTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.preferredFont(forTextStyle: .title3).with(weight: .bold)
        label.textColor = .textColor
        return label
    }()
    
    // feature description
    lazy var featureDescriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.preferredFont(forTextStyle: .caption1).with(weight: .regular)
        label.textColor = .textColor
        label.alpha = 0.5
        label.numberOfLines = 0
        return label
    }()
    
    
    init(image: String, featureTitle: String, featureDescription: String) {
        super.init(frame: .zero)
        self.image.image = UIImage(systemName: image, withConfiguration: UIImage.SymbolConfiguration(scale: .large))
        self.featureTitleLabel.text = featureTitle
        self.featureDescriptionLabel.text = featureDescription
        self.translatesAutoresizingMaskIntoConstraints = false
        
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupLayout() {
        
        self.addSubview(image)
        self.addSubview(featureTitleLabel)
        self.addSubview(featureDescriptionLabel)
        
        image.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        image.topAnchor.constraint(equalTo: featureTitleLabel.topAnchor, constant: 0).isActive = true
//        image.setContentCompressionResistancePriority(UILayoutPriority.defaultLow, for: .horizontal)
        image.widthAnchor.constraint(equalToConstant: 30.0).isActive = true
        image.heightAnchor.constraint(equalToConstant: 30.0).isActive = true
        featureTitleLabel.leadingAnchor.constraint(equalTo: image.trailingAnchor, constant: 30).isActive = true
        featureTitleLabel.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 30).isActive = true
        featureTitleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true

        featureDescriptionLabel.topAnchor.constraint(equalTo: featureTitleLabel.bottomAnchor, constant: 5).isActive = true
        featureDescriptionLabel.leadingAnchor.constraint(equalTo: featureTitleLabel.leadingAnchor).isActive = true
        featureDescriptionLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        featureDescriptionLabel.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor).isActive = true

    }
    
}

