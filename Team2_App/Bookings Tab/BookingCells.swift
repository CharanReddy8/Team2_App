//
//  BookingCells.swift
//  Team2_App
//
//  Created by Charan Reddy on 10/31/23.
//

import UIKit

class BookingCells: UITableViewCell {
        
        @IBOutlet weak var namelbl: UILabel!
        @IBOutlet weak var durationlbl: UILabel!
        @IBOutlet weak var occupancylbl: UILabel!
        @IBOutlet weak var imgg: UIImageView!
        
        var cancelAction: (() -> Void)?

        @IBAction func cancelBooking(_ sender: UIButton) {
        cancelAction?()
        }

            override func awakeFromNib() {
                super.awakeFromNib()
                
                backgroundColor = UIColor.clear // Set cell's background color to clear
                contentView.backgroundColor = UIColor.clear
                // Apply a larger corner radius to make the cell more round
                //logo1.contentMode = .scaleToFill
                // Remove any border color or style
                layer.borderWidth = 0
                layer.borderColor = UIColor.clear.cgColor
                
                // Ensure the cell doesn't inherit any background from its superviews
                backgroundView = nil
                contentView.backgroundColor = UIColor.clear
                
                // Initialization code
                layer.cornerRadius = 20
                layer.masksToBounds = true
            }

            override func setSelected(_ selected: Bool, animated: Bool) {
                super.setSelected(selected, animated: animated)
                // Configure the view for the selected state
            }
        }

class NoBookingCell: UITableViewCell {
        
    @IBOutlet weak var NotextLabel: UILabel!

            override func awakeFromNib() {
                super.awakeFromNib()
                // Initialization code
                layer.cornerRadius = 20
                layer.masksToBounds = true
            }

        }

