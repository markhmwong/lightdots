//
//  LoadTextViewController.swift
//  Marquee
//
//  Created by Mark Wong on 24/10/2022.
//

import UIKit
import CoreData

// lists available saved messages
// delete message
class MessagesViewController: UIViewController, NSFetchedResultsControllerDelegate, UICollectionViewDelegate {
    
    private var mainFetcher: Fetcher<MessageCore>! = nil
    
    private var vm: MessagesViewModel
    
    private var coordinator: MessagesCoordinator
    
    private lazy var collectionView: UICollectionView! = nil

    private lazy var fetchedResultsController: NSFetchedResultsController<MessageCore> = {
        // Create Fetch Request
        let fetchRequest: NSFetchRequest<MessageCore> = MessageCore.fetchRequest()

        // Configure Fetch Request
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "date", ascending: true)]
        // Create Fetched Results Controller
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.vm.cds.moc!, sectionNameKeyPath: nil, cacheName: nil)

        // Configure Fetched Results Controller
        fetchedResultsController.delegate = self
        return fetchedResultsController
    }()
    
    init(vm: MessagesViewModel, coordinator: MessagesCoordinator) {
        self.vm = vm
        self.coordinator = coordinator
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()

        view.backgroundColor = .background
        
        let listLayout = UICollectionViewLayout().createCollectionViewListWithSwipe(appearance: .insetGrouped) { [self] indexPath in
            
            if indexPath.section == MessagesViewModel.Section.main.rawValue {
                let actionHandler: UIContextualAction.Handler = { action, view, completion in
                    completion(true)
                    if let cell = self.collectionView?.cellForItem(at: indexPath) as? MessageCell {
                        if let item = cell.item {
                            WarningBox.showDeleteBox(title: "Delete the message?", message: "", vc: self) {
                                self.vm.cds.deleteMessage(obj: item)
                            }
                        }
                    }
                }

                let action = UIContextualAction(style: .destructive, title: "Done!", handler: actionHandler)
                action.image = UIImage(systemName: "trash")
                action.backgroundColor = .systemRed.adjust(by: 10)
                return UISwipeActionsConfiguration(actions: [action])
            } else {
                return nil
            }
        }
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: listLayout)
        collectionView.delegate = self
        collectionView.backgroundColor = .background
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(collectionView)
        
        collectionView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mainFetcher = Fetcher<MessageCore>(controller: fetchedResultsController)
        vm.configureDataSource(collectionView: self.collectionView, fetcher: mainFetcher)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //load message
        let cell = collectionView.cellForItem(at: indexPath) as! MessageCell
        
        let okayAction = UIAlertAction(title: "Okay", style: .destructive, handler: { action in
            if let messageCore = cell.item {
                messageCore.loadtoLedOptions()
            }
        })
        
        let deleteAction = UIAlertAction(title: "Cancel", style: .default, handler: { action in
            // do nothing. do not load any options
        })
        
        WarningBox.showCustomAlertBoxWithNoDefaults(title: "Hold Up!", message: "Would you like to load this message and its' configuration?", vc: self, additionalActions: [okayAction, deleteAction])
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.default.post(name: .optionsEnableKeyboard, object: nil, userInfo: nil)
    }
    
    deinit {
        print("deinit Message ViewController")
    }
}

extension MessagesViewController {
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChangeContentWith snapshot: NSDiffableDataSourceSnapshotReference) {
        guard let dds = self.vm.diffableDataSource else { return }
        let ss = snapshot as NSDiffableDataSourceSnapshot<MessagesViewModel.Section, NSManagedObjectID>
        let messageCoreArr = vm.cds.fetchMessages(objIds: ss.itemIdentifiers)
        
        var currentSnapshot = dds.snapshot()
        currentSnapshot.deleteSections([.main])
        currentSnapshot.appendSections([.main])
        currentSnapshot.appendItems(messageCoreArr, toSection: .main)
        dds.applySnapshotUsingReloadData(currentSnapshot)
    }
}
