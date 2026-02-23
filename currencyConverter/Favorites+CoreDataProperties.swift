//
//  Favorites+CoreDataProperties.swift
//  currencyConverter
//
//  Created by Hanjuheon on 2/23/26.
//
//

public import Foundation
public import CoreData


public typealias FavoritesCoreDataPropertiesSet = NSSet

extension Favorites {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Favorites> {
        return NSFetchRequest<Favorites>(entityName: "Favorites")
    }
    
    @NSManaged public var isoCode: String?
    @NSManaged public var isFavorite: Bool

}

extension Favorites : Identifiable {

}
