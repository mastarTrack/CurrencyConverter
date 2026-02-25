//
//  AppState+CoreDataProperties.swift
//  currencyConverter
//
//  Created by Yeseul Jang on 2/25/26.
//
//

public import Foundation
public import CoreData


public typealias AppStateCoreDataPropertiesSet = NSSet

extension AppState {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<AppState> {
        return NSFetchRequest<AppState>(entityName: "AppState")
    }

    @NSManaged public var lastScreen: String?
    @NSManaged public var selectedCurrency: String?

}

extension AppState : Identifiable {

}
