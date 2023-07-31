//
//  SettingsViewController.swift
//  Marquee
//
//  Created by Mark Wong on 3/10/2022.
//

import UIKit
import TelemetryClient
import GoogleMobileAds

class LedOptionsViewController: UIViewController, UITextViewDelegate {
    
    private var resolution: UIBarButtonItem! = nil
    
    private var feedback: UIBarButtonItem! = nil
    
    private var vm: LedOptionsViewModel
    
    private var coordinator: OptionsCoordinator
    
    private var sv: UIStackView!
    
    private var  bannerView: GADBannerView!
    
    private var additionalOptions: UIBarButtonItem! = nil
    
    private lazy var messageView: UITextView = {
        let tf = UITextView(frame: .zero, textContainer: nil)
        tf.textColor = .white
        tf.isScrollEnabled = false
        tf.font = UIFont.preferredFont(forTextStyle: .title1).with(weight: .bold)
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.backgroundColor = UIColor.gray.withAlphaComponent(0.2)
        tf.textAlignment = .left
        tf.textColor = UIColor.textColor.inverted
        tf.layer.cornerRadius = 5.0
        tf.layer.borderColor = UIColor.gray.cgColor
        tf.layer.borderWidth = 0.0
        tf.text = "Add Text"
        tf.delegate = self
        tf.sizeToFit()
        return tf
    }()
    
    private lazy var countLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "0"
        label.textColor = UIColor.gray
        label.font = UIFont.preferredFont(forTextStyle: .caption1).with(weight: .bold)
        return label
    }()
    
    private lazy var textSize: UISlider = {
        let slider = UISlider(frame: .zero)
        slider.translatesAutoresizingMaskIntoConstraints = false
        return slider
    }()
    
    private var keyboardToolbar: UIToolbar! = nil
    
    // located in toolbar for keyboard
    private var textColor: UIAction! = nil
    
    private var allow = true
    
    
    init(vm: LedOptionsViewModel, coordinator: OptionsCoordinator) {
        self.vm = vm
        self.coordinator = coordinator
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addObservers() {
        NotificationCenter.default.addObserver(forName: .optionsEnableKeyboard, object: nil, queue: .main) { n in
            self.messageView.becomeFirstResponder()
            self.loadTextFormatting()
        }
    }
    
    override func loadView() {
        super.loadView()
        addObservers()

        view.backgroundColor = UIColor.background
        
        if SubscriptionService().proStatus() {
            title = "Pro"
        } else {
            title = "Standard"
        }
        
        let done = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(handleDone))
//        let cancel = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleCancel))
        let loadText = UIBarButtonItem(image: UIImage(systemName: "text.insert"), style: .plain, target: self, action: #selector(handleMessages))
        navigationItem.rightBarButtonItems = [done, loadText]
        
        messageView.becomeFirstResponder()
        
        view.addSubview(messageView)
        view.addSubview(countLabel)
        
        messageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant:view.bounds.height * 0.1).isActive = true
        messageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant:10).isActive = true
        messageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant:-10).isActive = true
        
        countLabel.topAnchor.constraint(equalTo: messageView.bottomAnchor).isActive = true
        countLabel.trailingAnchor.constraint(equalTo: messageView.trailingAnchor).isActive = true
        
        messageView.text = LedOptions.shared.loadMessage()
        self.countLabel.text = "\(messageView.text.count)"
        self.loadTextFormatting()
        self.buildToolbar()
        self.setupAd()
        TelemetryManager.send(TelemetryManager.Signal.bannerOptionsDidShow.rawValue)

    }
    
    func setupAd() {
        if !SubscriptionService().proStatus() {
            // setup ad banner
            bannerView = GADBannerView(adSize: GADAdSizeBanner)
            bannerView.translatesAutoresizingMaskIntoConstraints = false
            bannerView.rootViewController = self
            bannerView.adUnitID = AdDelivery.UnitId
            view.addSubview(bannerView)
            
            bannerView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
            bannerView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
            bannerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
            
            bannerView.load(GADRequest())
        }
    }
    
    func keyboardWillShow(sender: NSNotification) {
        self.view.frame.origin.y -= 150
    }
    
    func loadTextFormatting() {
        
        messageView.text = LedOptions.shared.loadMessage()
        
        let font = LedOptions.shared.loadFont()

        messageView.font = UIFont(name: font.name, size: messageView.font?.pointSize ?? 8.0)
        
        // BOLD
        if LedOptions.shared.loadBold() {
            messageView.font = messageView.font!.with(.traitBold)
        } else {
            messageView.font = messageView.font!.without(.traitBold)
        }
        
        // ITALIC
        if LedOptions.shared.loadItalic() {
            messageView.font = messageView.font!.with(.traitItalic)
        } else {
            messageView.font = messageView.font!.without(.traitItalic)
        }
        
        let attributedText = NSMutableAttributedString(string: messageView.text)

        // UNDERLINE
        if LedOptions.shared.loadUnderline() {
            attributedText.addAttributes([NSAttributedString.Key.foregroundColor: LedOptions.shared.loadFontColour(), .font: messageView.font!, .underlineStyle: NSUnderlineStyle.single.rawValue], range: NSRange(location: 0, length: attributedText.length))
        } else {
            attributedText.addAttributes([NSAttributedString.Key.foregroundColor: LedOptions.shared.loadFontColour(), .font: messageView.font!], range: NSRange(location: 0, length: attributedText.length))
        }
        
        attributedText.addAttributes([NSAttributedString.Key.foregroundColor: LedOptions.shared.loadFontColour()], range: NSRange(location: 0, length: attributedText.length))
        
        // Apply attributes to UI
        self.messageView.attributedText = attributedText
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.post(name: .savedOptions, object: nil, userInfo: nil)
    }
    
    @objc func handleCancel() {
        coordinator.dismissCurrentView()
    }
    
    @objc func handleDone() {
        coordinator.dismissCurrentView()
        let sanitize = messageView.text.trim()
        LedOptions.shared.updateMessage(string: sanitize)
    }
}

