//
//  Information+CoreDataProperties.swift
//  currencyConverter
//
//  Created by 손영빈 on 2/20/26.
//
//

public import Foundation
public import CoreData


public typealias InformationCoreDataPropertiesSet = NSSet

extension Information {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Information> {
        return NSFetchRequest<Information>(entityName: "Information")
    }

    @NSManaged public var code: String?
    @NSManaged public var page: String?
    @NSManaged public var constant: Int16

}

extension Information : Identifiable {

}
