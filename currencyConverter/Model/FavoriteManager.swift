//
//  FavoriteManager.swift
//  currencyConverter
//
//  Created by 손영빈 on 2/19/26.
//

import Foundation
import CoreData

class FavoriteManager {
    var container: NSPersistentContainer
    
    init(container: NSPersistentContainer) {
        self.container = container
    }
}

extension FavoriteManager {
    // StarButton toggle용 메서드
    func toggleFavorite(code: String) {
        let fetchRequest = Favorite.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "code == %@", code)
        
        do {
            let favorites = try self.container.viewContext.fetch(fetchRequest)
            if let favorite = favorites.first {
                container.viewContext.delete(favorite)
            } else { //NSManagedObject 사용하지않고 Favorite 클래스 바로 사용
                let newFavorite = Favorite(context: self.container.viewContext)
                newFavorite.code = code
            }
            try self.container.viewContext.save()
        } catch { // 오류 출력 구문 필요
            print("Favorite toggle 실패")
        }
    }
    // ViewModel에서 CoreData에 저장된 리스트 사용을 위한 메서드
    func fetchFavorites() -> [Favorite] {
        let fetchRequest = Favorite.fetchRequest()
        do {
            let favorites = try self.container.viewContext.fetch(fetchRequest)
            return favorites
        } catch {
            print("Favorite fetch 실패")
            return []
        }
    }
}
