//
//  Category.swift
//  ToDoList w REALM
//
//  Created by Rafael M. Trasmontero on 10/1/19.
//  Copyright © 2019 RMT. All rights reserved.
//

//CREATE REALM MODEL REPRESENTING LOCAL DATA

import Foundation
import RealmSwift

//1. USE TYPE "Object" & "List/LinkingObjects" which are Realm-Class-Objects
//2. Label "@objc dynamic" all vars so it can be actively monitored and updated into the database while the app is running
//3. Setup Relationships between objects (Category and Items) similar to core data

class Category: Object {
    @objc dynamic var name: String = ""
    //Forward Relationship Category to its Itemsss
    let categoryItems = List<Item>()
}
