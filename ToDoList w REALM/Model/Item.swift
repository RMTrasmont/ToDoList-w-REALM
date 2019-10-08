//
//  Item.swift
//  
//
//  Created by Rafael M. Trasmontero on 10/1/19.
//

//CREATE REALM MODEL REPRESENTING LOCAL DATA

import Foundation
import RealmSwift

//1. USE TYPE "Object" & "List/LinkingObjects" which are Realm-Class-Objects
//2. Label "@objc dynamic" all vars so it can be actively monitored and updated into the database while the app is running
//3. Setup Relationships between objects (Category and Items) similar to core data
//NOTE: WHEN you add new variables later on, that other Objects before did not have, you MUST Delete "app icon" and re-run or ERROR
//^ Fix for "migration is required...Error"
class Item: Object {
    @objc dynamic var name: String = ""
    @objc dynamic var done:Bool = false
    @objc dynamic var dateCreated: Date?
    //Inverse relationship of Items to its Category use "LinkingObjects"
    var parentCategory = LinkingObjects(fromType: Category.self, property: "categoryItems")
    
    
}
