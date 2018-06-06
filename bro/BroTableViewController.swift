//
//  BroTableViewController.swift
//  bro
//
//  Created by m2sar on 31/05/2018.
//  Copyright © 2018 com.bro. All rights reserved.
//

import UIKit

class BroTableViewController: UITableViewController {
    
    //MARK: Properties
    
    var broList = [Bro]()
    let userDefault = UserDefaults.standard
    let apiRequest = ApiRequest.init()
    var user : User?
    var token : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.contentInset = UIEdgeInsets(top: 20,left: 0,bottom: 0,right: 0)
        let decoded = userDefault.data(forKey: "BrosList")
        if let decoded = decoded{
            broList = NSKeyedUnarchiver.unarchiveObject(with: decoded) as! [Bro]
        }
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Edit", style: UIBarButtonItemStyle.plain, target: self, action: #selector(BroTableViewController.editButtonPressed))
        token = userDefault.string(forKey: "token")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let headerTitles = ["Mes Bros", "En attente"]
        if section < headerTitles.count {
            return headerTitles[section]
        }
        return nil
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return broList.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Table view cells are reused and should be dequeued using a cell identifier.
        let cellIdentifier = "BroTableViewCell"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? BroTableViewCell  else {
            fatalError("The dequeued cell is not an instance of MealTableViewCell.")
        }
        let bro = broList[indexPath.row]
        
        cell.usernameLabel.text = bro.username
        
        return cell
    }
    
    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let indexPath = tableView.indexPathForSelectedRow
        _ = tableView.cellForRow(at: indexPath!)!
    }
    
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            let cell = tableView.cellForRow(at: indexPath)! as? BroTableViewCell
                
            // Delete the row from the data source
            apiRequest.deny(token: token!, receiver: (cell?.usernameLabel.text)!) { (res) -> (Void) in
                if res {
                    self.broList.remove(at: indexPath.row)
                    self.tableView.deleteRows(at: [indexPath], with: .fade)
                }
            }
        }
        else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
            //apiRequest.accept(sender: <#T##String#>, receiver: <#T##String#>, completion: <#T##((Bool) -> (Void))##((Bool) -> (Void))##(Bool) -> (Void)#>)
        }
    }
    
    
    func editButtonPressed(){
        if !self.isEditing {
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.done, target: self, action: #selector(SettingsTableViewController.editButtonPressed))
            self.isEditing = true
        }
        else {
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Edit", style: UIBarButtonItemStyle.plain, target: self, action: #selector(SettingsTableViewController.editButtonPressed))
            self.isEditing = false
        }
    }
    
}
