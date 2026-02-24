//
//  WorldCurrency+CoreDataProperties.swift
//  currencyConverter
//
//  Created by Hanjuheon on 2/24/26.
//
//

public import Foundation
public import CoreData


public typealias WorldCurrencyCoreDataPropertiesSet = NSSet

extension WorldCurrency {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<WorldCurrency> {
        return NSFetchRequest<WorldCurrency>(entityName: "WorldCurrency")
    }

    @NSManaged public var isoCode: String?
    @NSManaged public var rate: Double
    @NSManaged public var countryName: String?
    @NSManaged public var favorites: Bool
    @NSManaged public var trand: Int16

}

extension WorldCurrency : Identifiable {

}
