//
//  ViewController.swift
//  Todoey
//
//  Created by John Ure on 13/01/2018.
//  Copyright © 2018 Soft Touch. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {
    
    // MARK: - Properties
    var itemArray = ["Item One", "Item Two", "Item Three"]
    // persistent storage
    let defaults = UserDefaults.standard
    
    
    
    
    // MARK: - View
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        print("viewDidLoad")
        
        // get data from user defaults cast as array of strings
        //itemArray = defaults.array(forKey: "TodoListArray") as! [String]
        
        // it's best to error check the above code and use optional rather than a forced downcast:
        if let items = defaults.array(forKey: "TodoListArray") as? [String] {
            itemArray = items
        }
    }
    
    
    
    // MARK: - Tableview Datasource
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return itemArray.count
    }
    
    
    
    // This method gets called for every cell in the table view, dependent on number of rows
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Only load the visible cells, cells get reused.
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        // display cell with data
        cell.textLabel?.text = itemArray[indexPath.row]
        
        return cell
    }
    
    
    
    // MARK: - Tableview Delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // print row number to console
        print(indexPath.row)
        
        // print item name to console
        //let menuItem = itemArray[indexPath.row]
        //print(menuItem)
        // Above two lines are same as:
        print(itemArray[indexPath.row])
        
        // Add checkmark using accessory
        //tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        
        // Check to see if current cell has checkmark
        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
            // change to none
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        } else {
            // add a checkmark
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        }
        
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
            
            // add to array with force unwrap 'cos field will never be empty - it will be at least "" - and use self cos in closure
            self.itemArray.append(textField.text!)
            // add to user defaults, a plist file - we need to use value-key.
            // we need to load this to see added data.
            // see AppDelegate didFinishLaunching...
            // and viewDidLoad()
            self.defaults.set(self.itemArray, forKey: "TodoListArray")
            // won't display in table until...
            self.tableView.reloadData()
        }
        
        // this closure only gets triggered once text field has been added to alert
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            // this doesn't print, needs local var
            //print(alertTextField.text)
            textField = alertTextField
            // above local var is now used in action closure
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
}

