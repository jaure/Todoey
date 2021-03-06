//
//  ViewController.swift
//  Todoey
//
//  Created by John Ure on 13/01/2018.
//  Copyright © 2018 Soft Touch. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework


class TodoListViewController: SwipeTableViewController {
    
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
    
    var textField = UITextField()
    
    // if we want to change background of search bar, it needs an outlet
    @IBOutlet weak var searchBar: UISearchBar!
    
    
    
    // MARK: - View
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // no dividing lines between cells
        tableView.separatorStyle = .none
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        // use optional chaining
        title = selectedCategory?.name
        
        guard let colourHex = selectedCategory?.colour
            else {
                fatalError()
        }
        
        updateNavBar(withHexCode: colourHex)
    }
    
    // just before view gets destroyed
    override func viewWillDisappear(_ animated: Bool) {
        updateNavBar(withHexCode: "1D9BF6")

    }
    
    
    
    // MARK: - Nav Bar Setup Methods
    func updateNavBar(withHexCode colourHexCode: String)  {
        guard let navBar = navigationController?.navigationBar else {
            fatalError("Navigation controller does not exist.")
        }
        
        guard let navBarColour = UIColor(hexString: colourHexCode) else {
            fatalError()
        }
        
        navBar.barTintColor = navBarColour
        
        navBar.tintColor = ContrastColorOf(navBarColour, returnFlat: true)
        
        navBar.largeTitleTextAttributes = [NSAttributedStringKey.foregroundColor: ContrastColorOf(navBarColour, returnFlat: true)]
        
        searchBar.barTintColor = navBarColour

    }
    
    
    
    // MARK: - Tableview Datasource
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // optional chaining, if todoItems is not nil then return the count, but if nil then return 1
        return todoItems?.count ?? 1
    }
    
    
    
    // This method gets called for every cell in the table view, dependent on number of rows
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Get cell from super class
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        
        if let item = todoItems?[indexPath.row] {
            cell.textLabel?.text = item.title
            // Chameleon
            // optional binding todoItems?, calc colour tint for each row, cast as CGFloat (for both whole numbers) - get the count if todoItems is not nil and divide the row number by the count to calc the percentage tint - todoItems will always have a value by this point so we can force unwrap with ! rather than using ?
            //if let colour = FlatSkyBlue().darken(byPercentage: CGFloat(indexPath.row) / CGFloat(todoItems!.count))
            if let colour = UIColor(hexString: selectedCategory!.colour)?.darken(byPercentage: (CGFloat(indexPath.row) / CGFloat(todoItems!.count)) / 7)
                // do a further division to get a lighter overall tint
                // above uses saved colour from Category, force unwraps(!) 'cos it can't be nil, then optionally chains(?) in case there is no UIColor.
            {
                cell.backgroundColor = colour
                // set text to black or white depending on background colour of cell using Chameleon
                cell.textLabel?.textColor = ContrastColorOf(colour, returnFlat: true)
                // set checkmark to contrasting b/w
                cell.tintColor = ContrastColorOf(colour, returnFlat: true)
            }
            
            cell.accessoryType = item.done ? .checkmark : .none
        } else {
            cell.textLabel?.text = "No Items Added"
        }
        
        return cell
    }
    
    
    
    
    
    
    
    // MARK: - Tableview Delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let item = todoItems?[indexPath.row] {
            // can throw, use do-catch
            do {
                // if not nil, toggle the check
                try realm.write {
                    // delete
                    //realm.delete(item)
                    item.done = !item.done
                }
            } catch {
                print("Error saving done status, \(error)")
            }
        }
        
        // update to reflect the check status
        tableView.reloadData()
        
        // don't leave selected row as gray background.
        // deselect and animate leaving white background.
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    
    
    
    // MARK: - Add New Items
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        // local var to work in closures
        //var textField = UITextField()
        
        // show an alert with text field and append to array
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            // what happens when alert clicked
            print("Success!")
            // go to alertTextField closure where local var is set and then print to console
            print(self.textField.text!)
            
            
            if let currentCategory = self.selectedCategory {
                
                self.save(currentCategory: currentCategory)
            }
            
        }
        
        // this closure only gets triggered once text field has been added to alert
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            
            self.textField = alertTextField
            // above local var is used in action closure
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    
    
    // MARK: - Delete Data from Swipe
    // override our custom super class method
    override func updateModel(at indexPath: IndexPath) {
        super.updateModel(at: indexPath)
        
        if let itemToDelete = self.todoItems?[indexPath.row] {
            do {
                try self.realm.write {
                    print("Item deleted")
                    self.realm.delete(itemToDelete)
                }
            } catch {
                print("Error deleting item, \(error)")
            }
        }
    }
    
    
    
    
    // MARK: - Model Manipulation Methods
    
    func save(currentCategory: Category) {
        
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
        // update table view with new item
        self.tableView.reloadData()
    }
    
    
    
    
    func loadItems() {
        // use relationship, sort alphabetically
        todoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
        
        tableView.reloadData()
    }

}

// MARK: - Extension
extension TodoListViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        // filter according to text entered using title, ignoring case and diacritics, then sort
        todoItems = todoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "title", ascending: true)
        tableView.reloadData()
    }
    
    
    // when user clears search bar:
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            // text has changed, but now empty
            // fetch all items
            loadItems()
            
            // we want UI to update even if background events are happening
            // get main thread so search bar is on main queue in foreground
            DispatchQueue.main.async {
                // tell search bar that it is no longer the active object, dismiss onscreen keyboard
                searchBar.resignFirstResponder()
            }
            
            
        }
    }
}

