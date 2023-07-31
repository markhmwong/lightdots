//
//  StaticBannerCoordinator.swift
//  Ledify
//
//  Created by Mark Wong on 2/1/2023.
//

import UIKit

class StaticBannerCoordinator: NSObject, Coordinator {

    func dismissCurrentView() {
        self.navigationController?.dismiss(animated: true)
    }
    
    var navigationController: UINavigationController? = nil
    
    var rootViewController: StaticBannerViewController? = nil
    
    private var cds: CoreDataStack! = nil
    
    func start(_ cds: CoreDataStack) {
        
        self.cds = cds
        let vm = StaticBannerViewModel(cds: cds)
        let vc = StaticBannerViewController()
        rootViewController = vc
        self.navigationController = UINavigationController(rootViewController: vc)
        self.navigationController?.tabBarItem.title = "Static Banner"
        self.navigationController?.tabBarItem.image = UIImage(systemName: "questionmark.square.dashed")
        self.navigationController?.navigationBar.isHidden = true
    }
}