/*
 
 MARK: Text view limit
 
 */

extension LedOptionsViewController {
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let length = textView.text.count
        self.countLabel.text = "\(length)"

        let currentString = (textView.text ?? "") as NSString
        let newString = currentString.replacingCharacters(in: range, with: text)
        // update the count limitation label
        if (newString.count >= 60) {
            self.countLabel.textColor = .systemOrange
        } else {
            self.countLabel.textColor = .systemGray
        }
        
        LedOptions.shared.updateMessage(string: newString)
        return newString.count <= MessageRestrictions.name.rawValue
    }
}

/*
 
    MARK: Colour Picker
 
 */
extension LedOptionsViewController: UIColorPickerViewControllerDelegate {
    
    func colorPickerViewControllerDidFinish(_ viewController: UIColorPickerViewController) {
        let color = viewController.selectedColor
        LedOptions.shared.updateFontColour(hexColor: color.hexStringFromColor())
        
        textColor.image?.withTintColor(color)
        self.loadTextFormatting()
    }
    
    func colorPickerViewControllerDidSelectColor(_ viewController: UIColorPickerViewController) {
        let color = viewController.selectedColor
        LedOptions.shared.updateFontColour(hexColor: color.hexStringFromColor())
        
        textColor.image?.withTintColor(color)
        self.loadTextFormatting()
    }
    
}

/*
 
 MARK: Toolbar
 
 */
extension LedOptionsViewController {
    
    func buildToolbar() {
        // Text Properties
        
        self.keyboardToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 44))
        let fontMenuImage = UIImage(systemName: "textformat.size")
        let textProperties = UIAction(title: "Properties", image: UIImage(systemName: "bold.italic.underline")) { action in
            self.handleTextProperties()
        }
        
        let textShadow = UIAction(title: "Shadow", image: nil, state: .off, handler: { (action) in
            self.coordinator.showTextShadowProperties()
        })
        self.textColor = UIAction(title: "Text color", image: UIImage(systemName: "pencil.tip")) { action in
            self.handleTextColour()
        }
        

        let fontContextMenu = UIMenu(title: "Font Menu", children: [textShadow, self.textColor, textProperties])
        let fontMenu = UIBarButtonItem(title: "", image: fontMenuImage, target: self, action: nil, menu: fontContextMenu)
                
        
        // Background Colour
        let backgroundColorImage = UIImage(systemName: "paintpalette.fill")
        let background = UIBarButtonItem(title: "", image: backgroundColorImage, target: self, action: nil, menu: self.buildBackgroundOptions())
