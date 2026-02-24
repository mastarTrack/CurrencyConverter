//
//  LastPage+CoreDataClass.swift
//  currencyConverter
//
//  Created by Hanjuheon on 2/24/26.
//
//

public import Foundation
public import CoreData

public typealias LastPageCoreDataClassSet = NSSet

@objc(LastPage)
public class LastPage: NSManagedObject {
    public static let className = "LastPage"
    public enum keys {
        static let isoCode = "isoCode"
    }
}
