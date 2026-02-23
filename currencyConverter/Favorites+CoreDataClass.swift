//
//  Favorites+CoreDataClass.swift
//  currencyConverter
//
//  Created by Hanjuheon on 2/23/26.
//
//

public import Foundation
public import CoreData

public typealias FavoritesCoreDataClassSet = NSSet

@objc(Favorites)
public class Favorites: NSManagedObject {
    public static let className = "Favorites"
    public enum keys {
        static let isoCode = "isoCode"
        static let isFavorite = "isFavorite"
    }
}
