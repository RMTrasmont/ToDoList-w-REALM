//
//  CategoryTableViewController.swift
//  ToDoList w REALM
//
//  Created by Rafael M. Trasmontero on 9/30/19.
//  Copyright © 2019 RMT. All rights reserved.
//

import UIKit
import RealmSwift

class CategoriesTableViewController: UITableViewController {

    //***INIT NEW REALM
    let myRealm = try! Realm()
    
    //***FOR REALM, A GROUP OF REALM ITEMS IS STORED AS "Results". REALM WILL AUTO APPEND ALL ITEMS THAT ARE OF TYPE "Catergory" TO THIS ARRAY VARIABLE.
    
    //***CHANGE ARRAYS FROM "[Category]" TO A REALM COLLECTION TYPE "Results<Category>"
    var categories:Results<Category>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadCategories()
    }

    // MARK: - Table view Data Source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //***"If Categories array is not nil()? / return .count / else(??) return 1"
        return categories?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        //*** If categoriesResults is Not nil ? use indexPath.row Item else ?? "No Categories Added"
        cell.textLabel?.text = categories?[indexPath.row].name ?? "No Categories Added"
        return cell
    }
    
    //MARK: - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //Segue to this categories Items screen// SETUP "Prepare for segue" First
        performSegue(withIdentifier: "goToItems", sender: self)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! ToDoListTableViewController
        //get Indexpath of the selected cell to set the "Selected category" for the Next Screen
        if let selectedIndexPath = tableView.indexPathForSelectedRow {
            //"If categoriesResults is not nil ? use the selectedIndexPath.row Object"
            destinationVC.parentCategory = categories?[selectedIndexPath.row]
        }
        
    }
    
    //MARK: - SWIPE TO DELETE METHODS
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            //*** DELETE FROM REALM
            if let categoryToDelete = self.categories?[indexPath.row] {
                do{
                    try myRealm.write {
                        myRealm.delete(categoryToDelete)
                    }
                } catch {
                    print("ERROR DELETING CATEGORY")
                }
            }
            
        }
        self.tableView.reloadData()
    }
    
    //MARK: - Adding New Category via Alert & TextField
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        //Local reference
        var localTextField = UITextField()
        //Alert Popup
        let alert = UIAlertController.init(title: "Add New Category", message: "", preferredStyle: .alert)
        let action = UIAlertAction.init(title: "Add Category", style: .default) { (action) in
            //*** CREATE REALM ITEM & FILL IN ITS ATTRIBUTES
            let newCategory = Category()
            newCategory.name = localTextField.text!
            //***NO NEED TO APPEND TO ARRAY B/C REALM AUTO UPDATES WHEN YOU USE "Results" Data type for our Categories Array. Every Time you create a Category Item it goes into Realm Results Collection automatically which is our CategoryArray type.
            
            self.save(category: newCategory)
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Enter New Item"
            localTextField = alertTextField
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    //MARK: SAVE AND LOAD TO & FROM REALM
    
    //***WRITE TO REALM
    func save(category: Category){
        do {
            try myRealm.write {
                myRealm.add(category)
            }
        } catch  {
            print("ERROR SAVING TO REALM")
        }
      
        tableView.reloadData()
    }
    
    //***FETCH FROM REALM
    func loadCategories(){
        //Get all Category Items from Realm
        let myCategories = myRealm.objects(Category.self)
        categories = myCategories
        tableView.reloadData()
    }

 

}
