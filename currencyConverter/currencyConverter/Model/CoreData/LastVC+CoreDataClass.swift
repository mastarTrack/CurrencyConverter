//
//  LastVC+CoreDataClass.swift
//  currencyConverter
//
//  Created by t2025-m0143 on 2/25/26.
//
//

public import Foundation
public import CoreData

public typealias LastVCCoreDataClassSet = NSSet


public class LastVC: NSManagedObject {
    public static let className = "LastVC"
    
    public enum Key {
        static let viewController = "viewController"
        static let currencyCode = "currencyCode"
    }
}
