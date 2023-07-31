//
//  BackgroundPropertiesViewController.swift
//  Marquee
//
//  Created by Mark Wong on 7/10/2022.
//

import UIKit

class BackgroundPropertiesViewController: UICollectionViewController {

    private var vm: BackgroundPropertiesViewModel
    
    private var coordinator: BackgroundEditingCoordinator
    
    init(vm: BackgroundPropertiesViewModel, coordinator: BackgroundEditingCoordinator) {
        self.vm = vm
        self.coordinator = coordinator
        super.init(collectionViewLayout: UICollectionViewLayout().createCollectionViewLayout(itemSpace: .zero, groupSpacing: .zero, cellHeight: NSCollectionLayoutDimension.fractionalHeight(0.13)))
        self.collectionView.allowsMultipleSelection = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let i = LedOptions.shared.loadSelectedBackground()
        DispatchQueue.main.async {
            self.collectionView.selectItem(at: IndexPath.init(item: 0, section: i.rawValue), animated: true, scrollPosition: .centeredHorizontally)
//            self.collectionView(self.collectionView, didSelectItemAt: IndexPath.init(item: 0, section: i.rawValue))
        }
    }
    
    override func loadView() {
        super.loadView()
        view.backgroundColor = .clear
        vm.configureDataSource(collectionView: collectionView, coordinator: coordinator)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.default.post(name: .optionsEnableKeyboard, object: nil, userInfo: nil)
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //update settings
        if let _ = collectionView.cellForItem(at: indexPath) as? BackgroundPropertyCell {
            if let b = BackgroundProperties.init(rawValue: indexPath.section) {
                if b != .solid {
                    // if not pro, block and reselect solid background
                    if !SubscriptionService.shared.proStatus() {
                        coordinator.showProPurchase()
                        collectionView.deselectItem(at: indexPath, animated: true)
                        collectionView.selectItem(at: IndexPath(item: 0, section: 0), animated: true, scrollPosition: .top)
                        LedOptions.shared.updateSelectedBackground(value: .solid)
                    } else {
                        // register choice
                        LedOptions.shared.updateSelectedBackground(value: b)
                    }
                } else {
                    // register choice
                    LedOptions.shared.updateSelectedBackground(value: b)
                }
                
            }
        }
    }
}
