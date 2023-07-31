//
//  Fetcher.swift
//  Marquee
//
//  Created by Mark Wong on 31/10/2022.
//

import CoreData

// MARK: - Fetcher
protocol FetchedDataProtocol {
    associatedtype T: NSFetchRequestResult
    var controller: NSFetchedResultsController<T> { get }
}

struct Fetcher<T: NSFetchRequestResult>: FetchedDataProtocol {
    var controller: NSFetchedResultsController<T>
    
    init(controller: NSFetchedResultsController<T>) {
        self.controller = controller
        self.initFetchedObjects()
    }
    
    func initFetchedObjects() {
        do {
            try self.controller.performFetch()
        } catch(let err) {
            print("\(err)")
        }
    }
    
    // Objects requested by the origina descriptors and predicates formed in the fetchedResultsController
    func fetchRequestedObjects() -> [T]? {
        return controller.fetchedObjects
    }
}
