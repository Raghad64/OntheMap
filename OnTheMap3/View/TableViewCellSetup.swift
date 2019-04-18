//
//  setUpTableViewCell.swift
//  OnTheMap3
//
//  Created by Raghad Mah on 09/01/2019.
//  Copyright © 2019 Udacity. All rights reserved.
//

import UIKit

class TableViewCellSetup: UITableViewCell {
    
    
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var urlLabel: UILabel!
    
    func fillCell(data: Results){
        
        if let first = data.firstName, let last = data.lastName, let url = data.mediaURL {
            
            nameLabel.text = "\(first) \(last)"
            urlLabel.text = "\(url)"
        }
    }

}
