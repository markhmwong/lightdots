//
//  ViewController.swift
//  Marquee
//
//  Created by Mark Wong on 18/9/2022.
//

import UIKit
import GoogleMobileAds

class LedViewController: UIViewController, GADBannerViewDelegate {
    
    internal var convertedTextImageView: UIImageView! = nil
    
    var outputImage: UIImage? = nil
    
    private var vm: LedViewModel
    
    internal var coordinator: MainCoordinator
    
    private lazy var watermark: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "LEDIFY"
        label.alpha = 0.4
        label.textColor = .systemGray
        label.font = UIFont.preferredFont(forTextStyle: .title1).with(weight: .bold)
        return label
    }()
    
    // debugging only
#if DEBUG
    lazy var scrollView: UIScrollView = {
        let view = UIScrollView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isScrollEnabled = true
        return view
    }()
#endif
    private lazy var optionOverlay: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        view.alpha = 0.0
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private var tapGesture: UITapGestureRecognizer! = nil
    
    lazy var optionsButton: UIButton = {
        var config = UIButton.Configuration.bordered()
        config.image = UIImage(systemName: "gearshape.fill")
        let button = UIButton(configuration: config)
        button.tintColor = .white
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(handleOptions), for: .touchDown)
        return button
    }()
    
    lazy var aboutButton: UIButton = {
        var config = UIButton.Configuration.bordered()
        config.image = UIImage(systemName: "info.circle.fill")
        let button = UIButton(configuration: config)
        button.tintColor = .white
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(handleAbout), for: .touchDown)
        return button
    }()
    
    lazy var proButton: UIButton = {
        var config = UIButton.Configuration.filled()
        config.title = "Buy Pro"
        config.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { incoming in
            var outgoing = incoming
            outgoing.font = UIFont.preferredFont(forTextStyle: .body).with(weight: .bold)
            outgoing.foregroundColor = .textColor
            return outgoing
        }
        let button = UIButton(configuration: config)
        button.setTitleColor(.black, for: .normal)
        button.tintColor = .black
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(handlePro), for: .touchDown)
        return button
    }()
    
    lazy var resetButton: UIButton = {
        var config = UIButton.Configuration.bordered()
        config.image = UIImage(systemName: "arrow.triangle.2.circlepath")
        let button = UIButton(configuration: config)
        button.tintColor = .white
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(handleReset), for: .touchDown)
        return button
    }()
    
    private var  bannerView: GADBannerView!
    
    internal var tickerView: LedTickerView! = nil
    
    
    init(vm: LedViewModel, coordinator: MainCoordinator) {
        self.vm = vm
        self.coordinator = coordinator
        super.init(nibName: nil, bundle: nil)
        tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func handleTap() {
        self.vm.overlayToggle(view: optionOverlay)
    }
    
    func setupObserver() {
        NotificationCenter.default.addObserver(forName: .savedOptions, object: nil, queue: .main) { n in
            self.restart()
            self.setupAd()
            //update buy pro button
            if SubscriptionService.shared.proStatus() {
                self.proButton.removeFromSuperview()
            }
        }
    }
    
    func debuggingImage(previewImage: UIImage) {
        //debugging
        convertedTextImageView = UIImageView(image: UIImage(cgImage: (previewImage.cgImage)!))
        convertedTextImageView.translatesAutoresizingMaskIntoConstraints = false
        convertedTextImageView.isHidden = vm.hideDebuggingImage
        
        self.view.addSubview(convertedTextImageView)
        convertedTextImageView.topAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        convertedTextImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
    }
    
    override func loadView() {
        super.loadView()
        setupObserver()
        view.backgroundColor = .clear
        self.view.addGestureRecognizer(tapGesture)
        
        // load properties
        let ledShape = LedOptions.shared.loadLedShape()
        let paddedString = self.vm.loadAndPadString() // actual message
        let fontAttributes = self.vm.loadTextFormatting()
        let borderColour = LedOptions.shared.loadBorderColor()
        let borderWidth = CGFloat(LedOptions.shared.loadBorderWidth())
        
        var shadowAttributes: [NSAttributedString.Key : Any]? = nil
        if LedOptions.shared.loadShadowType() != .off {
            shadowAttributes = self.vm.loadShadowFormatting()
        }
        
        self.vm.asciiEngine = AsciiEngine(message: paddedString, fontAttributes: fontAttributes, shadowAttributes: shadowAttributes)
        if let previewImage = UIImage.textToImageConverter(string: paddedString, fontAttributes: fontAttributes, shadowAttributes: shadowAttributes), let ae = vm.asciiEngine {
            
            let mapping = ae.imageToMapping(viewSize: view.bounds.size)
            
            debuggingImage(previewImage: previewImage)
            
            self.tickerView = LedTickerView(frame: view.frame, colorMapping: mapping, resolution: LedOptions.shared.loadResolution(), ledShape: ledShape, borderWidth: borderWidth, borderColour: borderColour, orientation: .landscape)
            let radians: CGFloat = CGFloat(atan2f(Float(tickerView.transform.b), Float(tickerView.transform.a)));
            let degrees: CGFloat = radians * (90 / Double.pi);
            let transform = CGAffineTransformMakeRotation((270 + degrees) * Double.pi/180)
            self.view.transform = transform
            self.view.addSubview(self.tickerView)
            
            
            self.tickerView.timer?.preferredFps = LedOptions.shared.loadScrollSpeed()
            

        }

        #if DEBUG
        self.view.addSubview(self.scrollView)
        
        self.scrollView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive = true
        self.scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        self.scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        self.scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        #endif
        
        self.setupOverlay()
        self.setupAd()
    }
    

    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        AppStoreReviewManager.requestReviewIfAppropriate()
    }
    /*
     
     MARK: Additional Views
     
     */
    private func setupOverlay() {
        self.view.addSubview(optionOverlay)
        optionOverlay.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        optionOverlay.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        optionOverlay.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        optionOverlay.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
        //        let radians: CGFloat = CGFloat(atan2f(Float(optionsButton.transform.b), Float(optionsButton.transform.a)));
        //        let degrees: CGFloat = radians * (90 / Double.pi);
        //        let transform = CGAffineTransformMakeRotation((90 + degrees) * Double.pi/180)
        //
        ////        optionsButton.transform = transform
        self.optionOverlay.addSubview(aboutButton)
        aboutButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 30).isActive = true
        aboutButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -90).isActive = true
        
        self.optionOverlay.addSubview(optionsButton)
        optionsButton.topAnchor.constraint(equalTo: aboutButton.topAnchor).isActive = true
        optionsButton.trailingAnchor.constraint(equalTo: aboutButton.leadingAnchor, constant: -10).isActive = true
        
        self.optionOverlay.addSubview(resetButton)
        resetButton.topAnchor.constraint(equalTo: optionsButton.topAnchor, constant: 0).isActive = true
        resetButton.trailingAnchor.constraint(equalTo: optionsButton.leadingAnchor, constant: -10).isActive = true

        self.setupProButton()
    }
    
    private func setupProButton() {
        if !SubscriptionService.shared.proStatus() {
            self.optionOverlay.addSubview(proButton)
            proButton.topAnchor.constraint(equalTo: resetButton.topAnchor, constant: 0).isActive = true
            proButton.trailingAnchor.constraint(equalTo: resetButton.leadingAnchor, constant: -30).isActive = true
        }
    }
    
    private func setupAd() {
        if !SubscriptionService.shared.proStatus() {
            self.view.addSubview(watermark)
            
            watermark.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20).isActive = true
            watermark.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -60).isActive = true
            
        }
        
        if !SubscriptionService.shared.proStatus() {

            // setup ad banner
            bannerView = GADBannerView(adSize: GADAdSizeBanner)
            bannerView.translatesAutoresizingMaskIntoConstraints = false
            bannerView.rootViewController = self
            bannerView.delegate = self
            bannerView.adUnitID = AdDelivery.UnitId
            view.addSubview(bannerView)
            
            bannerView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
            bannerView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
            bannerView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
            
            bannerView.load(GADRequest())
        }
    }
    
    func bannerView(_ bannerView: GADBannerView, didFailToReceiveAdWithError error: Error) {
        print("error \(error)")
    }
    
    func bannerViewDidReceiveAd(_ bannerView: GADBannerView) {
        
    }
}

