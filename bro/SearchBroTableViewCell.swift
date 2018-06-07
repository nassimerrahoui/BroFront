//
//  SearchBroTableViewCell.swift
//  bro
//
//  Created by user910056 on 6/7/18.
//  Copyright © 2018 com.bro. All rights reserved.
//

import UIKit

class SearchBroTableViewCell: UITableViewCell {
    
    //MARK: Properties
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var Add: UIButton!
    let userDefault = UserDefaults.standard
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    @IBAction func acceptFriend(_ sender: UIButton) {
        let apiRequest = ApiRequest.init(urlAPI: userDefault.string(forKey: "urlApi")!)
        let token = userDefault.string(forKey: "token")
        
        // Delete the row from the data source
        apiRequest.sendInvitation(token: token!, receiver: (self.usernameLabel.text)!) { (res) -> (Void) in
            if res {
                self.Add.isEnabled = false
                self.Add.isHidden = true
            }
        }
        
    }
}
