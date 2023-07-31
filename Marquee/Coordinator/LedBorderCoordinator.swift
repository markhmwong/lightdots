//
//  LedBorder.swift
//  LightDots
//
//  Created by Mark Wong on 22/11/2022.
//

import Foundation
import UIKit



class LedBorderCoordinator: NSObject, Coordinator {
    
    private var childNav: UINavigationController! = nil
    
    //parent
    private var navigationController: UINavigationController
    
    func start(_ cds: CoreDataStack) {
        let vm = LedBorderViewModel()
        let vc = LedBorderViewController(viewModel: vm, coordinator: self)
        self.childNav = UINavigationController(rootViewController: vc)
        self.navigationController.present(self.childNav, animated: true)
    }
    
    func dismissCurrentView() {
        self.navigationController.dismiss(animated: true)
    }
    
    


    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        super.init()
    }
    
}
