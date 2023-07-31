//
//  TextShadowViewController.swift
//  Marquee
//
//  Created by Mark Wong on 18/10/2022.
//

import UIKit

class ShadowViewController: UICollectionViewController {
    
    private var vm: ShadowViewModel
    
    private var coordinator: TextShadowCoordinator
    
    init(vm: ShadowViewModel, coordinator: TextShadowCoordinator) {
        self.vm = vm
        self.coordinator = coordinator
        super.init(collectionViewLayout: UICollectionViewLayout().createCollectionViewLayout(itemSpace: .zero, groupSpacing: .zero, cellHeight: NSCollectionLayoutDimension.fractionalHeight(0.13)))
        self.collectionView.allowsMultipleSelection = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        view.backgroundColor = .background
        vm.configureDataSource(collectionView: collectionView, coordinator: coordinator)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let selectedShadow = LedOptions.shared.loadShadowType()
        collectionView.selectItem(at: IndexPath(item: 0, section: selectedShadow.rawValue), animated: true, scrollPosition: .top)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.default.post(name: .optionsEnableKeyboard, object: nil, userInfo: nil)
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let ts = TextShadow.init(rawValue: indexPath.section)
        switch ts {
        case .shadow:
            if SubscriptionService.shared.proStatus() {
                LedOptions.shared.updateShadowType(value: ts?.rawValue ?? 0)
            } else {
                coordinator.showProPurchase()
                // reset back to off
                collectionView.selectItem(at: IndexPath(item: 0, section: 0), animated: true, scrollPosition: .top)
                LedOptions.shared.updateShadowType(value: TextShadow.off.rawValue)
            }
        case .off:
            LedOptions.shared.updateShadowType(value: ts?.rawValue ?? 0)
        case .none:
            ()
        }
    }
}

enum TextShadow: Int, CaseIterable {
//    case phased
    case off
    case shadow
//    case shifted
    
    var name: String {
        switch self {
        case .off:
            return "Off"
        case .shadow:
            return "solid shadow"
        }
    }
}

