//
//  MainCoordinator.swift
//  Ledify
//
//  Created by Mark Wong on 2/1/2023.
//

import UIKit
import TelemetryClient

class MainCoordinator: NSObject, Coordinator {

    func dismissCurrentView() {
        self.navigationController.dismiss(animated: true)
    }
    
    var navigationController: UINavigationController
    
    var rootViewController: LedViewController? = nil
    
    private var cds: CoreDataStack! = nil
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        super.init()
    }
    
    func start(_ cds: CoreDataStack) {
        
        self.cds = cds
        let vm = LedViewModel(cds: cds)
        let vc = LedViewController(vm: vm, coordinator: self)
        rootViewController = vc
        TelemetryManager.send(TelemetryManager.Signal.appDidBegin.rawValue)
        self.navigationController = UINavigationController(rootViewController: vc)
        self.navigationController.tabBarItem.title = "Scrolling Banner"
        navigationController.tabBarItem.image = UIImage(systemName: "questionmark.square.dashed")
        navigationController.navigationBar.isHidden = true
    }
    
    func showOptions() {
        guard let cds = self.cds else { return }
        let coordinator = OptionsCoordinator(navigationController: navigationController)
        coordinator.start(cds)
    }
    
    func showPro() {
        guard let cds = self.cds else { return }
        let coordinator = ProCoordinator(navigationController: navigationController)
        coordinator.start(cds)
    }
    
    func showMessages() {
        guard let cds = self.cds else { return }
        
    }
    
    func showAbout() {
        let vc = AboutViewController()
        navigationController.present(vc, animated: true)
    }
}
