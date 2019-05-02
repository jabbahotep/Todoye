//
//  ViewController.swift
//  Todoye
//
//  Created by admin on 24/04/2019.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit
import RealmSwift

class TodoListViewController: UITableViewController {
    
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

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(itemArray?.count)
        if let cnt = itemArray?.count {
            return cnt > 0 ? cnt : 0
        } else {
            return 1
        }
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        if let item = itemArray?[indexPath.row] {
            cell.textLabel?.text = item.title
            cell.accessoryType = item.completed ? .checkmark : .none
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
