//
//  CoreDataManager.swift
//  currencyConverter
//
//  Created by t2025-m0143 on 2/24/26.
//

import CoreData

class CoreDataManager {
    // MARK: - Core Data stack
    lazy var persistentContainer: NSPersistentContainer = {
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
}

//MARK: CRUD
extension CoreDataManager {
    // 저장 - Create
    func saveBookMark(_ code: String) {
        let context = persistentContainer.viewContext
        guard let entity = NSEntityDescription.entity(forEntityName: BookMark.className, in: context) else { return }
        let bookMark = NSManagedObject(entity: entity, insertInto: context)
        bookMark.setValue(code, forKey: BookMark.Key.currencyCode)
        
        do {
            try context.save()
            print("북마크 저장 성공")
        } catch {
            print("북마크 저장 실패")
        }
    }
    
    // 불러오기 - Read
    func loadAllBookMark() -> [String]? {
        do {
            guard let bookMark = try persistentContainer.viewContext.fetch(BookMark.fetchRequest()) as? [NSManagedObject] else { return nil }
            
            let codes = bookMark.reduce(into: [String]()) {
                let code = $1.value(forKey: BookMark.Key.currencyCode) as? String ?? ""
                $0.append(code)
            }
            
            return codes
        } catch {
            print("데이터 불러오기 실패")
            return nil
        }
    }
    
    // 삭제 - Delete
    func deleteBookMark(_ code: String) {
        let context = persistentContainer.viewContext
        
        let fetchRequest = BookMark.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "currencyCode == %@", code)
        
        do {
            // fetchRequest 실행
            let result = try context.fetch(fetchRequest)
            
            // 결과 처리
            for data in result as [NSManagedObject] {
                // 삭제
                context.delete(data)
                print("삭제된 데이터: \(data)")
            }
            
            // 변경사항 저장
            try context.save()
            print("데이터 삭제 완료")
        } catch {
            print("데이터 삭제 실패: \(error)")
        }
    }
    
    func deleteAllBookMark() {
        let context = persistentContainer.viewContext
        
        let fetchRequest = BookMark.fetchRequest()
        
        do {
            // fetchRequest 실행
            let result = try context.fetch(fetchRequest)
            
            // 결과 처리
            for data in result as [NSManagedObject] {
                // 삭제
                context.delete(data)
                print("삭제된 데이터: \(data)")
            }
            
            // 변경사항 저장
            try context.save()
            print("데이터 삭제 완료")
        } catch {
            print("데이터 삭제 실패: \(error)")
        }
    }
}
