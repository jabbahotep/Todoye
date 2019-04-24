//
//  ViewController.swift
//  Todoye
//
//  Created by admin on 24/04/2019.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {

    var itemArray : [String] = []
    let defaults = UserDefaults.standard
  
    @IBAction func addItem(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "New ToDo Item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            if textField.text! != "" {
                self.itemArray.append(textField.text!)
                self.defaults.set(self.itemArray, forKey: "ToDoList")
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
        if let arr = defaults.array(forKey: "ToDoList") as! [String] {
            itemArray = arr
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        cell.textLabel?.text = itemArray[indexPath.row]
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        if cell != nil {
            if cell!.accessoryType == .none {
                print("Not Selected")
                cell?.accessoryType = .checkmark
            } else {
                print("Selected")
                cell?.accessoryType = .none
            }
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

