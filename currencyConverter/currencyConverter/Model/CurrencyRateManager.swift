//
//  CurrencyRateManager.swift
//  currencyConverter
//
//  Created by Yeseul Jang on 2/25/26.
//
import CoreData

final class CurrencyRateStore {
    private let context: NSManagedObjectContext
    init(context: NSManagedObjectContext) { self.context = context }

    func fetchRate(currency: String) -> Double? {
        let req: NSFetchRequest<CurrencyRate> = CurrencyRate.fetchRequest()
        req.predicate = NSPredicate(format: "currency == %@", currency)
        req.fetchLimit = 1

        return (try? context.fetch(req).first)?.rate
    }

    // 네트워크에서 환율 받아온 뒤 저장할 때 (update + insert)
    func upsertRate(currency: String, rate: Double) {
        let req: NSFetchRequest<CurrencyRate> = CurrencyRate.fetchRequest()
        req.predicate = NSPredicate(format: "currency == %@", currency)
        req.fetchLimit = 1

        let obj = (try? context.fetch(req).first) ?? CurrencyRate(context: context)
        obj.currency = currency
        obj.rate = rate

        try? context.save()
    }
}
