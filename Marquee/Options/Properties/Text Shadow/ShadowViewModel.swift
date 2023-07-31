//
//  TextShadowViewModel.swift
//  Marquee
//
//  Created by Mark Wong on 18/10/2022.
//

import UIKit

class ShadowViewModel: NSObject {
    
    struct TextShadowItem: Hashable {
        var id: UUID = UUID()
        var name: String
        var section: TextShadow

    }
    
    private var diffableDataSource: UICollectionViewDiffableDataSource<TextShadow, TextShadowItem>! = nil
    
    private func configureShadowCellRegistration() -> UICollectionView.CellRegistration<TextShadowCell, TextShadowItem> {
        let cellConfig = UICollectionView.CellRegistration<TextShadowCell, TextShadowItem> { (cell, indexPath, item) in
            cell.item = item
        }
        return cellConfig
    }
    
    func configureDataSource(collectionView: UICollectionView, coordinator: TextShadowCoordinator) {
        let shadowRego = self.configureShadowCellRegistration()
        
        diffableDataSource = UICollectionViewDiffableDataSource<TextShadow, TextShadowItem>(collectionView: collectionView) { (collectionView, indexPath, item) -> UICollectionViewCell? in
            
            if indexPath.section == TextShadow.shadow.rawValue {
                let cell = collectionView.dequeueConfiguredReusableCell(using: shadowRego, for: indexPath, item: item)
                cell.item = item
                cell.coordinator = coordinator
                return cell
            } else {
                // no shadow
                let cell = collectionView.dequeueConfiguredReusableCell(using: shadowRego, for: indexPath, item: item)
                cell.item = item
                cell.coordinator = coordinator
                return cell
            }
        }
        diffableDataSource.apply(configureSnapshot())
    }

    private func createItems() -> [TextShadowItem] {
        var items: [TextShadowItem] = []
        for (_, ts) in TextShadow.allCases.enumerated() {
            items.append(TextShadowItem(name: ts.name, section: ts))
        }
        return items
    }
    
    private func configureSnapshot() -> NSDiffableDataSourceSnapshot<TextShadow, TextShadowItem> {
        var snapshot = NSDiffableDataSourceSnapshot<TextShadow, TextShadowItem>()
        snapshot.appendSections(TextShadow.allCases)
        for bgp in self.createItems() {
            snapshot.appendItems([bgp], toSection: bgp.section)
        }
        return snapshot
    }
}
