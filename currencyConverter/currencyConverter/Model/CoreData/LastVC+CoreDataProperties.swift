//
//  LastVC+CoreDataProperties.swift
//  currencyConverter
//
//  Created by t2025-m0143 on 2/25/26.
//
//

public import Foundation
public import CoreData


public typealias LastVCCoreDataPropertiesSet = NSSet

extension LastVC {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<LastVC> {
        return NSFetchRequest<LastVC>(entityName: "LastVC")
    }

    @NSManaged public var currencyCode: String?
    @NSManaged public var viewController: String?

}

extension LastVC : Identifiable {

}
