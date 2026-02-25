//
//  CoreDataManager.swift
//  currencyConverter
//
//  Created by Yeseul Jang on 2/24/26.
//
import CoreData

class CoreDataManager {
    
    static let shared = CoreDataManager()
    private init() {}
    
    
    // MARK: - Core Data stack
    // persistentContainer 설정
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "CoreData")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    
    // context로 데이터 추출
    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    // MARK: - Core Data Saving support
    // 변경 사항이 있을 경우 데이터 저장
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

extension CoreDataManager {
    // 즐겨찾기 추가
    func addFavorite(currency: String) {
        guard !isFavorite(currency: currency) else { return }

        let favorite = FavoriteCurrency(context: context)
        favorite.currency = currency

        saveContext()
    }

    // 즐겨찾기 삭제
    func removeFavorite(currency: String) {
        let request: NSFetchRequest<FavoriteCurrency> = FavoriteCurrency.fetchRequest()
        request.predicate = NSPredicate(format: "currency == %@", currency)
        // 한개만 가져오기
        request.fetchLimit = 1

        do {
            if let target = try context.fetch(request).first {
                context.delete(target)
                saveContext()
            }
        } catch {
            print(error)
        }
    }

    // 즐겨찾기 여부 확인
    func isFavorite(currency: String) -> Bool {
        let request: NSFetchRequest<FavoriteCurrency> = FavoriteCurrency.fetchRequest()
        request.predicate = NSPredicate(format: "currency == %@", currency)
        request.fetchLimit = 1

        do {
            return try context.count(for: request) > 0
        } catch {
            print(error)
            return false
        }
    }

    // 전체 즐겨찾기 목록 가져오기
    func fetchAllFavoriteCurrencies() -> Set<String> {
        let request: NSFetchRequest<FavoriteCurrency> = FavoriteCurrency.fetchRequest()

        do {
            let results = try context.fetch(request)
            return Set(results.compactMap { $0.currency })
        } catch {
            print(error)
            return []
        }
    }
}


// 화면 저장 로직
extension CoreDataManager {

    // AppState는 1개
    private func fetchOrCreateAppState(in context: NSManagedObjectContext) -> AppState {
        let request = AppState.fetchRequest()
        request.fetchLimit = 1

        if let existing = (try? context.fetch(request))?.first {
            return existing
        } else {
            return AppState(context: context)
        }
    }

    // 마지막 화면 저장
    func saveLastScreen(_ screen: LastScreen, selectedCurrency: String?) {
        let context = persistentContainer.viewContext

        let state = fetchOrCreateAppState(in: context)
        state.lastScreen = screen.rawValue
        state.selectedCurrency = selectedCurrency

        do {
            try context.save()
        } catch {
            print(error)
        }
    }

    // 마지막 화면 가져오기
    func loadLastScreen() -> (screen: LastScreen, selectedCurrency: String?) {
        let context = persistentContainer.viewContext

        let request = AppState.fetchRequest()
        request.fetchLimit = 1

        guard
            let state = (try? context.fetch(request))?.first,
            let raw = state.lastScreen,
            let screen = LastScreen(rawValue: raw)
        else {
            return (.list, nil)
        }

        return (screen, state.selectedCurrency)
    }

    // 통화이름으로 rate 가져오기
    func fetchRate(currency: String) -> Double? {
        let context = persistentContainer.viewContext

        let request = CurrencyRate.fetchRequest()
        request.fetchLimit = 1
        request.predicate = NSPredicate(format: "currency == %@", currency)

        return (try? context.fetch(request))?.first?.rate
    }
}

// 환율 저장해주기
extension CoreDataManager {

    func upsertRates(_ rates: [String: Double]) {
        // 백그라운드에서 작업해야함
        let context = persistentContainer.newBackgroundContext()
        // 덮어쓰기를 설정
        context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        
        // 백그라운드라 여기서 작업 해야함
        context.perform {
            do {
                for (currency, rate) in rates {
                    let request = CurrencyRate.fetchRequest()
                    request.fetchLimit = 1
                    request.predicate = NSPredicate(format: "currency == %@", currency)

                    let existed = try context.fetch(request).first
                    // 없으면 만들어서 넣음
                    let target = existed ?? CurrencyRate(context: context)

                    target.currency = currency
                    target.rate = rate
                }

                try context.save()
            } catch {
                print(error)
            }
        }
    }
}

