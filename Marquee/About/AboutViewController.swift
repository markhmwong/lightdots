//
//  AboutViewController.swift
//  Ledify
//
//  Created by Mark Wong on 28/11/2022.
//

import UIKit
import MessageUI
extension AboutViewController: MFMailComposeViewControllerDelegate {
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        dismiss(animated: true, completion: nil)
    }
}

class AboutViewController: UIViewController {
    
    // contact
        // email
        // review
        // twitter
    private lazy var emailDescription: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.preferredFont(forTextStyle: .body)
        label.text = "Contact me by email"
        return label
    }()
    
    private lazy var emailButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(handleEmail), for: .touchDown)
        button.setTitle(Whizbang.emailToRecipient, for: .normal)
        button.tintColor = UIColor.textColor

        button.setTitleColor(.white.withAlphaComponent(0.7), for: .highlighted)
        if #available(iOS 15.0, *) {
            var config = UIButton.Configuration.bordered()
            config.cornerStyle = .capsule
            config.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { incoming in
                var outgoing = incoming
                outgoing.font = UIFont.preferredFont(forTextStyle: .caption1).with(weight: .bold)
                return outgoing
             }
            var bg = UIBackgroundConfiguration.clear()
            config.background = bg
            button.configuration = config
            button.layer.borderColor = UIColor.textColor.cgColor
            return button
        } else {
            // Fallback on earlier versions
//            button.setTitleColor(.black, for: .normal)
            return button
        }
    }()
    
    private lazy var followDescription: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.preferredFont(forTextStyle: .body)
        label.text = "Follow me on twitter"
        return label
    }()
    
    private lazy var twitterButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(handleTwitter), for: .touchDown)
        button.setTitle(Whizbang.twitter, for: .normal)
        button.tintColor = UIColor.textColor

        button.setTitleColor(.white.withAlphaComponent(0.7), for: .highlighted)
        if #available(iOS 15.0, *) {
            var config = UIButton.Configuration.bordered()
            config.cornerStyle = .capsule
            config.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { incoming in
                var outgoing = incoming
                outgoing.font = UIFont.preferredFont(forTextStyle: .caption1).with(weight: .bold)
                return outgoing
             }
            var bg = UIBackgroundConfiguration.clear()
            config.background = bg
            button.configuration = config
            button.layer.borderColor = UIColor.textColor.cgColor
            return button
        } else {
            // Fallback on earlier versions
//            button.setTitleColor(.black, for: .normal)
            return button
        }
    }()
    
    private lazy var reviewDescription: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.preferredFont(forTextStyle: .body)
        label.text = "Rate and review to support me"
        return label
    }()
    
    private lazy var reviewButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(handleReview), for: .touchDown)
        button.setTitle("Rate and Review", for: .normal)
        button.tintColor = UIColor.textColor

        button.setTitleColor(.white.withAlphaComponent(0.7), for: .highlighted)
        
        if #available(iOS 15.0, *) {
            var config = UIButton.Configuration.bordered()
            config.cornerStyle = .capsule
            config.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { incoming in
                var outgoing = incoming
                outgoing.font = UIFont.preferredFont(forTextStyle: .caption1).with(weight: .bold)
                return outgoing
             }
            var bg = UIBackgroundConfiguration.clear()
            config.background = bg
            button.configuration = config
            button.contentHorizontalAlignment = .center
            button.layer.borderColor = UIColor.textColor.cgColor
            return button
        } else {
            // Fallback on earlier versions
            return button
        }
    }()
    
    override func loadView() {
        super.loadView()
        self.view.backgroundColor = UIColor.background
        
        self.view.addSubview(twitterButton)
        self.view.addSubview(followDescription)
        self.view.addSubview(reviewButton)
        self.view.addSubview(reviewDescription)
        self.view.addSubview(emailButton)
        self.view.addSubview(emailDescription)



        twitterButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        twitterButton.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        followDescription.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        followDescription.bottomAnchor.constraint(equalTo: twitterButton.topAnchor, constant: -10).isActive = true
        
        reviewDescription.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        reviewDescription.topAnchor.constraint(equalTo: twitterButton.bottomAnchor, constant: 10).isActive = true

        reviewButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        reviewButton.topAnchor.constraint(equalTo: reviewDescription.bottomAnchor, constant: 10).isActive = true
        
        emailDescription.topAnchor.constraint(equalTo: reviewButton.bottomAnchor, constant: 20).isActive = true
        emailDescription.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        emailButton.topAnchor.constraint(equalTo: emailDescription.bottomAnchor, constant: 10).isActive = true
        emailButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
    }
    
}


extension AboutViewController {
    @objc func handleTwitter() {
        let productURL = URL(string: "https://www.twitter.com/_whizbangapps")!
        let components = URLComponents(url: productURL, resolvingAgainstBaseURL: false)
        
        guard let writeReviewURL = components?.url else {
            return
        }
        
        UIApplication.shared.open(writeReviewURL)
    }
    
    @objc func handleReview() {
        let productURL = URL(string: Whizbang.appStoreUrl)!
        var components = URLComponents(url: productURL, resolvingAgainstBaseURL: false)
        
        components?.queryItems = [
            URLQueryItem(name: "action", value: "write-review")
        ]
        
        guard let writeReviewURL = components?.url else {
            return
        }
        
        UIApplication.shared.open(writeReviewURL)
    }
    
    @objc func handleEmail() {
        let mail: MFMailComposeViewController? = MFMailComposeViewController(nibName: nil, bundle: nil)
        guard let mailVc = mail else {
            return
        }
        
        mailVc.mailComposeDelegate = self
        mailVc.setToRecipients([Whizbang.emailToRecipient])
        mailVc.setSubject(Whizbang.emailSubject)
        
        mailVc.setMessageBody(Whizbang.emailBody, isHTML: true)
        
        self.present(mailVc, animated: true, completion: nil)

    }
}
