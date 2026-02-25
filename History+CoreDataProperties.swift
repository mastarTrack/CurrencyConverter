//
//  History+CoreDataProperties.swift
//  currencyConverter
//
//  Created by 손영빈 on 2/20/26.
//
//

public import Foundation
public import CoreData


public typealias HistoryCoreDataPropertiesSet = NSSet

extension History {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<History> {
        return NSFetchRequest<History>(entityName: "History")
    }

    @NSManaged public var code: String?
    @NSManaged public var rate: Double
    @NSManaged public var unix: Int64

}

extension History : Identifiable {

}
