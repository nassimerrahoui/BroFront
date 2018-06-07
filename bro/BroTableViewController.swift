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
    
    var broList = [String]()
    var waitingList = [String]()
    let userDefault = UserDefaults.standard
    var apiRequest : ApiRequest?
    var user : User?
    var token : String?
    

    override func viewDidLoad() {
        let urlApi = userDefault.string(forKey: "urlApi")
        if let urlApi = urlApi{
            apiRequest = ApiRequest.init(urlAPI: urlApi)
        }
        super.viewDidLoad()
        self.tableView.contentInset = UIEdgeInsets(top: 20,left: 0,bottom: 0,right: 0)
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Edit", style: UIBarButtonItemStyle.plain, target: self, action: #selector(BroTableViewController.editButtonPressed))
        token = userDefault.string(forKey: "token")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if let token = token, let apiRequest = apiRequest {
            apiRequest.getBros(token: token) { (bros) -> (Void) in
                if let bros = bros {
                    self.broList = bros
                }
                self.tableView.reloadData()
            }
            apiRequest.getWaiting(token: token) { (bros) -> (Void) in
                if let bros = bros {
                    self.waitingList = bros
                }
                self.tableView.reloadData()
            }
        }
        for section in 0..<tableView.numberOfSections {
            
            for row in 0..<tableView.numberOfRows(inSection: section) {
                
                let indexPath = IndexPath(row: row, section: section)
                let cell = tableView.cellForRow(at: indexPath)
                if cell?.reuseIdentifier == "HiddenTableViewCell" {
                    self.tableView.deleteRows(at: [indexPath], with: .fade)
                }
            }
        }
        self.isEditing = false
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        self.broList.removeAll()
        self.waitingList.removeAll()
        self.tableView.reloadData()
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
        if broList.count > waitingList.count {
            return broList.count
        }
        else {
            return waitingList.count
        }
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Table view cells are reused and should be dequeued using a cell identifier.
        
        if indexPath.section == 0 {
            let cellIdentifier = "BroTableViewCell"
            if indexPath.row > (broList.count - 1) {

                let cellEmtpy = tableView.dequeueReusableCell(withIdentifier: "HiddenTableViewCell", for: indexPath)
                return cellEmtpy
            }
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? BroTableViewCell  else {
                fatalError("The dequeued cell is not an instance of BroTableViewCell.")
            }
            
            let bro = broList[indexPath.row]
            
            cell.usernameLabel.text = bro
            
            return cell
        }
        else if indexPath.section == 1 {
            let cellIdentifier = "WaitTableViewCell"
            if indexPath.row > (waitingList.count - 1) {

                let cellEmtpy = tableView.dequeueReusableCell(withIdentifier: "HiddenTableViewCell", for: indexPath)
                return cellEmtpy
            }
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? WaitTableViewCell  else {
                fatalError("The dequeued cell is not an instance of WaitTableViewCell.")
            }
            
            let bro = waitingList[indexPath.row]
            
            cell.usernameLabel.text = bro
            
            return cell
        }
        
        let cellEmtpy = tableView.dequeueReusableCell(withIdentifier: "HiddenTableViewCell", for: indexPath)
        return cellEmtpy
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
            if let apiRequest = apiRequest {
            apiRequest.deny(token: token!, receiver: (cell?.usernameLabel.text)!) { (res) -> (Void) in
                    if res {
                        self.broList.remove(at: indexPath.row)
                        self.tableView.deleteRows(at: [indexPath], with: .fade)
                    }
                }
            }
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
