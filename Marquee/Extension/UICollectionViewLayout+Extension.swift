//
//  UICollectionViewLayout+Extension.swift
//  Marquee
//
//  Created by Mark Wong on 4/10/2022.
//

import UIKit

@available(iOS 16.0, *)
@available(iOS 16.0, *)
extension UICollectionViewLayout {
    
    func horizontalMenuLayout(header: Bool = false, elementKind: String = "", itemSpace: NSDirectionalEdgeInsets, groupSpacing: NSDirectionalEdgeInsets, cellHeight: NSCollectionLayoutDimension = .absolute(60.0), sectionSpacing: NSDirectionalEdgeInsets = NSDirectionalEdgeInsets(top: 10, leading: 0, bottom: 0, trailing: 0)) -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { (sectionIndex, layoutEnvironment) -> NSCollectionLayoutSection? in
            //            let estimatedHeight: CGFloat = cellHeight // cell height
            
            let size = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: cellHeight)
            
            let item = NSCollectionLayoutItem(layoutSize: size)
            item.edgeSpacing = NSCollectionLayoutEdgeSpacing(leading: NSCollectionLayoutSpacing.fixed(0), top: NSCollectionLayoutSpacing.fixed(0), trailing: NSCollectionLayoutSpacing.fixed(0), bottom: NSCollectionLayoutSpacing.fixed(0))
            item.contentInsets = itemSpace
            
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.25), heightDimension: .fractionalHeight(1.0))
            

            if #available(iOS 16.0, *) {
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, repeatingSubitem: item, count: 1)
                group.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
                group.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
                group.interItemSpacing = NSCollectionLayoutSpacing.fixed(0)
                let section = NSCollectionLayoutSection(group: group)
                section.orthogonalScrollingBehavior = .continuousGroupLeadingBoundary
                
                section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
                if (header && sectionIndex == 0 && elementKind != "") {
                    let headerFooterSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(80.0))
                    let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerFooterSize, elementKind: elementKind, alignment: .top)
                    section.boundarySupplementaryItems = [header]
                }
                return section
            } else {
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
                // Fallback on earlier versions
                let section = NSCollectionLayoutSection(group: group)
                section.orthogonalScrollingBehavior = .continuousGroupLeadingBoundary
                
                section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
                if (header && sectionIndex == 0 && elementKind != "") {
                    let headerFooterSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(80.0))
                    let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerFooterSize, elementKind: elementKind, alignment: .top)
                    section.boundarySupplementaryItems = [header]
                }
                return section
            }

    
        }
        
        return layout
    }
    
    func createCollectionViewList(appearance: UICollectionLayoutListConfiguration.Appearance, background: UIColor = UIColor.clear, swipe: @escaping UICollectionLayoutListConfiguration.SwipeActionsConfigurationProvider) -> UICollectionViewCompositionalLayout {
        var listConfig = UICollectionLayoutListConfiguration(appearance: appearance)
        listConfig.showsSeparators = false
        listConfig.backgroundColor = background
        listConfig.trailingSwipeActionsConfigurationProvider = swipe

        return UICollectionViewCompositionalLayout.list(using: listConfig)
    }
    
    func createCollectionViewListWithSwipe(appearance: UICollectionLayoutListConfiguration.Appearance, swipe: @escaping UICollectionLayoutListConfiguration.SwipeActionsConfigurationProvider) -> UICollectionViewCompositionalLayout {
        var listConfig = UICollectionLayoutListConfiguration(appearance: appearance)
        listConfig.showsSeparators = false
        listConfig.headerMode = .none
        listConfig.headerTopPadding = 10.0
        listConfig.trailingSwipeActionsConfigurationProvider = swipe
        return UICollectionViewCompositionalLayout.list(using: listConfig)
    }
    
    func createCollectionViewLayout(header: Bool = false, elementKind: String = "", itemSpace: NSDirectionalEdgeInsets, groupSpacing: NSDirectionalEdgeInsets, cellHeight: NSCollectionLayoutDimension = .fractionalHeight(0.33), sectionSpacing: NSDirectionalEdgeInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 10, trailing: 0)) -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { (sectionIndex, layoutEnvironment) -> NSCollectionLayoutSection? in
            
            let size = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
            
            let item = NSCollectionLayoutItem(layoutSize: size)
            item.edgeSpacing = NSCollectionLayoutEdgeSpacing(leading: NSCollectionLayoutSpacing.fixed(0), top: NSCollectionLayoutSpacing.fixed(5), trailing: NSCollectionLayoutSpacing.fixed(0), bottom: NSCollectionLayoutSpacing.fixed(0))
            item.contentInsets = itemSpace
            
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: cellHeight)

            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, repeatingSubitem: item, count: 1)
            group.contentInsets = groupSpacing
            group.interItemSpacing = NSCollectionLayoutSpacing.fixed(5)
            
            let section = NSCollectionLayoutSection(group: group)
            section.contentInsets = sectionSpacing
            section.orthogonalScrollingBehavior = .none
            
            return section
        }
        
        return layout
    }
    
}
