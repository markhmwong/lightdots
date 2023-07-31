//
//  TabCoordinator.swift
//  Ledify
//
//  Created by Mark Wong on 2/1/2023.
//

import UIKit

enum TabBarMenu: Int {
    case kStaticBanner = 0
    case kScrollingBanner
}

/// The bottom tab bar
class MainTabCoordinator: NSObject, Coordinator {
    
    func dismissCurrentView() {
        // do nothing
    }
    
    var navigationController: UINavigationController?
    
    var childCoordinators: [Coordinator] = []
    
    var rootViewController: MainTabBarController?
    
    override init() {
        super.init()
    }
    
    func start(_ cds: CoreDataStack) {
        let tabController = MainTabBarController(coordinator: self, cds: cds)
        self.rootViewController = tabController
    }
    
    func showTimer() {
        rootViewController?.selectedIndex = 1
    }
}

class MainTabBarController: UITabBarController {
    
    private weak var coordinator: MainTabCoordinator?
    
    private var cds: CoreDataStack
    
//    private var bannerView: GADBannerView!
    
    init(coordinator: MainTabCoordinator, cds: CoreDataStack) {
        self.coordinator = coordinator
        self.cds = cds
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        self.tabBar.barTintColor = UIColor.black
//        self.view.backgroundColor = self.tabBar.barTintColor
        // main timer view second
        // settings view third
        
        viewControllers = [
            setupStaticBanner(),
            setupScrollingBanner()
        ]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        bannerView = GADBannerView(adSize: GADAdSizeBanner)
//        bannerView.translatesAutoresizingMaskIntoConstraints = false
//        view.addSubview(bannerView)
//        bannerView.bottomAnchor.constraint(equalTo: tabBar.safeAreaLayoutGuide.topAnchor).isActive = true
//        bannerView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
//        bannerView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
//        bannerView.adUnitID = AdmobDetails.adUnitId
//        bannerView.rootViewController = self
//        bannerView.load(GADRequest())
    }
    
    func setupScrollingBanner() -> UINavigationController {
        let nav = UINavigationController()
        let coordinator = MainCoordinator(navigationController: nav)
        coordinator.start(cds)
        return coordinator.navigationController
    }
    
    func setupStaticBanner() -> UINavigationController {
        let nav = UINavigationController()
        let coordinator = StaticBannerCoordinator()
        coordinator.start(cds)
        return coordinator.navigationController!
    }
}

