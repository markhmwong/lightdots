//
//  OptionsCoordinator.swift
//  Marquee
//
//  Created by Mark Wong on 5/10/2022.
//

import UIKit




class OptionsCoordinator: NSObject, Coordinator {
    
    var navigationController: UINavigationController
    
    var childNav: UINavigationController! = nil
    
    var rootViewController: LedOptionsViewController! = nil
    
    private var cds: CoreDataStack! = nil
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        super.init()
    }
    
    func start(_ cds: CoreDataStack) {
        self.cds = cds
        let vm = LedOptionsViewModel(cds: cds)
        self.rootViewController = LedOptionsViewController(vm: vm, coordinator: self)
        self.childNav = UINavigationController(rootViewController: self.rootViewController)
        navigationController.present(self.childNav, animated: true)
        
    }
    
    func dismissCurrentView() {
        navigationController.dismiss(animated: true)
    }
    
    func showBackgroundProperties() {
        let coordinator = BackgroundEditingCoordinator(navigtaionController: self.childNav)
        coordinator.start(cds)
    }
    
    func showLedBorder() {
        let coordinator = LedBorderCoordinator(navigationController: self.childNav)
        coordinator.start(cds)
    }
    
    func showTextProperties() {
        let vc = TextPropertiesViewController()
        let nav = UINavigationController(rootViewController: vc)
        nav.title = "Text Properties"
        if #available(iOS 15.0, *) {
            if let sheet = nav.sheetPresentationController {
                sheet.detents = [.medium()]
                sheet.prefersScrollingExpandsWhenScrolledToEdge = true
                sheet.prefersGrabberVisible = true
                sheet.selectedDetentIdentifier = .medium
            }
        }
        self.childNav.present(nav, animated: true)
        
    }
    
    func showTextColour() {
        let vc = TextColourViewController()
        vc.delegate = self.rootViewController
        self.childNav.present(vc, animated: true)
    }
    
    func showTextShadowProperties() {
        let coordinator = TextShadowCoordinator(navigtaionController: self.childNav)
        coordinator.start(cds)

    }
    
    func showMessages() {

        if SubscriptionService.shared.proStatus() {
            let coordinator = MessagesCoordinator(navigationController: self.childNav)
            coordinator.start(cds)
        } else {
            self.showProPurchase()
        }
    }
    
    func showProPurchase() {
        let coordinator = ProCoordinator(navigationController: self.childNav)
        coordinator.start(cds)
    }
}
