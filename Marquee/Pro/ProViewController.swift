//
//  ProViewController.swift
//  Marquee
//
//  Created by Mark Wong on 27/10/2022.
//

import UIKit
import RevenueCat
import SafariServices
import TelemetryClient

class ProViewController: UIViewController {
    
    private var vm: ProViewModel
    
    private var coordinator: ProCoordinator
       
    fileprivate lazy var scrollView: UIScrollView = {
        let view = UIScrollView()
        view.showsVerticalScrollIndicator = false
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Pro"
        label.font = UIFont.preferredFont(forTextStyle: .title1).with(weight: .bold)
        label.textColor = .textColor
        return label
    }()
    
    private lazy var supportLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Buy Pro to gain access to additional features and to support me as an Indie Developer."
        label.font = UIFont.preferredFont(forTextStyle: .caption1).with(weight: .bold)
        label.textColor = .textColor
        label.numberOfLines = 0
        label.alpha = 0.8
        return label
    }()
    
    private lazy var bottomContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .background.lighter(by:5)
        return view
    }()
    
    fileprivate lazy var subButton: UIButton = {
        var config = UIButton.Configuration.filled()
        config.cornerStyle = .capsule
        config.title = "loading.."
        config.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { incoming in
            var outgoing = incoming
            outgoing.font = UIFont.preferredFont(forTextStyle: .body).with(weight: .bold)
            outgoing.foregroundColor = .textColor
            return outgoing
        }
        config.titleAlignment = .center
        let button = UIButton(configuration: config)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.configuration?.contentInsets.top = 8
        button.configuration?.contentInsets.bottom = 8
        button.addTarget(self, action: #selector(handleMonthlySub), for: .touchDown)
        return button
    }()
    
    private lazy var otherPlansButton: UIButton = {
        var config = UIButton.Configuration.plain()
        config.title = "View other plans"
        config.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { incoming in
            var outgoing = incoming
            outgoing.font = UIFont.preferredFont(forTextStyle: .caption1).with(weight: .regular)
            outgoing.foregroundColor = .textColor
            return outgoing
         }
        let button = UIButton(configuration: config)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.configuration?.contentInsets.top = 13
        button.configuration?.contentInsets.bottom = 13
        button.addTarget(self, action: #selector(handleOtherPlans), for: .touchDown)
        return button
    }()
    
    lazy var restoreButton: UIButton = {
        var config = UIButton.Configuration.filled()
        config.title = "Restore Purchase"
        config.cornerStyle = .capsule
        config.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { incoming in
            var outgoing = incoming
            outgoing.font = UIFont.preferredFont(forTextStyle: .caption1).with(weight: .regular)
            outgoing.foregroundColor = .textColor
            
            return outgoing
        }
        let button = UIButton(configuration: config)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.configuration?.contentInsets.top = 5
        button.configuration?.contentInsets.bottom = 5
        button.addTarget(self, action: #selector(handleRestore), for: .touchDown)
        return button
    }()
    
    lazy var privacyButton: UIButton = {
        var config = UIButton.Configuration.gray()
        config.title = "Privacy Policy"
        config.cornerStyle = .dynamic
        config.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { incoming in
            var outgoing = incoming
            outgoing.font = UIFont.preferredFont(forTextStyle: .caption1).with(weight: .regular)
            outgoing.foregroundColor = .textColor
            return outgoing
         }
        let button = UIButton(configuration: config)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.configuration?.contentInsets.top = 5
        button.configuration?.contentInsets.bottom = 5
        button.addTarget(self, action: #selector(handlePrivacy), for: .touchDown)
        return button
    }()
    
    lazy var termsButton: UIButton = {
        var config = UIButton.Configuration.gray()
        config.title = "Terms"
        config.cornerStyle = .dynamic
        
        config.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { incoming in
            var outgoing = incoming
            outgoing.font = UIFont.preferredFont(forTextStyle: .caption1).with(weight: .regular)
            outgoing.foregroundColor = .textColor
            return outgoing
         }
        let button = UIButton(configuration: config)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.configuration?.contentInsets.top = 5
        button.configuration?.contentInsets.bottom = 5
        button.addTarget(self, action: #selector(handleTerms), for: .touchDown)
        return button
    }()
    
    init(vm: ProViewModel, coordinator: ProCoordinator) {
        self.vm = vm
        self.coordinator = coordinator
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        view.backgroundColor = .background
        navigationItem.title = "LightDots Pro"
        TelemetryManager.send(TelemetryManager.Signal.subscriptionDidShow.rawValue)
        self.setupView()
        self.subcriptions()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.scrollView.contentSize.height = self.scrollView.contentSize.height + 140
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)

        NotificationCenter.default.post(name: .savedOptions, object: nil, userInfo: nil)
    }
    
    private func activeSubDetected() {
        self.subButton.isUserInteractionEnabled = false
        self.subButton.setTitle("Subscribed to Pro", for: .normal)
        
        self.otherPlansButton.isUserInteractionEnabled = false
        self.otherPlansButton.alpha = 0.0
    }
    
    private var monthlyProduct: StoreProduct! = nil
    
    @objc func handleOtherPlans() {
        //monthly $1.99
        //yearly $10
        //free forever $30
        print("Incomplete")
        coordinator.showOtherPlans()
    }
    
    private var activityIndicatorView: UIActivityIndicatorView! = nil
    
    @objc func handleMonthlySub() {
        self.activityIndicatorView = UIActivityIndicatorView(style: .medium)
        self.activityIndicatorView.translatesAutoresizingMaskIntoConstraints = false
        
        self.subButton.addSubview(self.activityIndicatorView)
        
        self.activityIndicatorView.centerXAnchor.constraint(equalTo: self.subButton.centerXAnchor).isActive = true
        self.activityIndicatorView.centerYAnchor.constraint(equalTo: self.subButton.centerYAnchor).isActive = true

        self.activityIndicatorView.startAnimating()
        
        DispatchQueue.main.async {
            self.subButton.setTitle(" ", for: .normal)
            self.subButton.backgroundColor = self.subButton.backgroundColor?.darker(by:20)
        }
        
        Purchases.shared.purchase(product: monthlyProduct) { transaction, custInfo, error, state in
            if error != nil {
                WarningBox.showCustomAlertBox(title: "\(error?.localizedDescription ?? "Unknown")", message: "\(error?.localizedFailureReason ?? "Some reason")", vc: self)
            } else {
                // success
                WarningBox.showCustomAlertBox(title: "A big thanks!", message: "Purchase complete", vc: self)
                SubscriptionService.shared.updateProState(true)
                self.subButton.setTitle("Purchased. A big Thanks! 🥳", for: .normal)
                self.activityIndicatorView.stopAnimating()
                self.activityIndicatorView = nil
            }
        }
    }
    
    @objc func handleRestore() {
        self.subButton.isUserInteractionEnabled = false
        self.subButton.setTitle("checking..", for: .normal)
        Purchases.shared.restorePurchases { customerInfo, error in
            
            if (error != nil) {
                self.subButton.isUserInteractionEnabled = true
                WarningBox.showCustomAlertBox(title: "\(error?.localizedDescription ?? "Unknown")", message: "\(error?.localizedFailureReason ?? "Some reason")", vc: self)

            } else {
                WarningBox.showCustomAlertBox(title: "Purchase restored", message: "Congrats!", vc: self)
                self.subButton.setTitle("Restored 😊", for: .normal)
                self.subButton.isUserInteractionEnabled = false
                SubscriptionService.shared.updateProState(true)
            }
        }
    }
    
    @objc func handlePrivacy() {
        let config = SFSafariViewController.Configuration()
        config.entersReaderIfAvailable = true

        let vc = SFSafariViewController(url: URL(string: "https://www.apple.com/legal/internet-services/itunes/dev/stdeula/")!, configuration: config)
        present(vc, animated: true)
    }
    
    @objc func handleTerms() {
        let config = SFSafariViewController.Configuration()
        config.entersReaderIfAvailable = true

        let vc = SFSafariViewController(url: URL(string: "https://github.com/markhmwong/lightdots")!, configuration: config)
        present(vc, animated: true)
    }
}

/*
 
 MARK: View
 
 */
extension ProViewController {
    private func setupView() {
        
        self.view.addSubview(scrollView)
        scrollView.addSubview(titleLabel)
        scrollView.addSubview(supportLabel)
        scrollView.addSubview(privacyButton)
        scrollView.addSubview(termsButton)
        scrollView.addSubview(restoreButton)
        self.view.addSubview(subButton)
//        self.view.addSubview(otherPlansButton)
        
        scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40).isActive = true
        scrollView.leadingAnchor.constraint(equalTo: view.readableContentGuide.leadingAnchor).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: view.readableContentGuide.trailingAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.readableContentGuide.bottomAnchor).isActive = true
        
        titleLabel.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor).isActive = true
        
        supportLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10).isActive = true
        supportLabel.leadingAnchor.constraint(equalTo: scrollView.readableContentGuide.leadingAnchor).isActive = true
        supportLabel.trailingAnchor.constraint(equalTo: scrollView.readableContentGuide.trailingAnchor).isActive = true
        
        privacyButton.topAnchor.constraint(equalTo: supportLabel.bottomAnchor, constant: 3).isActive = true
        privacyButton.trailingAnchor.constraint(equalTo: scrollView.centerXAnchor, constant: -3).isActive = true
        
        termsButton.topAnchor.constraint(equalTo: supportLabel.bottomAnchor, constant: 3).isActive = true
        termsButton.leadingAnchor.constraint(equalTo: scrollView.centerXAnchor, constant: 3).isActive = true
        
        let noAds = FeatureView(image: "xmark.seal.fill", featureTitle: "Remove Ads", featureDescription: "No more nasty ads. Remove the ads showing on the main banner and options screens.")
        let additionalBackgrounds = FeatureView(image: "paintbrush.fill", featureTitle: "Background Effects", featureDescription: "Mix different colours for a wide range of animated backgrounds to get excited about.")
        let hd = FeatureView(image: "cube.fill", featureTitle: "High Definition", featureDescription: "Increase LED density, for a shaper banner.")
        let vibrate = FeatureView(image: "iphone.radiowaves.left.and.right.circle.fill", featureTitle: "Vibrate on completion", featureDescription: "Be notified of when the message has completed scrolling.")
        let textShadow = FeatureView(image: "shadow", featureTitle: "Text Shadows", featureDescription: "The device vibrates when the message has completed scrolling the message")
        let ledShapes = FeatureView(image: "square.fill", featureTitle: "Matrix Shapes", featureDescription: "Change the LED matrix shape, choose between, square, circles or diamonds")
        let support = FeatureView(image: "person.crop.circle.fill", featureTitle: "Support Me", featureDescription: "Support Indie development, so I can make more kewl apps.")
        let _ = FeatureView(image: "iphone.radiowaves.left.and.right.circle.fill", featureTitle: "Vibrate on completion", featureDescription: "The device vibrates when the message has completed scrolling the message")
        let disclaimer = FeatureView(image: "iphone.radiowaves.left.and.right.circle.fill", featureTitle: "Vibrate on completion", featureDescription: "The device vibrates when the message has completed scrolling the message")
        let stackView = UIStackView(arrangedSubviews: [noAds, additionalBackgrounds, hd, vibrate, textShadow, ledShapes, support])
        stackView.alignment = .leading
        stackView.contentMode = .left
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(stackView)
        stackView.topAnchor.constraint(equalTo: supportLabel.bottomAnchor, constant: 30).isActive = true
        stackView.leadingAnchor.constraint(equalTo: scrollView.readableContentGuide.leadingAnchor, constant: 0).isActive = true
        stackView.trailingAnchor.constraint(equalTo: scrollView.readableContentGuide.trailingAnchor, constant: 0).isActive = true
        stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: 0).isActive = true
        stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true

        subButton.bottomAnchor.constraint(equalTo: restoreButton.topAnchor, constant: -10).isActive = true
        subButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        subButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -30).isActive = true
        subButton.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 30).isActive = true
        
//        otherPlansButton.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -40).isActive = true
//        otherPlansButton.leadingAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 0).isActive = true
        
        restoreButton.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -40).isActive = true
        restoreButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
    }
}

/*
 
 MARK: Toolbar
 
 */
extension ProViewController {
    private func subcriptions() {
        Purchases.shared.getOfferings { (offerings, error) in
            if let offerings = offerings {
              // Display current offering with offerings.current
                guard let current = offerings.current,
                      let monthly = current.monthly
                else { return }
                self.monthlyProduct = offerings.current?.monthly?.storeProduct
                // Update price
                DispatchQueue.main.async {
                    self.subButton.configuration?.title = "Subscribe for\n\(monthly.localizedPriceString) / month"
                    self.subButton.titleLabel?.textAlignment = .center
                    
                }
            }
        }
    }
}
