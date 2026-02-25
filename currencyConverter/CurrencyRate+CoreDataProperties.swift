//
//  CurrencyRate+CoreDataProperties.swift
//  currencyConverter
//
//  Created by Yeseul Jang on 2/25/26.
//
//

public import Foundation
public import CoreData


public typealias CurrencyRateCoreDataPropertiesSet = NSSet

extension CurrencyRate {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CurrencyRate> {
        return NSFetchRequest<CurrencyRate>(entityName: "CurrencyRate")
    }

    @NSManaged public var currency: String?
    @NSManaged public var rate: Double

}

extension CurrencyRate : Identifiable {

}
