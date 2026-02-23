//
//  FavoriteCurrency+CoreDataProperties.swift
//  currencyConverter
//
//  Created by 김주희 on 2/23/26.
//
//

public import Foundation
public import CoreData


public typealias FavoriteCurrencyCoreDataPropertiesSet = NSSet

extension FavoriteCurrency {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<FavoriteCurrency> {
        return NSFetchRequest<FavoriteCurrency>(entityName: "FavoriteCurrency")
    }

    @NSManaged public var favoriteCode: String?

}

extension FavoriteCurrency : Identifiable {

}
