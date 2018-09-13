//
//  TblCell.swift
//  TaskGoogleMap
//
//  Created by kiran on 9/12/18.
//  Copyright © 2018 kiran. All rights reserved.
//

import UIKit

class TblCell: UITableViewCell {
    @IBOutlet weak var locationLable: UILabel!
    @IBOutlet weak var tempLable: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
