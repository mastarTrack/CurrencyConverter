//
//  CurrencyData+CoreDataClass.swift
//  currencyConverter
//
//  Created by t2025-m0143 on 2/24/26.
//
//

public import Foundation
public import CoreData

public typealias CurrencyDataCoreDataClassSet = NSSet


public class CurrencyData: NSManagedObject {
    public static let className = "CurrencyData"
    public enum Key {
        static let currencyCode = "currencyCode"
        static let value = "value"
        static let bookMark = "bookMark"
        static let fluctuation = "fluctuation"
    }
}
