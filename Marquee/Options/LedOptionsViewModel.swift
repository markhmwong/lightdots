//
//  LedOptionsViewModel.swift
//  Marquee
//
//  Created by Mark Wong on 3/10/2022.
//

import UIKit

class LedOptionsViewModel: NSObject {
    
    enum Section: CaseIterable {
        case message
        case textProperties
        case backgroundProperties
        case ledProperties
    }
    
    struct OptionItem: Hashable {
        var id: UUID = UUID()
        var name: String
        var section: LedOptionsViewModel.Section
    }
    
    internal var cds: CoreDataStack
    
    private var diffableDataSource: UICollectionViewDiffableDataSource<Section, OptionItem>! = nil
    
    init(cds: CoreDataStack) {
        self.cds = cds
        super.init()
    }

    func configureCellRegistration() -> UICollectionView.CellRegistration<OptionsTextCell, OptionItem> {
        let cell = UICollectionView.CellRegistration<OptionsTextCell, OptionItem> { (cell, indexPath, item) in
            cell.item = item
        }
        return cell
    }
    
    func configureDataSource(collectionView: UICollectionView) {

        let cellRego = self.configureCellRegistration()
        
        diffableDataSource = UICollectionViewDiffableDataSource<Section, OptionItem>(collectionView: collectionView) { (collectionView, indexPath, item) -> UICollectionViewCell? in
            // redefine cells here
            let cell = collectionView.dequeueConfiguredReusableCell(using: cellRego, for: indexPath, item: item)
            return cell
        }
        diffableDataSource.apply(configureSnapshot())
    }
    
    func configureSnapshot() -> NSDiffableDataSourceSnapshot<Section, OptionItem> {
        var snapshot = NSDiffableDataSourceSnapshot<Section, OptionItem>()
        snapshot.appendSections(Section.allCases)
        // add items
        let string = OptionItem(name: "String", section: .message)
        snapshot.appendItems([string], toSection: string.section)
        return snapshot
    }
    
    func updateIdleScreen(state: Bool) {
        LedOptions.shared.updateIdle(state: state)
        UIApplication.shared.isIdleTimerDisabled = state
    }
}



