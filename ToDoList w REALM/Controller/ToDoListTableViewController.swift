//
//  ItemsTableViewController.swift
//  ToDoList w REALM
//
//  Created by Rafael M. Trasmontero on 9/30/19.
//  Copyright © 2019 RMT. All rights reserved.
//

import UIKit
import RealmSwift

class ToDoListTableViewController: UITableViewController {

    //***CREATE INSTANCE OF REALM
    var myRealm = try! Realm()
    //***CHANGE ARRAYS FROM "[Items]" TO A REALM COLLECTION TYPE "Results<Item>"
    var toDoItems:Results<Item>?
    
    //*** didSet is only called when parentCategory is not nil. (Benefits of making it optional)
    var parentCategory:Category? {
        didSet{
            loadItems()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    //MARK: - Tableview Data Source Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //If itemResults is not nil ? use the count else ?? use 1
        return toDoItems?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        if let item = toDoItems?[indexPath.row] {
            cell.textLabel?.text = item.name
            // VALUE = CHECK CONDITION ? USE IF TRUE : USE IF FALSE
            cell.accessoryType = item.done ? .checkmark : .none
        }
        return cell
        
    }
    
    
    //MARK: - TableView Delegate Methods
    //***UPDATE REALM ITEM CHECK/UNCHECK STATUS
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //Toggle True/False
        if let item = toDoItems?[indexPath.row] {
            //UPDATE ITEMS IN REALM
            do{
                try myRealm.write {
                    item.done = !item.done
                }
            } catch {
                print("ERRO UPDATING CHECKED ITEMS:\(error.localizedDescription)")
            }
            self.tableView.reloadData()
        }
        
        //De-Highlights selection
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    //MARK: - ADD NEW ITEM via Alert & TextField
    //SAVING TO REALM NEWLY CREATED ITEM
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        //Local reference
        var localTextField = UITextField()
        //Alert Popup
        let alert = UIAlertController.init(title: "Add New Todo Item", message: "", preferredStyle: .alert)
        let action = UIAlertAction.init(title: "Add Item", style: .default) { (action) in
        //What occurs when user adds + new object
            //Check for Parent Category is not nil, then create Realm Item and Save it to Realm
            if let currentCategory =  self.parentCategory {
                //SAVE TO REALM After we create a new Item
                do {
                    try self.myRealm.write {
                        let newItem = Item()
                        newItem.name = localTextField.text!
                        newItem.dateCreated = Date()
                        //Access the Parent Category Realm and append the new Item
                        currentCategory.categoryItems.append(newItem)
                    }
                } catch {
                    print("ERROR CREATING ITEM:\(error.localizedDescription)")
                }
            }
            self.tableView.reloadData()
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Enter New Item"
            localTextField = alertTextField
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
        
    }
    
    //MARK: - SWIPE TO DELETE METHODS
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            //*** DELETE FROM REALM
            if let itemToDelete = self.toDoItems?[indexPath.row] {
                do{
                    try myRealm.write {
                        myRealm.delete(itemToDelete)
                    }
                } catch {
                    print("ERROR DELETING ITEM")
                }
            }
        }
        self.tableView.reloadData()
    }
    
    //*** SAVE OUR ITEM OBJECT TO CORE DTATA BY CALLING CONTEXT.SAVE
    func saveItem(item: Item){
        do {
            try myRealm.write {
                myRealm.add(item)
            }
        } catch  {
            print("ERROR SAVING TO REALM")
        }
        
        tableView.reloadData()
    }
    
    //***LET REALM LOAD ITEMS BY THEIR PARENT CATEGORY "name" and in Ascending order
    
    func loadItems() {
        //Sorted by name
//        toDoItems = parentCategory?.categoryItems.sorted(byKeyPath: "name", ascending: true)
        
        //Sorted by Date =
        toDoItems = parentCategory?.categoryItems.sorted(byKeyPath: "dateCreated", ascending: true)
        
        tableView.reloadData()
    }
}

//MARK: Search bar Delegate Methods

    extension ToDoListTableViewController: UISearchBarDelegate {
    
    //FETCHING REALM ITEMS THAT ARE FILTERED BY OUR SEARCH
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        //Filter REALM ToDo Items by search Text and
        
        //Sort by name
//        toDoItems = toDoItems?.filter("name CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "name", ascending: true)
        
        //Sort by Date
        toDoItems = toDoItems?.filter("name CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
        
        tableView.reloadData()
        
    }

    //LOAD ALL REALM ITEMS AGAIN WHEN WE EXIT SEARCH BAR
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        //When we exit out of search bar
        if searchBar.text?.count == 0 {
            loadItems()
            //Dismiss Keyboard Imediately by going to main thread
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
    



}
