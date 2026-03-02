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
        if loadCurrencyData() != nil {
            updateCurrencyData(rate)
            return
        } else {
            guard let entity = NSEntityDescription.entity(forEntityName: CurrencyData.className, in: context) else { return }
            rate.forEach {
                let currencyData = NSManagedObject(entity: entity, insertInto: context)
                currencyData.setValue($0.currencyCode, forKey: CurrencyData.Key.currencyCode)
                currencyData.setValue($0.value, forKey: CurrencyData.Key.value)
                currencyData.setValue($0.bookMarked, forKey: CurrencyData.Key.bookMark)
                currencyData.setValue($0.fluctuation, forKey: CurrencyData.Key.fluctuation)
                
                do {
                    try context.save()
                } catch {
                    print("환율 정보 저장 실패")
                }
            }
        }
    }
    
    // 업데이트 날짜 저장
    func saveUpdateDate(lastUpdate: Date, nextUpdate: Date) {
        if loadUpdateDate() != nil {
            updateUpdateDate(lastUpdate: lastUpdate, nextUpdate: nextUpdate)
            return
        } else {
            guard let entity = NSEntityDescription.entity(forEntityName: UpdateDate.className, in: context) else { return }
            let updateDate = NSManagedObject(entity: entity, insertInto: context) // 만듦과 동시에 코어데이터에 값이 없는 상태로 저장됨
            
            updateDate.setValue(lastUpdate, forKey: UpdateDate.Key.lastUpdate)
            updateDate.setValue(nextUpdate, forKey: UpdateDate.Key.nextUpdate)
        }
        
        do {
            try context.save()
        } catch {
            print("환율 정보 저장 실패")
        }
    }
    
    // 마지막 화면 저장
    func saveVC(_ vc: String, data: Rate? = nil) {
        guard let entity = NSEntityDescription.entity(forEntityName: LastVC.className, in: context) else { print("no entity"); return }
        let code = data?.currencyCode
        
        if loadVC() != nil {
            updateLastVC(vc, code: code)
            return
        } else {
            let lastVC = NSManagedObject(entity: entity, insertInto: context)
            
            lastVC.setValue(vc, forKey: LastVC.Key.viewController)
            lastVC.setValue(code, forKey: LastVC.Key.currencyCode)
        }
        
        do {
            try context.save()
            print("마지막 화면 저장 성공")
        } catch {
            print("마지막 화면 저장 실패")
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
    
    func loadCurrencyCodeData(of code: String) -> Rate? {
        do {
            let fetchRequest = CurrencyData.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "\(CurrencyData.Key.currencyCode) == %@", code)
            
            guard let data = try context.fetch(fetchRequest) as? [NSManagedObject] else { return nil }
            if data.isEmpty { return nil }
            
            let code = data[0].value(forKey: CurrencyData.Key.currencyCode) as! String
            let value = data[0].value(forKey: CurrencyData.Key.value) as! Double
            let bookMark = data[0].value(forKey: CurrencyData.Key.bookMark) as! Bool
            let fluctuation = data[0].value(forKey: CurrencyData.Key.fluctuation) as! Double
            
            let rate = Rate(currencyCode: code, value: value, bookMarked: bookMark, fluctuation: fluctuation)
            
            return rate
        } catch {
            print("code currencyData 불러오기 실패")
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
    
    // 마지막 화면 불러오기
    func loadVC() -> (vc: String?, code: String?)? {
        do {
            guard let lastVC = try context.fetch(LastVC.fetchRequest()) as? [NSManagedObject] else { return nil }
            if lastVC.isEmpty { return nil }
            
            let vc = lastVC[0].value(forKey: LastVC.Key.viewController) as? String
            let code = lastVC[0].value(forKey: LastVC.Key.currencyCode) as? String
            
            return (vc, code)
        } catch {
            print("lastVC 불러오기 실패")
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
    
    // 업데이트 날짜 업데이트
    func updateUpdateDate(lastUpdate: Date, nextUpdate: Date) {
        do {
            let result = try context.fetch(UpdateDate.fetchRequest())
            guard !result.isEmpty else { return }
            
            if let target = result.first {
                target.setValue(lastUpdate, forKey: UpdateDate.Key.lastUpdate)
                target.setValue(nextUpdate, forKey: UpdateDate.Key.nextUpdate)
                
                try context.save()
            }
        } catch {
            print("업데이트 날짜 수정 실패")
        }
    }
    
    // 환율 정보 업데이트
    func updateCurrencyData(_ rate: [Rate]) {
        do {
            let result = try context.fetch(CurrencyData.fetchRequest())
            guard result.count == rate.count else {
                print("환율 정보 수 불일치")
                return
            }
            
            for i in result.indices {
                result[i].setValue(rate[i].currencyCode, forKey: CurrencyData.Key.currencyCode)
                result[i].setValue(rate[i].value, forKey: CurrencyData.Key.value)
                result[i].setValue(rate[i].bookMarked, forKey: CurrencyData.Key.bookMark)
                result[i].setValue(rate[i].fluctuation, forKey: CurrencyData.Key.fluctuation)
            }

            try context.save()
        } catch {
            print("환율 정보 수정 실패")
        }

    }
    
    // 마지막 화면 업데이트
    func updateLastVC(_ vc: String, code: String?) {
        let fetchRequest = LastVC.fetchRequest()
        
        do {
            let result = try context.fetch(fetchRequest)
            
            if let target = result.last {
                target.setValue(vc, forKey: LastVC.Key.viewController)
                target.setValue(code, forKey: LastVC.Key.currencyCode)
                
                try context.save()
                print("lastVC 수정 완료")
            }
        } catch {
            print("lastVC 수정 실패")
        }
    }
}
