//
//  TasksViewController.swift
//  FireToDo
//
//  Created by Pavel on 5/11/19.
//  Copyright © 2019 Pavel. All rights reserved.
//

import UIKit
import Firebase

class TasksViewController: UIViewController, UITableViewDelegate,  UITableViewDataSource {

    var myUser: MyUser!
    var ref: DatabaseReference!
    var tasks = Array<Task>()

    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        guard let currentUser = Auth.auth().currentUser else { return }
        print("CURRENT  USER IS \(currentUser)")
        myUser  = MyUser(user: currentUser)
        ref = Database.database().reference(withPath: "users").child(String(myUser.uid)).child("tasks")

    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        ref.observe(.value, with: { [weak self] (snapshot) in

            var _tasks = Array<Task>()

            for item  in snapshot.children {
                let task = Task(snapshot: item as! DataSnapshot)
                _tasks.append(task)
            }

            self?.tasks = _tasks
            self?.tableView.reloadData()

        })
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  tasks.count
    }

    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let task = tasks[indexPath.row]
            task.ref?.removeValue()
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) else { return }
        let task = tasks[indexPath.row]
        let isCompleted = !task.completed
        toggleCompletion(cell, isCompleted: isCompleted)
        task.ref?.updateChildValues(["completed":  isCompleted])
    }

    func toggleCompletion(_ cell: UITableViewCell, isCompleted: Bool) {
        cell.accessoryType = isCompleted ? .checkmark : .none
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)

        let task = tasks[indexPath.row]
        let taskTitle  = task.title
        let isCompleted = task.completed

        cell.backgroundColor = .clear
        cell.textLabel?.textColor = .white
        cell.textLabel?.text  = taskTitle
        toggleCompletion(cell, isCompleted: isCompleted)

        return cell
    }

    @IBAction func addButtonTapped(_ sender: UIBarButtonItem) {

        let alertController = UIAlertController(title: "New task", message: "Add new task", preferredStyle: .alert)
        alertController.addTextField()

        let save = UIAlertAction(title: "Save", style: .default) {[weak self] _ in
            guard let textField = alertController.textFields?.first, textField.text != "" else { return }
            let task = Task(title: textField.text!, userId: (self?.myUser.uid)!)
            let taskRef =  self?.ref.child(task.title.lowercased())

            taskRef?.setValue(task.convertToDictionary())
        }

        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)

        alertController.addAction(save)
        alertController.addAction(cancel)

        present(alertController, animated: true, completion: nil)

    }

    @IBAction func signOutButtonTapped(_ sender: UIBarButtonItem) {
        do {
            try Auth.auth().signOut()
        } catch {
            print(error.localizedDescription)
        }
        dismiss(animated: true, completion: nil)
    }
    
}
