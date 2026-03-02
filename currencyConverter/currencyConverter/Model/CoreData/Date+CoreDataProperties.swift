//
//  Date+CoreDataProperties.swift
//  currencyConverter
//
//  Created by t2025-m0143 on 2/24/26.
//
//

public import Foundation
public import CoreData


public typealias DateCoreDataPropertiesSet = NSSet

extension UpdateDate {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<UpdateDate> {
        return NSFetchRequest<UpdateDate>(entityName: "UpdateDate")
    }

    @NSManaged public var lastUpdate: Date
    @NSManaged public var nextUpdate: Date

}

extension UpdateDate : Identifiable {

}
