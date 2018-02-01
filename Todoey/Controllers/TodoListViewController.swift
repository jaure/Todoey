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
        // Chameleon, set nav bar (and status) tint colour to Category colour
        // UIColor needs a non-optional string so use optional binding rather than force unwrap
        //if let colourHex = selectedCategory?.colour {
            // if navController not nil, set bar colour but navController doesn't exist until viewWillAppear so don't use in viewDidLoad
            //navigationController?.navigationBar.barTintColor = UIColor(hexString: colourHex)
            
            // selectedCat will not be nil at this stage so unwrap to change title to name of category:
            //title = selectedCategory!.name
            
            // guard against navController being nil:
            //guard let navBar = navigationController?.navigationBar
                //else {
                    //fatalError("Navigation controller does not exist.")
           // }
            
            // output is optional UIColor so add another test
            //if let navBarColour = UIColor(hexString: colourHex) {
                //navBar.barTintColor = navBarColour
                
                // set navBar control colours to contrast with background using Chameleon
                //navBar.tintColor = ContrastColorOf(UIColor(hexString: colourHex), returnFlat: true)
                //navBar.tintColor = ContrastColorOf(navBarColour, returnFlat: true)
                
                // change title attribs using large option using a dictionary and Chameleon for contrast
                // change + to default in storybd
                //navBar.largeTitleTextAttributes = [NSAttributedStringKey.foregroundColor: ContrastColorOf(navBarColour, returnFlat: true)]
                
                
                // set background colour of search bar to same as navBar
                //searchBar.barTintColor = UIColor(hexString: colourHex)
                //searchBar.barTintColor = navBarColour
            //}
            
            
        //}
        //navigationController?.navigationBar.barTintColor = UIColor(hexString: selectedCategory?.colour)
        
        // use guard instead of if-let as we're not using else statements to reduce if-let pyramid:
        guard let navBar = navigationController?.navigationBar else {
            fatalError("Navigation controller does not exist.")
        }
        
        guard let colourHex = selectedCategory?.colour
            else {
                fatalError()
        }
        // use optional chaining
        title = selectedCategory?.name
        
        guard let navBarColour = UIColor(hexString: colourHex) else {
            fatalError()
        }
        
        navBar.barTintColor = navBarColour
        
        navBar.tintColor = ContrastColorOf(navBarColour, returnFlat: true)
        
        navBar.largeTitleTextAttributes = [NSAttributedStringKey.foregroundColor: ContrastColorOf(navBarColour, returnFlat: true)]
        
        searchBar.barTintColor = navBarColour
    }
    
    // just before view gets destroyed
    override func viewWillDisappear(_ animated: Bool) {
        // guard against hex being wrong/nil
        guard let originalColour = UIColor(hexString: "1D9BF6")
            else {
                fatalError()
        }
        // controller will exist at this point, set default color
        navigationController?.navigationBar.barTintColor = originalColour
        // also reset controls using Chameleon
        navigationController?.navigationBar.tintColor = FlatWhite()
        navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedStringKey.foregroundColor: FlatWhite()]
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
        
        // display cell with data
        // optional chaining, if not nil then grab the items at indexPath.row
//        cell.textLabel?.text = todoItems?[indexPath.row].title ?? "No Items added yet"
//        cell.accessoryType = (todoItems?[indexPath.row].done)! ? .checkmark : .none
        
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

