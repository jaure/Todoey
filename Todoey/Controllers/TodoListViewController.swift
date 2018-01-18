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
    
    // create array from data model
    var itemArray = [Item]()
    
    // persistent storage
    // Get file path to document directory in user's home directory using FileManager singleton
    // Grab first item as this is an array and add a plist file - this only creates the path
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    
    
    
    
    // MARK: - View
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        print(dataFilePath!)
        
        // load our data
        loadItems()
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
        //cell.textLabel?.text = itemArray[indexPath.row]
        //cell.textLabel?.text = itemArray[indexPath.row].title
        // replaces above code
        let item = itemArray[indexPath.row]
        cell.textLabel?.text = item.title
        /*
        if itemArray[indexPath.row].done == true {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }*/
        // replace above code:
        /*if item.done == true {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }*/
        
        // ternary operator replaces above code
        // value = condition ? valueIfTrue : valueIfFalse
        //cell.accessoryType = item.done == true ? .checkmark : .none
        // further compacted:
        cell.accessoryType = item.done ? .checkmark : .none
        // above sets the accessoryType - if true set checkmark, if false set to none
        
        return cell
    }
    
    
    
    // MARK: - Tableview Delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // Sets the done property as it stands to its opposite
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
        saveItems()
        
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
            
            let newItem = Item()
            newItem.title = textField.text!
            
            // add to array and use self cos in closure
            self.itemArray.append(newItem)
            
            self.saveItems()
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
    
    
    
    
    // MARK: - Model Manipulation Methods
    func saveItems() {
        // add a plist file with our data
        let encoder = PropertyListEncoder()
        
        do {
            let data = try encoder.encode(itemArray)
            // write data to file path
            try data.write(to: dataFilePath!)
        } catch {
            print("Error encoding item array, \(error)")
        }
        // won't display in table until...
        tableView.reloadData()
    }
    
    
    
    
    func loadItems() {
        // get our data, method can throw an error so use try which turns constant into optional
        if let data = try? Data(contentsOf: dataFilePath!) {
            // create new object to decode data
            let decoder = PropertyListDecoder()
            do {
            itemArray = try decoder.decode([Item].self, from: data)
            } catch {
                print("Error decoding item array, \(error)")
            }
        }
    }
    
}