//        let background = UIBarButtonItem(image: backgroundColorImage, style: .plain, target: self, action: #selector(handleBackgroundColor))
        
        let spacer = UIBarButtonItem.flexibleSpace()
                
        guard let feedbackImage = self.loadFeedbackImage() else { return }
        self.feedback = UIBarButtonItem(image: feedbackImage, style: .plain, target: self, action: #selector(handleFeedback))

        self.additionalOptions = UIBarButtonItem(title: "", image: UIImage(systemName: "ellipsis")!, target: self, action: nil, menu: self.buildAdditionalOptions())
        // finalise keyboard toolbar
        
        keyboardToolbar.setItems([spacer, fontMenu, spacer, background, spacer, additionalOptions, spacer], animated: false)
        messageView.inputAccessoryView = self.keyboardToolbar
    }
    
    func buildBackgroundOptions() -> UIMenu {
        let backgroundOption = UIAction(title: "Colour", image: UIImage(systemName: "paintbrush.fill")) { action in
            self.handleBackgroundColor()
        }
        
        let border = UIAction(title: "Border", image: UIImage(systemName: "square.dashed")) { action in
            self.handleLedBorder()
        }
        
        return UIMenu(title: "Background Options", children: [backgroundOption, border])
    }
    

    func buildAdditionalOptions() -> UIMenu {
        let ledShapeMenu = UIMenu(title: "LED Shape", options: .singleSelection, children: [
            UIDeferredMenuElement.uncached { completion in
                let actions = [
                    UIAction(title: "Circle", image: SubscriptionService().lockImage(), state: LedOptions.shared.loadLedShape() == .circle ? .on : .off, handler: { (action) in
                        LedOptions.shared.updateLedShape(shape: .circle)
                    }),
                    UIAction(title: "Diamond", image: SubscriptionService().lockImage(), state: LedOptions.shared.loadLedShape() == .diamond ? .on : .off, handler: { (action) in
                        if SubscriptionService.shared.proStatus() {
                            LedOptions.shared.updateLedShape(shape: .diamond)
                        } else {
                            self.coordinator.showProPurchase()
                        }
                        
                    }),
                    UIAction(title: "Square", image: nil, state: LedOptions.shared.loadLedShape() == .square ? .on : .off, handler: { (action) in
                        if SubscriptionService.shared.proStatus() {
                            LedOptions.shared.updateLedShape(shape: .square)
                        } else {
                            self.coordinator.showProPurchase()
                        }
                    })
                ]
                completion(actions)
            }
        ])
        
        let qualityMenu = UIMenu(title: "Quality", options: .singleSelection, children: [
            UIDeferredMenuElement.uncached { completion in
                let actions = [
                    UIAction(title: "HD", image: SubscriptionService().lockImage(), state: LedOptions.shared.loadResolution() == .hd ? .on : .off, handler: { (action) in
                        if SubscriptionService.shared.proStatus() {
                            LedOptions.shared.updateResolution(resolution: Resolution.hd.rawValue)
                        } else {
                            self.coordinator.showProPurchase()
                        }
                        
                    }),
                    UIAction(title: "SD", image: nil, state: LedOptions.shared.loadResolution() == .sd ? .on : .off, handler: { (action) in
                        LedOptions.shared.updateResolution(resolution: Resolution.sd.rawValue)
                    })
                ]
                completion(actions)
            }
        ])
        
        let hapticFeedback = UIMenu(title: "Haptic Feedback", options: .singleSelection, children: [
            UIDeferredMenuElement.uncached { completion in
                let actions = [
                    UIAction(title: "On", image: SubscriptionService.shared.lockImage(), state: LedOptions.shared.loadFeedback() == true ? .on : .off, handler: { (action) in
                        if SubscriptionService.shared.proStatus() {
                            LedOptions.shared.updateFeedback(state: true)
                        } else {
                            self.coordinator.showProPurchase()
                        }
                    }),
                    UIAction(title: "Off", image: nil, state: LedOptions.shared.loadFeedback() == false ? .on : .off, handler: { (action) in
                        LedOptions.shared.updateFeedback(state: false)
                    })
                ]
                completion(actions)
            }
        ])
    
        
        let saveMessage = UIAction(title: "Save", subtitle: "Stash message", image: SubscriptionService.shared.lockImage(), identifier: nil, discoverabilityTitle: nil, state: .off) { action in
            if SubscriptionService.shared.proStatus() {
                self.vm.cds.saveMessage(message: self.messageView.text)
            } else {
                self.coordinator.showProPurchase()
            }
        }
        
        let idle = UIMenu(title: "Idle Screen", options: .singleSelection, children: [
            UIDeferredMenuElement.uncached { completion in
                let actions = [
                    UIAction(title: "On", image: nil, state: LedOptions.shared.loadIdleTime() == true ? .on : .off, handler: { (action) in
                            UIApplication.shared.isIdleTimerDisabled = true
                            LedOptions.shared.updateIdle(state: UIApplication.shared.isIdleTimerDisabled)
                            self.vm.updateIdleScreen(state: UIApplication.shared.isIdleTimerDisabled)
                    }),
                    UIAction(title: "Off", image: nil, state: LedOptions.shared.loadIdleTime() == false ? .on : .off, handler: { (action) in
                        UIApplication.shared.isIdleTimerDisabled = false
                        self.vm.updateIdleScreen(state: UIApplication.shared.isIdleTimerDisabled)

                    })
                ]
                completion(actions)
            }
        ])
        
        
        return UIMenu(title: "Additional Options", children: [idle, qualityMenu, hapticFeedback, ledShapeMenu, saveMessage])
    }
    
    @objc func handleFeedback() {
        LedOptions.shared.updateFeedback(state: !LedOptions.shared.loadFeedback())
        guard let feedbackImage = self.loadFeedbackImage() else { return }
        self.feedback.image = feedbackImage
        
    }
    
    func loadFeedbackImage() -> UIImage? {
        if LedOptions.shared.loadFeedback() {
            TelemetryManager.send(TelemetryManager.Signal.feedbackDidEnable.rawValue)
            return UIImage(systemName: "iphone.radiowaves.left.and.right.circle.fill")
        } else {
            TelemetryManager.send(TelemetryManager.Signal.feedbackDidDisable.rawValue)
            return UIImage(systemName: "iphone.radiowaves.left.and.right.circle")
        }
    }
    
    @objc func handleTextShadow() {
        TelemetryManager.send(TelemetryManager.Signal.shadowDidShow.rawValue)
        messageView.resignFirstResponder()
        coordinator.showTextShadowProperties()
    }
    
    @objc func handleBackgroundColor() {
        TelemetryManager.send(TelemetryManager.Signal.backgroundDidShow.rawValue)
        messageView.resignFirstResponder()
        coordinator.showBackgroundProperties()
    }
    
    @objc func handleLedBorder() {
        TelemetryManager.send(TelemetryManager.Signal.borderLedDidShow.rawValue)
        messageView.resignFirstResponder()
        coordinator.showLedBorder()
    }
    
    @objc func handleTextProperties() {
        TelemetryManager.send(TelemetryManager.Signal.fontSettingsDidShow.rawValue)
        messageView.resignFirstResponder()
        coordinator.showTextProperties()
    }
    
    @objc func handleTextColour() {
        TelemetryManager.send(TelemetryManager.Signal.fontColourDidShow.rawValue)
        messageView.resignFirstResponder()
        coordinator.showTextColour()
    }
    
    @objc func handleMessages() {
        coordinator.showMessages()
    }
}
