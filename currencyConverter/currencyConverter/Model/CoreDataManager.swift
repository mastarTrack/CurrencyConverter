//
//  CoreDataManager.swift
//  currencyConverter
//
//  Created by t2025-m0143 on 2/24/26.
//

import CoreData

class CoreDataManager {
    // MARK: - Core Data stack
    private lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "CurrencyModel")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    private var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
}

//MARK: Currency Data
extension CoreDataManager {
    // 환율 정보 저장
    func saveCurrencyData(_ rate: [Rate]) {
        guard let entity = NSEntityDescription.entity(forEntityName: CurrencyData.className, in: context) else { return }
        
        rate.forEach {
            let currencyData = NSManagedObject(entity: entity, insertInto: context)
            currencyData.setValue($0.currencyCode, forKey: CurrencyData.Key.currencyCode)
            currencyData.setValue($0.value, forKey: CurrencyData.Key.value)
            currencyData.setValue($0.bookMarked, forKey: CurrencyData.Key.bookMark)
            
            do {
                try context.save()
            } catch {
                print("환율 정보 저장 실패")
            }
        }
    }
    
    // 업데이트 날짜 저장
    func saveUpdateDate(lastUpdate: Date, nextUpdate: Date) {
        guard let entity = NSEntityDescription.entity(forEntityName: UpdateDate.className, in: context) else { return }
        let updateDate = NSManagedObject(entity: entity, insertInto: context)
        
        updateDate.setValue(lastUpdate, forKey: UpdateDate.Key.lastUpdate)
        updateDate.setValue(nextUpdate, forKey: UpdateDate.Key.nextUpdate)

        do {
            try context.save()
        } catch {
            print("환율 정보 저장 실패")
        }
    }
    
    // 환율 정보 불러오기
    func loadCurrencyData() -> [Rate]? {
        do {
            guard let currencyData = try context.fetch(CurrencyData.fetchRequest()) as? [NSManagedObject] else { return nil }
            if currencyData.isEmpty { return nil }
            
            let rates = currencyData.reduce(into: [Rate]()) {
                let code = $1.value(forKey: CurrencyData.Key.currencyCode) as! String
                let value = $1.value(forKey: CurrencyData.Key.value) as! Double
                let bookMark = $1.value(forKey: CurrencyData.Key.bookMark) as! Bool
                
                $0.append(Rate(currencyCode: code, value: value, bookMarked: bookMark))
            }
            
            return rates
        } catch {
            print("CurrencyData 불러오기 실패")
            return nil
        }
    }
    
    // 업데이트 날짜 불러오기
    func loadUpdateDate() -> (lastUpdate: Date, nextUpdate: Date)? {
        do {
            guard let updateDate = try context.fetch(UpdateDate.fetchRequest()) as? [NSManagedObject] else { return nil }
            if updateDate.isEmpty { return nil }
            
            let lastUpdate = updateDate[0].value(forKey: UpdateDate.Key.lastUpdate) as! Date
            let nextUpdate = updateDate[0].value(forKey: UpdateDate.Key.nextUpdate) as! Date
            
            return (lastUpdate, nextUpdate)
        } catch {
            print("UpdateDate 불러오기 실패")
            return nil
        }
    }
    
    // 북마크 업데이트
    func updateBookMark(of code: String, bookMarked: Bool) {
        let fetchRequest = CurrencyData.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "\(CurrencyData.Key.currencyCode) == %@", code)
        
        do {
            let result = try context.fetch(fetchRequest)
            
            if let target = result.first {
                target.setValue(bookMarked, forKey: CurrencyData.Key.bookMark)
                
                try context.save()
            }
        } catch {
            print("북마크 수정 실패")
        }
    }
}
