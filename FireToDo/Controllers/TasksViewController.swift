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
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  10
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.backgroundColor = .clear
        cell.textLabel?.text  = "Cell #  \(indexPath.row)"
        cell.textLabel?.textColor = .white
        return cell
    }

    @IBAction func addButtonTapped(_ sender: UIBarButtonItem) {
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
