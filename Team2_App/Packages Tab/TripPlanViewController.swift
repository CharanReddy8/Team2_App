//
//  TripPlanViewController.swift
//
//  Created by Sri Vaishnavi Kosana on 10/30/23.
//

import UIKit

class TripPlanViewController: UIViewController, UITableViewDataSource {

    @IBOutlet weak var activitytable: UITableView!

    var activities: [Activity] = [] // This will store the activity data

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let blueColor = UIColor(red: 189/255.0, green: 235/255.0, blue: 245/255.0, alpha: 1.0)
        let pinkColor = UIColor(red: 245/255.0, green: 189/255.0, blue: 189/255.0, alpha: 1.0)
                // Create a gradient layer
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = view.bounds
        gradientLayer.colors = [blueColor.cgColor, pinkColor.cgColor]
                
                // Adjust the startPoint and endPoint for a vertical gradient
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1.0)

                // Add the gradient layer to the view's layer
        view.layer.insertSublayer(gradientLayer, at: 0)

        // Assign the table view data source
        activitytable.dataSource = self

        // Set the row height for the table view
        activitytable.rowHeight = 300// Set the desired cell height here

        if let savedData = UserDefaults.standard.data(forKey: "myDataKey"),
           let decodedPlace = try? JSONDecoder().decode(Place.self, from: savedData) {

            // Assign the activities to your data source array
            activities = decodedPlace.activities

            // Reload the table view
            activitytable.reloadData()
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return activities.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "activityCell", for: indexPath) as! ActivityTableViewCell

        let activity = activities[indexPath.row]

        cell.namelbl.text = activity.title
        cell.addresslbl.text = activity.address
        cell.durationlbl.text = activity.duration
        cell.occupancylbl.text = activity.occupancy
        cell.imgg.image = UIImage(named: activity.imageName)
        
        cell.contentView.layer.cornerRadius = 10 // You can adjust this value based on your preference
        cell.contentView.layer.masksToBounds = true
        
        //cell.accessoryType = .none
        ////dddfborder/
        cell.layer.borderColor = UIColor.lightGray.cgColor
        cell.layer.borderWidth = 1

        // Add spacing by setting the cell's top margin
        cell.frame = cell.frame.inset(by: UIEdgeInsets(top: 10, left: 10, bottom: 0, right: 10))

        cell.accessoryType = .none
        

        return cell
    }
}
