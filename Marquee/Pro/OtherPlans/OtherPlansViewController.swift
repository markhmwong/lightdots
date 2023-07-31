//
//  OtherPlansViewController.swift
//  Marquee
//
//  Created by Mark Wong on 31/10/2022.
//

import UIKit

//show monthly, yearly and forever
class OtherPlansViewController: UIViewController {
    
    private lazy var monthlyButton: UIButton = {
        var config = UIButton.Configuration.filled()
        config.cornerStyle = .capsule
        config.title = "loading.."
        config.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { incoming in
            var outgoing = incoming
            outgoing.font = UIFont.preferredFont(forTextStyle: .body).with(weight: .bold)
            outgoing.foregroundColor = .textColor
            return outgoing
        }
        let button = UIButton(configuration: config)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.configuration?.contentInsets.top = 13
        button.configuration?.contentInsets.bottom = 13
        button.addTarget(self, action: #selector(handleMonthlySub), for: .touchDown)
        return button
    }()
    
    
    private lazy var yearlyButton: UIButton = {
        var config = UIButton.Configuration.filled()
        config.cornerStyle = .capsule
        config.title = "loading.."
        config.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { incoming in
            var outgoing = incoming
            outgoing.font = UIFont.preferredFont(forTextStyle: .body).with(weight: .bold)
            outgoing.foregroundColor = .textColor
            return outgoing
         }
        let button = UIButton(configuration: config)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.configuration?.contentInsets.top = 13
        button.configuration?.contentInsets.bottom = 13
        button.addTarget(self, action: #selector(handleYearlySub), for: .touchDown)
        return button
    }()
    
    
    private lazy var foreverButton: UIButton = {
        var config = UIButton.Configuration.filled()
        config.cornerStyle = .capsule
        config.title = "loading.."
        config.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { incoming in
            var outgoing = incoming
            outgoing.font = UIFont.preferredFont(forTextStyle: .body).with(weight: .bold)
            outgoing.foregroundColor = .textColor
            return outgoing
         }
        let button = UIButton(configuration: config)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.configuration?.contentInsets.top = 13
        button.configuration?.contentInsets.bottom = 13
        button.addTarget(self, action: #selector(handleForeverSub), for: .touchDown)
        return button
    }()
}

extension OtherPlansViewController {
    
    @objc func handleForeverSub() {
        
    }
    
    @objc func handleMonthlySub() {
        
    }
    
    @objc func handleYearlySub() {
        
    }
    
}

