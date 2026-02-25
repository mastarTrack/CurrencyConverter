//
//  LastPage+CoreDataProperties.swift
//  currencyConverter
//
//  Created by Hanjuheon on 2/24/26.
//
//

public import Foundation
public import CoreData


public typealias LastPageCoreDataPropertiesSet = NSSet

extension LastPage {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<LastPage> {
        return NSFetchRequest<LastPage>(entityName: "LastPage")
    }

    @NSManaged public var isoCode: String?

}

extension LastPage : Identifiable {

}
