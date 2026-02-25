//
//  CoreDataManager.swift
//  currencyConverter
//
//  Created by 손영빈 on 2/24/26.
//

import Foundation
import CoreData

class CoreDataManager {
    static let shared = CoreDataManager()
    
    private init() {}
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "currencyConverter")
        container.loadPersistentStores { _, error in
            if let error = error as NSError? {
                fatalError("CoreData loading Error: \(error)")
            }
        }
        return container
    }()
    
    func saveContext() {
        let context = persistentContainer.viewContext
        
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let error = error as NSError
                print("CoreData save Error: \(error)")
            }
        }
    }
}
