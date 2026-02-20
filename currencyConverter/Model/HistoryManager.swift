//
//  HistoryManager.swift
//  currencyConverter
//
//  Created by 손영빈 on 2/20/26.
//

//TODO: catch에서 에러처리

import Foundation
import CoreData

class HistoryManager {
    var container: NSPersistentContainer
    
    init(container: NSPersistentContainer) {
        self.container = container
    }
}

extension HistoryManager {
    
    // CoreData에 데이터 저장용 메서드
    func saveData(rates: [String: Double], unix: Int64) {
        rates.forEach { code, rate in
            let fetchRequest = History.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "code == %@", code)
            fetchRequest.sortDescriptors = [NSSortDescriptor(key: "unix", ascending: true)] // 오름차순 정렬(가장 오래된 값이 앞으로)
            do {
                let data = try self.container.viewContext.fetch(fetchRequest)
                
                // 불러온 데이터에서 오늘의 unix값을 포함하고 있을 경우(오늘 여러번 들어왔을 경우)
                if data.contains(where: { $0.unix == unix }) {
                    return
                }
                // 데이터의 개수가 2개 이상일 경우(2일 이상 경과)
                if data.count >= 2 {
                    self.container.viewContext.delete(data.first!)
                }
                
                let newData = History(context: self.container.viewContext)
                newData.code = code
                newData.rate = rate
                newData.unix = unix
                
            } catch {
                print("데이터 처리 실패")
            }
        }
        do {
            try self.container.viewContext.save()
        } catch {
            print("데이터 저장 실패")
        }
    }
    
    // ViewModel에서 사용할 CoreData에서 데이터 불러오는 메서드
    func fetchData(code: String) -> History? {
        let fetchRequest = History.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "code == %@", code)
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "unix", ascending: false)] // unix를 기준으로 내림차순 정렬(큰 값이 가장 최신)
        fetchRequest.fetchLimit = 1 // 데이터 하나를 찾으면 바로 멈춤
        do {
            let data = try self.container.viewContext.fetch(fetchRequest)
            return data.first
        } catch {
            print("데이터 조회 실패")
            return nil
        }
    }
}
