//
//  ProCoordinator.swift
//  Marquee
//
//  Created by Mark Wong on 27/10/2022.
//

import UIKit

class ProCoordinator: NSObject, Coordinator {
    func dismissCurrentView() {
        self.navigationController.dismiss(animated: true)
    }
    
    var navigationController: UINavigationController
    
    var childNav: UINavigationController! = nil
    
    var rootViewController: ProViewController! = nil
        
    private var cds: CoreDataStack! = nil
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        super.init()
    }
    
    func start(_ cds: CoreDataStack) {
        self.cds = cds
        let vm = ProViewModel(cds: cds)
        self.rootViewController = ProViewController(vm: vm, coordinator: self)
        self.childNav = UINavigationController(rootViewController: self.rootViewController)
        navigationController.present(self.childNav, animated: true)
    }
    
    func showOtherPlans() {
        let c = OtherPlanCoordinator(nav: self.childNav)
        c.start(self.cds)

    }
}

class OtherPlanViewModel: NSObject {
    
    
    private var cds: CoreDataStack
    
    init(cds: CoreDataStack) {
        self.cds = cds
        super.init()
    }
    
}

class OtherPlanViewController: UIViewController {
    
    private var vm: OtherPlanViewModel
    
    private var coordinator: OtherPlanCoordinator
    
    init(vm: OtherPlanViewModel, coordinator: OtherPlanCoordinator) {
        self.vm = vm
        self.coordinator = coordinator
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

class OtherPlanCoordinator: NSObject, Coordinator {
    private var nav: UINavigationController
    
    init(nav: UINavigationController) {
        self.nav = nav
        super.init()
    }
    
    func start(_ cds: CoreDataStack) {
        let vm = OtherPlanViewModel(cds: cds)
        let vc = OtherPlanViewController(vm: vm, coordinator: self)
        self.nav.present(vc, animated: true)
    }
    
    func dismissCurrentView() {
        self.nav.dismiss(animated: true)
    }
    
}
