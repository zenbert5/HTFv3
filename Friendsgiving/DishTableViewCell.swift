//
//  DishTableViewCell.swift
//  Friendsgiving
//
//  Created by Robert Bridgeman on 11/14/18.
//  Copyright © 2018 Robert Bridgeman. All rights reserved.
//

import UIKit

class DishTableViewCell: UITableViewCell {

    @IBOutlet weak var dishLabel: UILabel!
    @IBOutlet weak var userDishLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
