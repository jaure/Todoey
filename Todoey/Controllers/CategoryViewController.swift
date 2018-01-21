//
//  CategoryViewController.swift
//  Todoey
//
//  Created by John Ure on 20/01/2018.
//  Copyright © 2018 Soft Touch. All rights reserved.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController {
    
    // MARK: - Properties
    
    // create array from data model, init as empty
    var categoryArray = [Category]()
    
    
    // persistent storage
    // for Core Data, get context from AppDelegate
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    
    

    // MARK: - View
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loadItems()
    }

    
    
    
    // MARK: - TableView Datasource methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return categoryArray.count
    }
    
    
    
    // This method gets called for every cell in the table view, dependent on number of rows
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Only load the visible cells, cells get reused.
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        
        // display cell with data
        //let category = categoryArray[indexPath.row]
        //cell.textLabel?.text = category.name
        cell.textLabel?.text = categoryArray[indexPath.row].name
        
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
            destinationVC.selectedCategory = categoryArray[indexPath.row]
        }
    }
    
    
    // MARK: - Data Manipulation Methods
    
    func saveItems() {
        
        do {
            // save temp area (context) to persistent store
            try context.save()
        } catch {
            print("Error saving context \(error)")
        }
        // won't display in table until...
        tableView.reloadData()
    }
    
    // add a default value with none specified for Category
    func loadItems(with request: NSFetchRequest<Category> = Category.fetchRequest()) {
        // we have to go through the context to get our data - this can throw an error so use try inside a do catch block
        do {
            // save data in our array
            categoryArray = try context.fetch(request)
        } catch {
            print("Error fetching data from context \(error)")
        }
        
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
            
            // create new category of type NSManagedObject with 1 x attribute
            let newCategory = Category(context: self.context)
            newCategory.name = textField.text!
            
            // add to array and use self cos in closure
            self.categoryArray.append(newCategory)
            
            self.saveItems()
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
