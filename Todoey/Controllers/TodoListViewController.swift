//
//  ViewController.swift
//  Todoey
//
//  Created by John Ure on 13/01/2018.
//  Copyright © 2018 Soft Touch. All rights reserved.
//

import UIKit
import RealmSwift


class TodoListViewController: UITableViewController {
    
    // MARK: - Properties
    
    // create array from data model
    //var itemArray = [Item]()
    // now a Results container rather 
    var todoItems: Results<Item>?
    
    // create new Realm instance
    let realm = try! Realm()
    
    // for didSelect table row in CategoryVC
    // we will have value at this stage so optional won't be nil - see also addButtonPressed
    var selectedCategory: Category? {
        didSet {
            // gets executed as soon as selectedCategory has a value (delete from viewDidLoad)
            loadItems()
        }
    }
    
    
    
    
    // MARK: - View
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        //print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
        // load our data - this uses default - see Properties
        //loadItems()
    }
    
    
    
    // MARK: - Tableview Datasource
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // optional chaining, if todoItems is not nil then return the count, but if nil then return 1
        return todoItems?.count ?? 1
    }
    
    
    
    // This method gets called for every cell in the table view, dependent on number of rows
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Only load the visible cells, cells get reused.
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        // display cell with data
        // optional chaining, if not nil then grab the items at indexPath.row
        if let item = todoItems?[indexPath.row] {
            cell.textLabel?.text = item.title
            
            // ternary operator
            cell.accessoryType = item.done ? .checkmark : .none
            // above sets the accessoryType - if true set checkmark, if false set to none
        } else {
            // if nil
            cell.textLabel?.text = "No Items Added"
        }
        
        return cell
    }
    
    
    
    // MARK: - Tableview Delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // when deleting, use context first before removing from array, eg:
        //context.delete(itemArray[indexPath.row])
        //itemArray.remove(at: indexPath.row)
        
        // Sets the done property as it stands to its opposite
//        todoItems[indexPath.row].done = !todoItems[indexPath.row].done
//
//        saveItems()
        
        // don't leave selected row as gray background.
        // deselect and animate leaving white background.
        tableView.deselectRow(at: indexPath, animated: true)
    }

    
    // MARK: - Add New Items
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        // local var to work in closures
        var textField = UITextField()
        
        // show an alert with text field and append to array
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            // what happens when alert clicked
            print("Success!")
            // go to alertTextField closure where local var is set and then print to console
            print(textField.text!)
            
            // create new item of type NSManagedObject with 2 x attributes
//            let newItem = Item(context: self.context)
//            newItem.title = textField.text!
//            newItem.done = false
//            // for new Category
//            newItem.parentCategory = self.selectedCategory
//
//            // add to array and use self cos in closure
//            self.itemArray.append(newItem)
            
            //self.saveItems()
            
            if let currentCategory = self.selectedCategory {
                // if not nil
                // save, can throw so use do-catch and use self cos in closure
                do {
                    try self.realm.write {
                    // init new Item
                    let newItem = Item()
                    newItem.title = textField.text!
                    currentCategory.items.append(newItem)
                    }
                } catch {
                    print("Error saving new items, \(error)")
                }
            }
            
            // update table view with new item
            self.tableView.reloadData()
            
        }
        
        // this closure only gets triggered once text field has been added to alert
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"

            textField = alertTextField
            // above local var is used in action closure
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    
    
    
    // MARK: - Model Manipulation Methods
//    func saveItems() {
//
//        do {
//            // save temp area (context) to persistent store
//            try context.save()
//        } catch {
//            print("Error saving context \(error)")
//        }
//        // won't display in table until...
//        tableView.reloadData()
//    }
    
    
    
    
    func loadItems() {
        // use relationship, sort alphabetically
        todoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
        
        tableView.reloadData()
    }
    
    
    
    
    
}

// MARK: - Extension
//extension TodoListViewController: UISearchBarDelegate {
//
//    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
//        // set up Core Data request
//        let request: NSFetchRequest<Item> = Item.fetchRequest()
//
//        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
//
//
//        //print(searchBar.text!)
//
//        // query object using Core Data
//        // title contains a value from searchBar text, ignoring case and diacritics(accents)
//        //let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
//
//        // add query to request
//        //request.predicate = predicate
//
//        //request.predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
//
//        // sort returned data
//        //let sortDescriptor = NSSortDescriptor(key: "title", ascending: true)
//
//        // add sort to request, single item in array
//        //request.sortDescriptors = [sortDescriptor]
//
//        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
//
//        // run request and fetch results (see loadItems)
//        // we have to go through the context to get our data - this can throw an error so use try inside a do catch block
//        //do {
//            // save data in our array
//            //itemArray = try context.fetch(request)
//        //} catch {
//           // print("Error fetching data from context \(error)")
//        //
//
//        loadItems(with: request, predicate: predicate)
//
//        // update and display table
//        //tableView.reloadData()
//    }
//
//
//    // when user clears search bar:
//    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//        if searchBar.text?.count == 0 {
//            // text has changed, but now empty
//            // fetch all items
//            loadItems()
//
//            // we want UI to update even if background events are happening
//            // get main thread so search bar is on main queue in foreground
//            DispatchQueue.main.async {
//                // tell search bar that it is no longer the active object, dismiss onscreen keyboard
//                searchBar.resignFirstResponder()
//            }
//
//
//        }
//    }
//}

