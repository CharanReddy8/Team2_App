//
//  ActivityTableViewCell.swift
//  Exercise5_Vundela_Venkata
//
//  Created by Sri Vaishnavi Kosana on 10/30/23.
//

import UIKit

class ActivityTableViewCell: UITableViewCell {
    
    @IBOutlet weak var namelbl: UILabel!
    @IBOutlet weak var durationlbl: UILabel!
    @IBOutlet weak var occupancylbl: UILabel!
    @IBOutlet weak var imgg: UIImageView!
    @IBOutlet weak var addresslbl: UILabel!

        override func awakeFromNib() {
            super.awakeFromNib()
            // Initialization code
            layer.cornerRadius = 20
        }

        override func setSelected(_ selected: Bool, animated: Bool) {
            super.setSelected(selected, animated: animated)
            // Configure the view for the selected state
            layer.cornerRadius = 20
        }
    }
