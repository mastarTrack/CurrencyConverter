//
//  Currency+CoreDataClass.swift
//  currencyConverter
//
//  Created by t2025-m0143 on 2/24/26.
//
//

public import Foundation
public import CoreData

public typealias CurrencyCoreDataClassSet = NSSet


public class BookMark: NSManagedObject {
    public static let className = "BookMark"
    public enum Key {
        static let currencyCode = "currencyCode"
    }
}
