//
//  WorldCurrency+CoreDataClass.swift
//  currencyConverter
//
//  Created by Hanjuheon on 2/24/26.
//
//

public import Foundation
public import CoreData

public typealias WorldCurrencyCoreDataClassSet = NSSet

@objc(WorldCurrency)
public class WorldCurrency: NSManagedObject {
    public static let className = "WorldCurrency"
    public enum keys {
        static let trand = "trand"
        static let rate = "rate"
        static let isoCode = "isoCode"
        static let favorites = "favorites"
        static let countryName = "countryName"
    }
}
