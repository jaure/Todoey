//
//  SwipeTableViewController.swift
//  Todoey
//
//  Created by John Ure on 28/01/2018.
//  Copyright © 2018 Soft Touch. All rights reserved.
//

import UIKit
import SwipeCellKit

class SwipeTableViewController: UITableViewController, SwipeTableViewCellDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        // make trash icon show up ok when swiping row from right.
        tableView.rowHeight = 80.0
    }
    
    
    
    
    // MARK: - TableView Datasource Methods
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // ID set in Main.storyboard.
        // Also in Main.storyboard, change Cell to custom class SwipeTableViewCell and change module to SwipeCellKit.
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! SwipeTableViewCell
        
        // Set delegate for SwipeCellKit
        cell.delegate = self
        
        return cell
    }
    
    // required delegate method
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }
        
        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
            // handle action by updating model with deletion, self used inside closure
            self.updateModel(at: indexPath)
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
    
    
    // Update data model, called from editActionsForRowAt
    func updateModel(at indexPath: IndexPath) {
        
        print("Item deleted from superclass")
    }

}

