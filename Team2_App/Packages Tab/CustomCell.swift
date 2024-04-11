
import UIKit

class CustomCell: UITableViewCell {
    
    @IBOutlet weak var deal1: UILabel!
    @IBOutlet weak var deptdays: UILabel!
    @IBOutlet weak var dates: UILabel!
    @IBOutlet weak var city: UILabel!
    @IBOutlet weak var logo1: UIImageView!

    @IBOutlet weak var bookNow: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        backgroundColor = UIColor.clear // Set cell's background color to clear
        contentView.backgroundColor = UIColor.clear
        // Apply a larger corner radius to make the cell more round
//        logo1.contentMode = .scaleToFill
        // Remove any border color or style
        layer.borderWidth = 0
        layer.borderColor = UIColor.clear.cgColor
        
        // Apply a larger corner radius to make the cell more round
        layer.cornerRadius = 40
        layer.masksToBounds = true
        
        // Ensure the cell doesn't inherit any background from its superviews
        backgroundView = nil
        contentView.backgroundColor = UIColor.clear
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Apply a larger corner radius to make the cell more round
//        logo1.contentMode = .scaleAspectFill
        layer.cornerRadius = 20
        layer.masksToBounds = true

        // Configure the view for the selected state
    }

}
