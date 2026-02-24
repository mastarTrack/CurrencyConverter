//
//  Untitled.swift
//  currencyConverter
//
//  Created by Hanjuheon on 2/20/26.
//

struct WorldCurrencyModel: Decodable {
     let result: String
     let provider: String
     let documentation: String
     let termsOfUse: String
     let timeLastUpdateUnix: Double
     let timeLastUpdateUTC: String
     let timeNextUpdateUnix: Double
     let timeNextUpdateUTC: String
     let baseCode: String
     let rates: [String: Double]

     enum CodingKeys: String, CodingKey {
         case result
         case provider
         case documentation
         case termsOfUse = "terms_of_use"
         case timeLastUpdateUnix = "time_last_update_unix"
         case timeLastUpdateUTC = "time_last_update_utc"
         case timeNextUpdateUnix = "time_next_update_unix"
         case timeNextUpdateUTC = "time_next_update_utc"
         case baseCode = "base_code"
         case rates
     }
    
   static let mockData = WorldCurrencyModel(
        result: "success",
        provider: "MockProvider",
        documentation: "https://mockdocs.example.com",
        termsOfUse: "https://mockdocs.example.com/terms",
        timeLastUpdateUnix: 1708752000,
        timeLastUpdateUTC: "Tue, 24 Feb 2026 00:00:00 +0000",
        timeNextUpdateUnix: 1771978861,
        timeNextUpdateUTC: "Thu, 26 Feb 2026 00:00:00 +0000",
        baseCode: "USD",
        rates: [
            "AED": 1332.45,
            "JPY": 149.82,
            "EUR": 0.92,
            "GBP": 0.78,
            "CNY": 7.19,
            "AUD": 1.52,
            "CAD": 1.35,
            "CHF": 0.88,
            "SGD": 1.34,
            "HKD": 7.82
        ]
    )
}

struct CurrencyData {
    var isoCode: String
    var rate: Double
    var countryName: String
    var favorites: Bool = false
    var trand: Int16 = 0
}
