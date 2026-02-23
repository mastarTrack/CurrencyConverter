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
    
    
    //MARK: - METHOD: Favorites
    /// 즐겨찾기 CoreData 저장 메소드
    static func createFavoriteData(isoCode: String, isFavorite: Bool) {
        guard let context = context else { return }
        guard let entity = NSEntityDescription.entity(forEntityName: Favorites.className,
                                                      in: context) else { return }
        
        let favoriteData = NSManagedObject(entity: entity, insertInto: context)
        favoriteData.setValue(isoCode, forKey: Favorites.keys.isoCode)
        favoriteData.setValue(isFavorite, forKey: Favorites.keys.isFavorite)
        
        do {
            try context.save()
            print("Save is Success")
        } catch {
            print("Save is Failed")
        }
    }
    
    /// 즐겨찾기 CoreData 읽기 메소드
    static func ReadFavoriteData() -> [(String, Bool)] {
        do {
            guard let favoritesDatas = try context?.fetch(Favorites.fetchRequest()) else { return [] }
            return favoritesDatas.reduce(into: [(String, Bool)]() ){ $0.append( ($1.isoCode, $1.isFavorite) as! (String, Bool)) }
        } catch {
            print("Read Failed")
            return []
        }
    }
    
    /// 즐겨찾기 CoreData 삭제 메소드
    static func deleteFavoriteData(isoCode: String) {
        let fetchRequest = Favorites.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "\(Favorites.keys.isoCode) == %@", isoCode)
        
        do {
            guard let result = try context?.fetch(fetchRequest) else { return }
            for data in result as [NSManagedObject] {
                context?.delete(data)
            }
            try context?.save()
        } catch {
            print("Delete Failed")
        }
    }
}
