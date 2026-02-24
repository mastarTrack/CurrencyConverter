//
//  Currency+CoreDataProperties.swift
//  currencyConverter
//
//  Created by t2025-m0143 on 2/24/26.
//
//

public import Foundation
public import CoreData


public typealias CurrencyCoreDataPropertiesSet = NSSet

extension BookMark {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<BookMark> {
        return NSFetchRequest<BookMark>(entityName: "BookMark")
    }

    @NSManaged public var currencyCode: String?

}

extension BookMark : Identifiable {

}
