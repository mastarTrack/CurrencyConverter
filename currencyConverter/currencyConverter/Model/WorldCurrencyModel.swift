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
     let timeLastUpdateUnix: Int
     let timeLastUpdateUTC: String
     let timeNextUpdateUnix: Int
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
}


struct CurrencyData {
    var isoCode: String
    var rate: Double
    var countryName: String
}
