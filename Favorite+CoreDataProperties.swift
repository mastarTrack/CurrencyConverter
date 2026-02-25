//
//  Favorite+CoreDataProperties.swift
//  currencyConverter
//
//  Created by 손영빈 on 2/19/26.
//
//

public import Foundation
public import CoreData


public typealias FavoriteCoreDataPropertiesSet = NSSet

extension Favorite {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Favorite> {
        return NSFetchRequest<Favorite>(entityName: "Favorite")
    }

    @NSManaged public var code: String?

}

extension Favorite : Identifiable {

}
