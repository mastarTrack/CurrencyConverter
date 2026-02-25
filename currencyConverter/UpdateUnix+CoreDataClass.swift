//
//  UpdateUnix+CoreDataClass.swift
//  currencyConverter
//
//  Created by Hanjuheon on 2/24/26.
//
//

public import Foundation
public import CoreData

public typealias UpdateUnixCoreDataClassSet = NSSet

@objc(UpdateUnix)
public class UpdateUnix: NSManagedObject {
    public static let className = "UpdateUnix"
    public enum keys {
        static let updateUnix = "updateUnix"
    }
}
