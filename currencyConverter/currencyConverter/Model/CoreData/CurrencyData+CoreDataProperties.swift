//
//  CurrencyData+CoreDataProperties.swift
//  currencyConverter
//
//  Created by t2025-m0143 on 2/24/26.
//
//

public import Foundation
public import CoreData


public typealias CurrencyDataCoreDataPropertiesSet = NSSet

extension CurrencyData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CurrencyData> {
        return NSFetchRequest<CurrencyData>(entityName: "CurrencyData")
    }

    @NSManaged public var currencyCode: String
    @NSManaged public var value: Double
    @NSManaged public var bookMark: Bool

}

extension CurrencyData : Identifiable {

}
