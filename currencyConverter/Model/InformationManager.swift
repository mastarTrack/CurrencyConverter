//
//  InformationManager.swift
//  currencyConverter
//
//  Created by 손영빈 on 2/20/26.
//

//TODO: saveInfo, fetchData 메서드가 공통된 로직인데, 하나로 합칠 수는 없나 ?

import Foundation
import CoreData

class InformationManager {
    
    var container: NSPersistentContainer
    
    init(container: NSPersistentContainer) {
        self.container = container
    }
}

extension InformationManager {
    func saveInfo(code: String?, page: String){
        let fetchRequest = Information.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "constant == 1")
        
        do {
            let informations = try self.container.viewContext.fetch(fetchRequest)
            let information = informations.first ?? Information(context: self.container.viewContext) // 앱을 처음 실행한 경우
            information.constant = 1
            information.code = code
            information.page = page
            
            try self.container.viewContext.save()
        } catch {
            print("데이터 저장 실패")
        }
    }
    
    func fetchData() -> Information? {
        let fetchRequest = Information.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "constant == 1")
        
        do {
            let informations = try self.container.viewContext.fetch(fetchRequest)
            return informations.first
        } catch {
            print("데이터 로딩 실패")
            return nil
        }
    }
}
