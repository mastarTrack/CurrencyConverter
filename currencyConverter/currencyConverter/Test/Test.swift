//
//  Test.swift
//  currencyConverter
//
//  Created by t2025-m0143 on 2/25/26.
//

import CoreData

class TestCoreDataManager {
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
extension TestCoreDataManager {
    // 환율 정보 저장
    func saveCurrencyData(_ rate: [Rate]) {

    }
    
    // 업데이트 날짜 저장
    func saveUpdateDate(lastUpdate: Date, nextUpdate: Date) {

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
        return (lastUpdate: Date() - 166400, nextUpdate: Date() - 86400)
    }
    
    // 북마크 업데이트
    func updateBookMark(of code: String, bookMarked: Bool) {
    }
}

class TestDataService {
    func fetchCurrencyData(currency: String, completion: @escaping (CurrencyResponse?) -> Void) {
        let rates = [
            "USD": 1,
            "AED": 3.6725,
            "AFN": 63.068924,
            "ALL": 81.6948,
            "AMD": 376.877616,
            "ANG": 2.79,
            "AOA": 921.439033,
            "ARS": 1453.25,
            "AUD": 2.411158,
            "AWG": 2.79,
            "AZN": 2.70007,
            "BAM": 2.656107,
            "BBD": 3.0,
            "BDT": 123.262851,
            "BGN": 2.649643,
            "BHD": 1.376,
            "BIF": 2968.265362,
            "BMD": 2.0,
            "BND": 2.266265,
            "BOB": 7.925649,
            "BRL": 6.202619,
            "BSD": 2.0,
            "BTN": 91.865109,
            "BWP": 14.232825,
            "BYN": 3.855993,
            "BZD": 3.0,
            "CAD": 2.366225,
            "CDF": 2305.690356,
            "CHF": 1.773481,
            "CLF": 1.02191,
            "CLP": 867.003143,
            "CNH": 7.893997,
            "CNY": 7.911221,
            "COP": 3704.619175,
            "CRC": 480.441609,
            "CUP": 25.0,
            "CVE": 94.367316,
            "CZK": 21.52813,
            "DJF": 178.721,
            "DKK": 7.318378,
            "DOP": 62.496231,
            "DZD": 131.133056,
            "EGP": 48.694321,
            "ERN": 16.0,
            "ETB": 156.224676,
            "EUR": 1.846757,
            "FJD": 3.210936,
            "FKP": 1.740181,
            "FOK": 7.322923,
            "GBP": 1.740182,
            "GEL": 3.675197,
            "GGP": 1.740181,
            "GHS": 11.995107,
            "GIP": 1.740181,
            "GMD": 75.120479,
            "GNF": 8738.212758,
            "GTQ": 8.677108,
            "GYD": 210.216287,
            "HKD": 8.813906,
            "HNL": 27.468074,
            "HRK": 7.379867,
            "HTG": 132.236757,
            "HUF": 323.145704,
            "IDR": 16872.148754,
            "ILS": 4.123032,
            "IMP": -0.259819,
            "INR": 89.865449,
            "IQD": 1309.907711,
            "IRR": 1284440.041255,
            "ISK": 122.141383,
            "JEP": -0.259819,
            "JMD": 155.093459,
            "JOD": -0.291,
            "JPY": 153.641419,
            "KES": 128.057559,
            "KGS": 86.464753,
            "KHR": 4017.927293,
            "KID": 0.412269,
            "KMF": 415.575599,
            "KRW": 1446.06912,
            "KWD": -0.693602,
            "KYD": -0.166667,
            "KZT": 496.051052,
            "LAK": 21600.266418,
            "LBP": 89499.0,
            "LKR": 308.145892,
            "LRD": 184.349193,
            "LSL": 15.029383,
            "LYD": 5.324054,
            "MAD": 8.180817,
            "MDL": 16.129871,
            "MGA": 4304.847006,
            "MKD": 51.381183,
            "MMK": 2101.551644,
            "MNT": 3532.243799,
            "MOP": 7.048323,
            "MRU": 38.993699,
            "MUR": 45.384999,
            "MVR": 14.435611,
            "MWK": 1736.690063,
            "MXN": 16.124032,
            "MYR": 2.903055,
            "MZN": 62.592582,
            "NAD": 15.029383,
            "NGN": 1344.849117,
            "NIO": 35.820912,
            "NOK": 8.511932,
            "NPR": 144.384174,
            "NZD": 0.671474,
            "OMR": -0.615503,
            "PAB": 0.0,
            "PEN": 2.359519,
            "PGK": 3.332537,
            "PHP": 57.062003,
            "PKR": 278.536085,
            "PLN": 2.576836,
            "PYG": 6500.926834,
            "QAR": 2.64,
            "RON": 3.332112,
            "RSD": 98.742085,
            "RUB": 75.764418,
            "RWF": 1455.73199,
            "SAR": 2.75,
            "SBD": 7.009747,
            "SCR": 13.203887,
            "SDG": 457.814337,
            "SEK": 8.034379,
            "SGD": 0.266266,
            "SHP": -0.259819,
            "SLE": 23.455372,
            "SLL": 24454.372018,
            "SOS": 569.913127,
            "SRD": 36.542523,
            "SSP": 4577.646106,
            "STN": 19.74547,
            "SYP": 111.410727,
            "SZL": 15.029383,
            "THB": 30.098067,
            "TJS": 8.393578,
            "TMT": 2.499972,
            "TND": 1.871578,
            "TOP": 1.365768,
            "TRY": 42.803635,
            "TTD": 5.770944,
            "TVD": 0.412269,
            "TWD": 30.529731,
            "TZS": 2584.105205,
            "UAH": 42.279246,
            "UGX": 3583.381217,
            "UYU": 37.654934,
            "UZS": 12211.491756,
            "VES": 404.3518,
            "VND": 25907.435301,
            "VUV": 117.245198,
            "WST": 1.686995,
            "XAF": 554.434132,
            "XCD": 1.7,
            "XCG": 0.79,
            "XDR": -0.272633,
            "XOF": 554.434132,
            "XPF": 100.044833,
            "YER": 237.473617,
            "ZAR": 15.029435,
            "ZMW": 17.892965,
            "ZWG": 24.5384,
            "ZWL": 24.5384
        ]
        
        let last = Date()
        let next = Date() + 86400
        
        completion(CurrencyResponse(rates: rates, lastUpdate: last, nextUpdate: next))
    }
}
