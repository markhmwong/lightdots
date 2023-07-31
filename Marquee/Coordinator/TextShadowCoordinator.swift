//
//  TextShadowCoordinator.swift
//  Marquee
//
//  Created by Mark Wong on 18/10/2022.
//

import UIKit

class TextShadowCoordinator: NSObject, Coordinator {
    
    @objc
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
        let vc = ShadowViewController(vm: ShadowViewModel(), coordinator: self)
        self.childNav = UINavigationController(rootViewController: vc)
        childNav.title = "Text Shadows"
        if #available(iOS 15.0, *) {
            if let sheet = childNav.sheetPresentationController {
                sheet.detents = [.medium()]
                sheet.prefersScrollingExpandsWhenScrolledToEdge = true
                sheet.prefersGrabberVisible = true
                sheet.selectedDetentIdentifier = .medium
            }
        }
        self.navigationController.present(childNav, animated: true)
    }
    
    func showShadow() {
        let vc = StaticShadowViewController()
        vc.title = "Shadow Colour"
        vc.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(dismissCurrentView))
        let nav = UINavigationController(rootViewController: vc)

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
    
    func showProPurchase() {
        let coordinator = ProCoordinator(navigationController: self.childNav)
        coordinator.start(cds)
    }
}
