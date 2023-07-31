//
//  Coordinator.swift
//  Marquee
//
//  Created by Mark Wong on 3/10/2022.
//

import UIKit
import TelemetryClient

protocol Coordinator {
    func start(_ cds: CoreDataStack)
    func dismissCurrentView()
}


