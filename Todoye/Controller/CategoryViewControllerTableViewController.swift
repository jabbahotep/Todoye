
//
//  CategoryViewControllerTableViewController.swift
//  Todoye
//
//  Created by admin on 25/04/2019.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class CategoryViewControllerTableViewController: SwipeTableViewController {
    
    let realm = try! Realm()
    
    var categoryArray: Results<Category>?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        loadData()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray?.count ?? 1
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        cell.textLabel?.text = categoryArray?[indexPath.row].name ?? "No categories"
        cell.backgroundColor = UIColor.init(hexString: categoryArray?[indexPath.row].bgcolor ?? "FFFFFF")
        cell.textLabel?.textColor = ContrastColorOf(cell.backgroundColor!, returnFlat: true)
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let _ = tableView.cellForRow(at: indexPath) {
            performSegue(withIdentifier: "goToItems", sender: self)
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.category = categoryArray?[indexPath.row]	
        }
    }

    
    @IBAction func addCategory(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "New Category", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Category", style: .default) { (action) in
            if textField.text! != "" {
                let category = Category()
                category.name = textField.text!
                category.bgcolor = UIColor.randomFlat.hexValue()
                self.saveData(category: category)
                self.tableView.reloadData()
            }
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Type the category name"
            textField = alertTextField
        }
        alert.addAction(action)
        present(alert, animated: true) {
            
        }
    }

    func saveData(category: Category) {
        do {
            try realm.write {
                realm.add(category)
            }
        } catch {
            print("Cannot save items: \(error)")
        }
        
    }
    func loadData() {
        categoryArray = realm.objects(Category.self)
        tableView.reloadData()
    }
    override func updateModel(at: IndexPath) {
        do {
            try self.realm.write{
                if let item = self.categoryArray?[at.row] {
                    self.realm.delete(item)
                }
            }
        } catch {
            print("Error deleting category: \(error)")
        }
    }
}
