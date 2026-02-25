//
//  CurrencyCoreDataManager.swift
//  currencyConverter
//
//  Created by Hanjuheon on 2/23/26.
//

import UIKit
import CoreData

/// 코어데이터 메니더
class CurrencyCoreDataManager {
    
    private static let context: NSManagedObjectContext? = {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            print("AppDelegate가 초기화되지 않았습니다")
            return nil
        }
        return appDelegate.persistentContainer.viewContext
    }()
}

//MARK: - METHOD: WorldCurrency
extension CurrencyCoreDataManager {
    static func createWorldCurrencyData(datas: [CurrencyData]) {
        guard let context = context else { return }
        guard let entity = NSEntityDescription.entity(forEntityName: WorldCurrency.className,
                                                      in: context) else { return }
        for data in datas {
            let currency = NSManagedObject(entity: entity, insertInto: context)
            currency.setValue(data.isoCode, forKey: WorldCurrency.keys.isoCode)
            currency.setValue(data.countryName, forKey: WorldCurrency.keys.countryName)
            currency.setValue(data.rate, forKey: WorldCurrency.keys.rate)
            currency.setValue(data.favorites, forKey: WorldCurrency.keys.favorites)
            currency.setValue(data.trand, forKey: WorldCurrency.keys.trand)
        }
        do {
            try context.save()
        } catch {
            print("Save Error: WorldCurrency Data")
        }
    }
    
    static func readWorldCurrencyData() -> [CurrencyData]? {
        do {
            guard let currencyDatas = try context?.fetch(WorldCurrency.fetchRequest()) else { return nil }
            return currencyDatas.reduce(into: [CurrencyData]()) {
                $0.append(CurrencyData(isoCode: $1.isoCode ?? "",
                                       rate: $1.rate,
                                       countryName: $1.countryName ?? "",
                                       favorites: $1.favorites,
                                       trand: $1.trand))
            }
        } catch {
            print("Read Error: WorldCurrency Data")
            return nil
        }
    }
        
    static func updateWorldCurrencyData(currencydata: CurrencyData) {
        guard let context = context else { return }

        let fetchRequest = WorldCurrency.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "\(WorldCurrency.keys.isoCode) == %@", currencydata.isoCode)
        
        do {
            let result = try context.fetch(fetchRequest)
            if let data = result.first {
                data.isoCode = currencydata.isoCode
                data.countryName = currencydata.countryName
                data.favorites = currencydata.favorites
                data.rate = currencydata.rate
                data.trand = currencydata.trand
            }
            try context.save()
        } catch {
            print("Delete Failed")
        }
    }
    
    static func deleteAllWorldCurrencyData() {
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: WorldCurrency.fetchRequest())
        do {
            try context?.execute(deleteRequest)
            try context?.save()
        } catch {
            print("delete All Error: WorldCurrency Data")

        }
    }
}


//MARK: - METHOD: UpdateUnix
extension CurrencyCoreDataManager {
    static func updateUpdateUnixData(UnixDate: Double) {
        guard let context = context else { return }
        do {
            let updateUnixData = try context.fetch(UpdateUnix.fetchRequest())
            if let data = updateUnixData.first {
                data.updateUnix = UnixDate
            } else {
                let newData = UpdateUnix(context: context)
                newData.updateUnix = UnixDate
            }
            try context.save()
        } catch {
            print("Save Error: LastPage Data")
        }
    }
    
    static func readUpdateUnixData() -> Double? {
        do {
            guard let updateUnixData = try context?.fetch(UpdateUnix.fetchRequest()) else { return nil }
            return updateUnixData.first?.updateUnix ?? 0
        } catch {
            print("Load Error: LastPage Data")
            return nil
        }
    }
}

//MARK: - METHOD: LastPage
extension CurrencyCoreDataManager {
    static func updateLastPageData(isoCode: String) {
        guard let context = context else { return }
        do {
            let lastPageData = try context.fetch(LastPage.fetchRequest())
            if let data = lastPageData.first {
                data.isoCode = isoCode
            } else {
                let newData = LastPage(context: context)
                newData.isoCode = isoCode
            }
            try context.save()
        } catch {
            print("Save Error: LastPage Data")
        }
    }
    
    static func readLastPageData() -> String? {
        do {
            guard let lastPageData = try context?.fetch(LastPage.fetchRequest()) else { return nil }
            return lastPageData.first?.isoCode
        } catch {
            print("Load Error: LastPage Data")
            return nil
        }
    }
}