/*
 
 MARK: Restart
 
*/

extension LedViewController {

    
    func restart() {
        self.vm.asciiEngine = nil
        self.tickerView.timer?.shutdownTimer()
        self.tickerView.timer = nil
        self.tickerView.removeFromSuperview()
        self.tickerView = nil
        // this may be nil if no ads are added to the view because the user is subscribed
        if bannerView != nil {
            self.bannerView.removeFromSuperview()
            self.bannerView = nil
        }

        
        let paddedString = self.vm.loadAndPadString() // pads string with spaces to leave a break at the end of the string before it recycles the string and scrolls again.
        let fontAttributes = self.vm.loadTextFormatting()
        let ledShape = LedOptions.shared.loadLedShape()
        let borderColour = LedOptions.shared.loadBorderColor()
        let borderWidth = CGFloat(LedOptions.shared.loadBorderWidth())
        
        var shadowAttributes: [NSAttributedString.Key : Any]? = nil
        if LedOptions.shared.loadShadowType() != .off {
            shadowAttributes = self.vm.loadShadowFormatting()
        }
        
        self.vm.asciiEngine = AsciiEngine(message: paddedString, fontAttributes: fontAttributes, shadowAttributes: shadowAttributes)
        if let ae = self.vm.asciiEngine {
            let mapping = ae.imageToMapping(viewSize: view.bounds.size)
            self.tickerView = LedTickerView(frame: view.frame, colorMapping: mapping, resolution: LedOptions.shared.loadResolution(), ledShape: ledShape, borderWidth: borderWidth, borderColour: borderColour, orientation: .landscape)
            view.addSubview(self.tickerView)
            view.bringSubviewToFront(optionOverlay)
            self.tickerView.timer?.preferredFps = LedOptions.shared.loadScrollSpeed()
        }
        self.setupAd()
    }
}
