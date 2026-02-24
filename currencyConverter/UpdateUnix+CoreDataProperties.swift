//
//  UpdateUnix+CoreDataProperties.swift
//  currencyConverter
//
//  Created by Hanjuheon on 2/24/26.
//
//

public import Foundation
public import CoreData


public typealias UpdateUnixCoreDataPropertiesSet = NSSet

extension UpdateUnix {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<UpdateUnix> {
        return NSFetchRequest<UpdateUnix>(entityName: "UpdateUnix")
    }

    @NSManaged public var updateUnix: Double

}

extension UpdateUnix : Identifiable {

}
