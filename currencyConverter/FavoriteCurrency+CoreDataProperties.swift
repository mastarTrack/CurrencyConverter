//
//  FavoriteCurrency+CoreDataProperties.swift
//  currencyConverter
//
//  Created by Yeseul Jang on 2/24/26.
//
//

public import Foundation
public import CoreData


public typealias FavoriteCurrencyCoreDataPropertiesSet = NSSet

extension FavoriteCurrency {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<FavoriteCurrency> {
        return NSFetchRequest<FavoriteCurrency>(entityName: "FavoriteCurrency")
    }

    @NSManaged public var currency: String?

}

extension FavoriteCurrency : Identifiable {

}
