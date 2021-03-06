//
//  CategoryViewController.swift
//  Todoey
//
//  Created by John Ure on 20/01/2018.
//  Copyright © 2018 Soft Touch. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework


// inherits from our custom super class
class CategoryViewController: SwipeTableViewController {
    
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
        
        // no dividing lines between cells
        tableView.separatorStyle = .none
    }

    
    
    
    // MARK: - TableView Datasource methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        // categories defined as optional in Properties so if nil, return 1 using 'nil coalescing operator' (??)
        // see cellForRowAt which sets a default value if categories is nil
        return categories?.count ?? 1
    }
    
    
    
    // This method gets called for every cell in the table view, dependent on number of rows
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Get cell from super class
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        if let category = categories?[indexPath.row] {
            cell.textLabel?.text = category.name
            
            guard let categoryColour = UIColor(hexString: category.colour) else {fatalError()}
            
            cell.backgroundColor = categoryColour
            cell.textLabel?.textColor = ContrastColorOf(categoryColour, returnFlat: true)
        }
        
        
        
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
            print("Error saving categories \(error)")
        }
        // won't display in table until...
        tableView.reloadData()
    }
    
    func loadCategories() {
        
        categories = realm.objects(Category.self).sorted(byKeyPath: "name", ascending: true)

        tableView.reloadData()
    }
    
    
    
    // MARK: - Delete Date from Swipe
    // override our custom super class method
    override func updateModel(at indexPath: IndexPath) {
        // call superclass - just to demo that updateModel gets called and prints to console - without this, method is not called
        super.updateModel(at: indexPath)
        
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
            // create colour from Chameleon
            newCategory.colour = UIColor.randomFlat.hexValue()
            
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


