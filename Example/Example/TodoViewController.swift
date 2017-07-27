//
//  TodoViewController.swift
//  Hasura-Todo-iOS
//
//  Created by Jaison on 17/01/17.
//  Copyright © 2017 Hasura. All rights reserved.
//

import UIKit
import Hasura

class TodoViewController: UITableViewController {
    
    var data =  [TodoRecord]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Fetch all todos for the user
        client.useDataService(params: [
            "type" : "select",
            "args" : [
                "table"     : "todo",
                "columns"   : ["id","title","completed"],
                "where"     : [
                    "user_id" : user.id!
                ]
            ]
        ]).responseArray { (response: [TodoRecord]?, error: HasuraError?) in
                if let response = response {
                    self.data = response
                    self.tableView.reloadData()
                } else {
                    self.handleError(error: error)
                }
        }
        
    }
    
    
    @IBAction func onAddTodoClicked(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Create a new to-do", message: nil, preferredStyle: .alert)
        alert.addTextField(configurationHandler: nil)
        alert.addAction(UIAlertAction(title: "Add", style: .default, handler: { (action) in
            self.addTodo(newTodoTitle: alert.textFields![0].text!)
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    
    private func addTodo(newTodoTitle: String) {
        client.useDataService(params: [
            "type" : "insert",
            "args" : [
                "table"     : "todo",
                "objects"   : [
                    [
                        "user_id"  : user.id!,
                        "title"    : newTodoTitle,
                        "completed": false
                    ]
                ],
                "returning" : ["id","title","completed"]
            ]
            ]).responseObject { (response: TodoReturningResponse?, error: HasuraError?) in
                if let response = response {
                    self.data.append(contentsOf: response.returning!)
                    self.tableView.reloadData()
                } else {
                    self.handleError(error: error)
                }
        }
    }
    
    @IBAction func onLogoutClicked(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Sign Out",message: "Are you sure you want to sign out?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "SignOut", style: .destructive, handler: { (action) in
            self.performLogout()
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    private func performLogout() {
        
        user.logout { (successful, error) in
            if successful {
                self.dismiss(animated: true, completion: nil)
            } else {
                self.handleError(error: error)
            }
        }
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "todoCell", for: indexPath)
        cell.textLabel!.text = data[indexPath.row].title
        cell.selectionStyle = .none
        
        let record = data[indexPath.row]
        
        
        if record.completed == true {
            //If todo is completed, strike through its text
            let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: cell.textLabel!.text!)
            attributeString.addAttribute(NSStrikethroughStyleAttributeName, value: 2, range: NSMakeRange(0, attributeString.length))
            cell.textLabel!.attributedText = attributeString
        }
                
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedTodo = data[indexPath.row]
        selectedTodo.completed = !selectedTodo.completed
        
        
        client.useDataService(params: [
            "type" : "update",
            "args" : [
                "table"     : "todo",
                "$set"      : [
                    "title"    : selectedTodo.title,
                    "completed": selectedTodo.completed
                ],
                "where"     : [
                    "user_id" : user.id!,
                    "id"      : selectedTodo.id
                ],
                "returning" : ["id","title","completed"]
            ]
        ]).responseObject { (response: TodoReturningResponse?, error: HasuraError?) in
                if let _ = response {
                    self.tableView.reloadRows(at: [indexPath], with: UITableViewRowAnimation.none)
                } else {
                    self.handleError(error: error)
                }
        }
    
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCellEditingStyle.delete {
            
            client.useDataService(params: [
                "type" : "delete",
                "args" : [
                    "table"     : "todo",
                    "where"     : [
                        "user_id" : user.id!,
                        "id"      : data[indexPath.row].id
                    ]
                ]
                ]).responseObject { (response: TodoReturningResponse?, error: HasuraError?) in
                    if let _ = response {
                        self.data.remove(at: indexPath.row)
                        self.tableView.reloadData()
                    } else {
                        self.handleError(error: error)
                    }
            }
        }
    }
    
}

