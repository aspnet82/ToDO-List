//
//  CategoryTableViewController.swift
//  ToDO
//
//  Created by Alessandro Spedito on 23/03/2020.
//  Copyright © 2020 Alessandro Spedito Photography. All rights reserved.
//

import UIKit
import CoreData

class CategoryTableViewController: UITableViewController {
    
    var categories = [Category]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.leftBarButtonItem = self.editButtonItem
        loadData()
        
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "categoryCell")
        let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell", for: indexPath)
        cell.textLabel?.text = categories[indexPath.row].name
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = UIContextualAction(style: .destructive, title: "Delete") { (action, view, done) in
            self.context.delete(self.categories[indexPath.row])
            self.categories.remove(at: indexPath.row)
            self.saveData()
            self.tableView.reloadData()
            done(true)
        }
        
        let edit = UIContextualAction(style: .normal, title: "Edit") { (action, view, done) in
            //self.categories[indexPath.row].name = "I have changed this"
            // TODO: - Code to change text
            self.saveData()
            tableView.reloadData()
            done(true)
        }
        
        edit.image = UIImage(systemName: "pencil")
        
        return UISwipeActionsConfiguration(actions: [edit, delete])
    }
    
    // TOFIX - CELLS MOVE BUT ARE NOT REGISTERED IN CORE DATA
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let newArray = try! categories.move(from: sourceIndexPath.row, to: destinationIndexPath.row)
        categories = newArray
        
        self.saveData()
        tableView.reloadData()
    }
    
    
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    

    @IBAction func addCategoryPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alertController = UIAlertController(title: "Add Category", message: "", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "ADD", style: .default, handler: { (action) in
            // Code when the widnow close
            let category = Category(context: self.context)
            category.name = textField.text
            self.categories.insert(category, at: 0)
            self.saveData()
            self.tableView.reloadData()
        }))
        
        alertController.addTextField { (field) in
            textField = field
            textField.placeholder = "Add a category"
        }
        
        present(alertController, animated: true, completion: nil)
        
    }
    
    func loadData() {
        let request: NSFetchRequest<Category> = Category.fetchRequest()
        do {
            categories = try context.fetch(request)
        } catch {
            print("Eror fetching data: \(error)")
        }
        
        tableView.reloadData()
    }
    
    func saveData() {
        do {
            try context.save()
            print("data saved")
        } catch {
            print("Error saving the context: \(error)")
        }
        
        tableView.reloadData()
        
    }
}
