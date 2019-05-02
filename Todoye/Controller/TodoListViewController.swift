//
//  ViewController.swift
//  Todoye
//
//  Created by admin on 24/04/2019.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class TodoListViewController: SwipeTableViewController {
    
    let realm = try! Realm()

    var itemArray : Results<Item>?
    var category : Category? {
        didSet {
            loadData()
        }
    }

    @IBOutlet weak var itemSearch: UISearchBar!
    
    @IBAction func addItem(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "New ToDo Item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            if textField.text! != "" {
                if let currentCategory = self.category {
                    do {
                        try self.realm.write{
                            let item = Item()
                            item.title = textField.text!
                            currentCategory.items.append(item)
                        }
                    } catch {
                        print("Error saving data: \(error)")
                    }
                }
                self.tableView.reloadData()
            }
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Type what you need to do"
            textField = alertTextField
        }
        alert.addAction(action)
        present(alert, animated: true) {
            
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        itemSearch.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        guard let hexColor = category?.bgcolor else {
            fatalError("Category has no background color set")
        }
        guard let navBar = navigationController?.navigationBar else {
            fatalError("Cannot get navigation bar")
        }
        guard let bgColor = UIColor(hexString: hexColor) else {
            fatalError("Cannot get UIColor from category color string")
        }
        title = category?.name
        let fgColor = ContrastColorOf(bgColor, returnFlat: true)
        navBar.barTintColor = bgColor
        navBar.tintColor = fgColor
        navBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: fgColor]
        navBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: fgColor]
        itemSearch.barTintColor = bgColor
        itemSearch.layer.borderColor = bgColor.cgColor
        itemSearch.layer.borderWidth = 1
    }
    override func viewWillDisappear(_ animated: Bool) {
        guard let bgColor = UIColor(hexString: "1D9BF6") else {
            fatalError("Cannot get UIColor from static color string")
        }
        guard let navBar = navigationController?.navigationBar else {
            fatalError("Cannot get navigation bar")
        }
        let fgColor = ContrastColorOf(bgColor, returnFlat: true)
        navBar.barTintColor = bgColor
        navBar.tintColor = fgColor
        navBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: fgColor]
        navBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: fgColor]
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let cnt = itemArray?.count {
            return cnt > 0 ? cnt : 0
        } else {
            return 1
        }
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        if let item = itemArray?[indexPath.row] {
            cell.textLabel?.text = item.title
            cell.accessoryType = item.completed ? .checkmark : .none
            cell.backgroundColor = UIColor(hexString: category!.bgcolor)!.darken(byPercentage: CGFloat(indexPath.row) / CGFloat(itemArray!.count))
            cell.tintColor = ContrastColorOf(cell.backgroundColor!, returnFlat: true)
            cell.textLabel?.textColor = cell.tintColor
        } else {
            cell.textLabel?.text = "No items added"
        }
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let _ = tableView.cellForRow(at: indexPath) {
            do {
                try self.realm.write{
                    if let item = itemArray?[indexPath.row] {
                        item.completed = !item.completed
                    }
                }
            } catch {
                print("Error saving data: \(error)")
            }
        }
        tableView.deselectRow(at: indexPath, animated: true)
        tableView.reloadData()
    }
    func loadData(term: NSPredicate? = nil) {
        if term != nil {
            itemArray = category?.items.sorted(byKeyPath: "createdAt", ascending: true).filter(term!)
        } else {
            itemArray = category?.items.sorted(byKeyPath: "createdAt", ascending: true)
        }
        tableView.reloadData()
    }
    override func updateModel(at: IndexPath) {
        do {
            try self.realm.write{
                if let item = self.itemArray?[at.row] {
                    self.realm.delete(item)
                }
            }
        } catch {
            print("Error deleting category: \(error)")
        }
    }
}

// MARK: - Search delegate functions
extension TodoListViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        loadData(term: predicate)
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadData()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
}
