//
//  BackgroundEditingCoordinator.swift
//  Marquee
//
//  Created by Mark Wong on 10/10/2022.
//

import UIKit

class BackgroundEditingCoordinator: NSObject, Coordinator {
    func dismissCurrentView() {
        self.navigationController.dismiss(animated: true)
    }
    
    //parent navigation
    private var navigationController: UINavigationController
    
    private var cds: CoreDataStack! = nil
    
    private var childNav: UINavigationController! = nil
    
    init(navigtaionController: UINavigationController) {
        self.navigationController = navigtaionController
        super.init()
    }
    
    func start(_ cds: CoreDataStack) {
        self.cds = cds
        let vc = BackgroundPropertiesViewController(vm: BackgroundPropertiesViewModel(), coordinator: self)
        self.childNav = UINavigationController(rootViewController: vc)
        if #available(iOS 15.0, *) {
            if let sheet = self.childNav.sheetPresentationController {
                sheet.detents = [.large()]
                sheet.prefersScrollingExpandsWhenScrolledToEdge = true
                sheet.prefersGrabberVisible = true
                sheet.selectedDetentIdentifier = .large

            }
        }
        self.navigationController.present(self.childNav, animated: true)
    }
    
    func showSolidOptions(vc: BackgroundSolidColourPicker) {
        self.childNav.present(vc, animated: true)
    }
    
    func showShimmerOptions() {
        if SubscriptionService.shared.proStatus() {
            let vc = ShimmerOptionsViewController()
            let nav = UINavigationController(rootViewController: vc)
            if #available(iOS 15.0, *) {
                if let sheet = nav.sheetPresentationController {
                    sheet.detents = [.medium(), .large()]
                    sheet.prefersScrollingExpandsWhenScrolledToEdge = true
                    sheet.prefersGrabberVisible = true
                    sheet.selectedDetentIdentifier = .medium
                }
            }
            self.childNav.present(nav, animated: true)
        } else {
            WarningBox.showProPayWall(self.navigationController, message: "Please purchase Pro to use the Shimmer background")
        }
    }
    
    func showFlashOptions() {
        let vc = FlashOptionsViewController()
        let nav = UINavigationController(rootViewController: vc)
        if #available(iOS 15.0, *) {
            if let sheet = nav.sheetPresentationController {
                sheet.detents = [.medium(), .large()]
                sheet.prefersScrollingExpandsWhenScrolledToEdge = true
                sheet.prefersGrabberVisible = true
                sheet.selectedDetentIdentifier = .medium
            }
        }
        self.childNav.present(nav, animated: true)
    }
    
    
    func showRainbowNoiseOptions() {
        let vc = RainbowNoiseViewController()
        let nav = UINavigationController(rootViewController: vc)
        if #available(iOS 15.0, *) {
            if let sheet = nav.sheetPresentationController {
                sheet.detents = [.medium(), .large()]
                sheet.prefersScrollingExpandsWhenScrolledToEdge = true
                sheet.prefersGrabberVisible = true
                sheet.selectedDetentIdentifier = .medium
            }
        }
        self.childNav.present(nav, animated: true)
    }
    
    func showNoiseOptions() {
        let vc = NoiseViewController()
        let nav = UINavigationController(rootViewController: vc)
        if #available(iOS 15.0, *) {
            if let sheet = nav.sheetPresentationController {
                sheet.detents = [.medium(), .large()]
                sheet.prefersScrollingExpandsWhenScrolledToEdge = true
                sheet.prefersGrabberVisible = true
                sheet.selectedDetentIdentifier = .medium
            }
        }
        self.childNav.present(nav, animated: true)
    }
    
    func showProPurchase() {
        let coordinator = ProCoordinator(navigationController: self.childNav)
        coordinator.start(cds)
    }
}
