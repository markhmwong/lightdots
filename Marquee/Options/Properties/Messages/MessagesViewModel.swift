//
//  LoadTextViewModel.swift
//  Marquee
//
//  Created by Mark Wong on 24/10/2022.
//

import UIKit

class MessagesViewModel: NSObject {
    
    internal var cds: CoreDataStack
    
    internal var diffableDataSource: UICollectionViewDiffableDataSource<Section, MessageCore>! = nil
    
    private var mainFetcher: Fetcher<MessageCore>! = nil
    
    internal enum Section: Int, CaseIterable {
        case main
    }
    
    internal struct MessageItem: Hashable {
        var message: String
        var id: UUID = UUID()
        var section: Section
    }
    
    init(cds: CoreDataStack) {
        self.cds = cds
    }
}

/*
 
 MARK: CollectionView Methods
 
 */
extension MessagesViewModel {
    
    func messageCellRego() -> UICollectionView.CellRegistration<MessageCell, MessageCore> {
        let cellConfig = UICollectionView.CellRegistration<MessageCell, MessageCore> { (cell, indexPath, item) in
            cell.item = item
        }
        return cellConfig
    }
    
    func configureDataSource(collectionView: UICollectionView, fetcher: Fetcher<MessageCore>) {
        self.mainFetcher = fetcher
        let messageRego = self.messageCellRego()
        diffableDataSource = UICollectionViewDiffableDataSource<Section, MessageCore>(collectionView: collectionView) { (collectionView, indexPath, item) -> UICollectionViewCell? in
            let cell = collectionView.dequeueConfiguredReusableCell(using: messageRego, for: indexPath, item: item)
            cell.item = item
            return cell
        }
        
        diffableDataSource.apply(self.configureSnapshot())
    }
    
    private func configureSnapshot() -> NSDiffableDataSourceSnapshot<Section, MessageCore> {
        var snapshot = NSDiffableDataSourceSnapshot<Section, MessageCore>()
        snapshot.appendSections(Section.allCases)
        if let objs = mainFetcher.fetchRequestedObjects() {
            snapshot.appendItems(objs)
        }
        return snapshot
    }
}

class MessageCell: UICollectionViewListCell {

    var item: MessageCore? = nil {
        didSet {
            self.configureCell()
        }
    }

    func configureCell() {
        
        var config = UIListContentConfiguration.subtitleCell()
        config.text = item?.message ?? "Error text could be loaded"
        config.textProperties.color = UIColor.textColor
        self.contentConfiguration = config
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        self.item = nil
    }
}
