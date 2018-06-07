//
//  SearchTableViewController.swift
//  bro
//
//  Created by user910056 on 6/7/18.
//  Copyright © 2018 com.bro. All rights reserved.
//

import UIKit

class SearchTableViewController: UITableViewController, UISearchResultsUpdating, UISearchBarDelegate {
    
    @IBOutlet weak var searchBroBar: UISearchBar!
    
    let searchController = UISearchController(searchResultsController: nil)
    var broPossibleList = [String]()
    var waitingList = [String]()
    let userDefault = UserDefaults.standard
    var apiRequest : ApiRequest?
    var user : User?
    var token : String?
    var filteredBros = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        let urlApi = userDefault.string(forKey: "urlApi")
        if let urlApi = urlApi{
            apiRequest = ApiRequest.init(urlAPI: urlApi)
        }

        token = userDefault.string(forKey: "token")
        searchController.searchResultsUpdater = self as UISearchResultsUpdating
        searchController.obscuresBackgroundDuringPresentation = false
        searchBroBar.placeholder = "Search Possible Bros..."
        self.tableView.tableHeaderView = searchBroBar
        definesPresentationContext = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if let token = token, let apiRequest = apiRequest {
            apiRequest.getPossibleBros(token: token) { (bros) -> (Void) in
                if let bros = bros {
                    self.broPossibleList = bros
                }
                self.tableView.reloadData()
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchBroBar.text!)
    }
    
    func searchBarIsEmpty() -> Bool {
        // Returns true if the text is empty or nil
        if let searchBroBar = searchBroBar.text{
            return searchBroBar.isEmpty 
        }
        return false
    }
    
    func filterContentForSearchText(_ searchText: String, scope: String = "All") {
        filteredBros = self.broPossibleList.filter({( bro : String) -> Bool in
            return bro.lowercased().contains(searchText.lowercased())
        })
        
        tableView.reloadData()
    }
    
    
    func isFiltering() -> Bool {
        return searchController.isActive && !searchBarIsEmpty()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering() {
            return filteredBros.count
        }
        
        return broPossibleList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as? SearchBroTableViewCell  else {
            fatalError("The dequeued cell is not an instance of WaitTableViewCell.")
        }
        let bro: String
        if isFiltering() {
            print("filter")
            bro = filteredBros[indexPath.row]
        } else {
            print("no filter")
            bro = broPossibleList[indexPath.row]
        }
        cell.usernameLabel.text = bro
        return cell
    }

}
