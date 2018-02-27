//
//  MeTableViewController.swift
//  42Swift
//
//  Created by Benjamin Pisano on 27/02/2018.
//  Copyright © 2018 bpisano. All rights reserved.
//

import UIKit

class FTMeTableViewController: UITableViewController {
    
    var userList = [FTUser]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        FTLoadingAnimatorView().addLoadingAnimator(in: self.navigationController?.view)
        FTApi().getAllUsers(page: 0) { (error, users) in
            FTLoadingAnimatorView().removeLoadingAnimator(from: self.navigationController?.view)
            
            guard error == nil && users != nil else {
                return
            }
            
            self.userList = users!
            self.userList = self.userList.sorted(by: { (user1, user2) -> Bool in
                return user1.username < user2.username
            })
            self.tableView.reloadData()
        }
    }
    
    

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userList.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "user", for: indexPath)
        let user = userList[indexPath.row]
        
        cell.textLabel?.text = user.username
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedUser = userList[indexPath.row]
        FTApi().setCurrentUserID(selectedUser.id)
        
        self.dismiss(animated: true) {
            
        }
    }

    @IBAction func cancel(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
