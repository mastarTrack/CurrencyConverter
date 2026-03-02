//
//  Date+CoreDataClass.swift
//  currencyConverter
//
//  Created by t2025-m0143 on 2/24/26.
//
//

public import Foundation
public import CoreData

public typealias DateCoreDataClassSet = NSSet


public class UpdateDate: NSManagedObject {
    public static let className = "UpdateDate"

    public enum Key {
        static let lastUpdate = "lastUpdate"
        static let nextUpdate = "nextUpdate"
    }
}
