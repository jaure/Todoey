//
//  CategoryViewController.swift
//  Todoey
//
//  Created by John Ure on 20/01/2018.
//  Copyright © 2018 Soft Touch. All rights reserved.
//

import UIKit
import RealmSwift
import SwipeCellKit


class CategoryViewController: UITableViewController {
    
    // MARK: - Properties
    
    // init a new Realm
    let realm = try! Realm()
    
    // create array using auto updating data type from Realm
    // force unwrapping here:
    //var categories: Results<Category>!
    // best to make optional and change code elsewhere
    var categories: Results<Category>?
    
    
    

    // MARK: - View
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loadCategories()
        
        // make trash icon show up ok when swiping row from right.
        tableView.rowHeight = 80.0
    }

    
    
    
    // MARK: - TableView Datasource methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        // categories defined as optional in Properties so if nil, return 1 using 'nil coalescing operator' (??)
        // see cellForRowAt which sets a default value if categories is nil
        return categories?.count ?? 1
    }
    
    
    
    // This method gets called for every cell in the table view, dependent on number of rows
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Only load the visible cells, cells get reused.
        // Using SwipeCellKit, downcast required - also in Main.storyboard, change CategoryCell to custom class SwipeTableViewCell and change module to SwipeCellKit.
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath) as! SwipeTableViewCell
        
        // display cell with data
        //let category = categoryArray[indexPath.row]
        //cell.textLabel?.text = category.name
        // Again, test for nil and, if so, set to string contents
        cell.textLabel?.text = categories?[indexPath.row].name ?? "No Categories added yet"
        
        // set delegate for SwipeCellKit using protocol - see class extension
        cell.delegate = self
        
        return cell
    }
    
    
    
    // MARK: - TableView Delegate Methods

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // trigger segue
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // store ref to destination
        let destinationVC = segue.destination as! TodoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            // set if categories not nil as defined as optional in Properties
            destinationVC.selectedCategory = categories?[indexPath.row]
        }
    }
    
    
    // MARK: - Data Manipulation Methods
    
    func save(category: Category) {
        
        do {
            // save to persistent store
            try realm.write {
                realm.add(category)
            }
        } catch {
            print("Error saving context \(error)")
        }
        // won't display in table until...
        tableView.reloadData()
    }
    
    func loadCategories() {
        
        categories = realm.objects(Category.self).sorted(byKeyPath: "name", ascending: true)

        tableView.reloadData()
    }
    
    
    
    // MARK: - Actions
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        // local var to work in closures
        var textField = UITextField()
        
        // show an alert with text field and append to array
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Name", style: .default) { (action) in
            // what happens when alert clicked
            print("Success!")
            // go to alertTextField closure where local var is set and then print to console
            print(textField.text!)
            
            // create new category with 1 x attribute
            let newCategory = Category()
            newCategory.name = textField.text!
            
            // auto updating Realm container means we no longer need to append - see Properties
            
            self.save(category: newCategory)
        }
        
        // this closure only gets triggered once text field has been added to alert
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new name"
            
            textField = alertTextField
            // above local var is used in action closure
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
}

// MARK: - Swipe Cell Delegate Methods
// rather than adding to class declaration:
extension CategoryViewController: SwipeTableViewCellDelegate {
    
    // required delegate method
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }
        
        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
            // handle action by updating model with deletion
            
                if let categoryToDelete = self.categories?[indexPath.row] {
                    // can throw, use do-catch
                    do {
                        // if not nil, delete selection
                        try self.realm.write {
                            // delete
                            print("Item deleted")
                            self.realm.delete(categoryToDelete)
                        }
                    } catch {
                        print("Error deleting category, \(error)")
                    }
                    
                    //tableView.reloadData()
                }
        }
        
        // customize the action appearance - image added to Assets
        deleteAction.image = UIImage(named: "delete-icon")
        
        return [deleteAction]
    }
    
    
    // drag fully from right to left to delete row without tapping icon
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeTableOptions {
        var options = SwipeTableOptions()
        options.expansionStyle = .destructive
        //options.transitionStyle = .border
        return options
    }
    
}
