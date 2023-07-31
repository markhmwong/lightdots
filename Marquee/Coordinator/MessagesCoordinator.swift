//
//  MessagesCoordinator.swift
//  Marquee
//
//  Created by Mark Wong on 1/11/2022.
//

import UIKit

class MessagesCoordinator: NSObject, Coordinator {
    func dismissCurrentView() {
        self.navigationController.dismiss(animated: true)
    }
    
    var navigationController: UINavigationController
    
    var childNav: UINavigationController! = nil
    
    var rootViewController: MessagesViewController! = nil
        
    private var cds: CoreDataStack! = nil
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        super.init()
    }
    
    func start(_ cds: CoreDataStack) {
        self.cds = cds
        let vm = MessagesViewModel(cds: cds)
        self.rootViewController = MessagesViewController(vm: vm, coordinator: self)
        self.rootViewController.title = "Messages"
        
        // info button
        let infoButton = UIBarButtonItem(title: nil, image: UIImage(systemName: "info.circle"), target: self, action: #selector(handleInfoButton))
        
        // close button
        let closeButton = UIBarButtonItem(title: nil, image: UIImage(systemName: "xmark.circle"), target: self, action: #selector(handleCloseButton))

        self.rootViewController.navigationItem.rightBarButtonItem = infoButton
        self.rootViewController.navigationItem.leftBarButtonItem = closeButton
        
        self.childNav = UINavigationController(rootViewController: self.rootViewController)
        
        navigationController.present(self.childNav, animated: true)
    }
    
    @objc func handleCloseButton() {
        self.childNav.dismiss(animated: true)
    }
    
    @objc func handleInfoButton() {
        
    }
}
