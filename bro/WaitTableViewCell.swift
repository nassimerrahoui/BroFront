//
//  BroTableViewCell.swift
//  bro
//
//  Created by m2sar on 31/05/2018.
//  Copyright © 2018 com.bro. All rights reserved.
//

import UIKit

class WaitTableViewCell: UITableViewCell {
    
    //MARK: Properties
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var accept: UIButton!
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
            apiRequest.accept(token: token!, receiver: (self.usernameLabel.text)!) { (res) -> (Void) in
                if res {
                    self.accept.isEnabled = false
                    self.accept.isHidden = true
            }
        }
             
    }
}
