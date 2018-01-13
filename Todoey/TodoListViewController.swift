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
    let itemArray = ["Item One", "Item Two", "Item Three"]
    
    
    
    // MARK: - View
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
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


}

