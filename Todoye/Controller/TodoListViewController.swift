//
//  ViewController.swift
//  Todoye
//
//  Created by admin on 24/04/2019.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {

    var itemArray : [Item] = [Item]()
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("items.plist")
    
    @IBAction func addItem(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "New ToDo Item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            if textField.text! != "" {
                let item = Item(itemTitle: textField.text!)
                self.itemArray.append(item)
                self.saveData()
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
        loadData()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        let item = itemArray[indexPath.row]
        cell.textLabel?.text = item.title
        cell.accessoryType = item.completed ? .checkmark : .none
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let _ = tableView.cellForRow(at: indexPath) {
            itemArray[indexPath.row].completed = !itemArray[indexPath.row].completed
            saveData()
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    func saveData() {
        let encoder = PropertyListEncoder()
        do {
            let data = try encoder.encode(itemArray)
            try data.write(to: dataFilePath!)
        } catch {
            print("Cannot encode items: \(error)")
        }
        
        tableView.reloadData()
    }
    func loadData() {
        if let data = try? Data(contentsOf: dataFilePath!) {
            let decoder = PropertyListDecoder()
            do {
                itemArray = try decoder.decode([Item].self, from: data)
            } catch {
                print("Cannot decode items: \(error)")
            }
        }
    }
}

