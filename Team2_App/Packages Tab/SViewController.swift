

import UIKit

class SViewController: UIViewController {

    var selectedPlace: Place?
    
    @IBOutlet weak var time2: UILabel!
    @IBOutlet weak var time1: UILabel!
    @IBOutlet weak var fromlbl: UILabel!
    @IBOutlet weak var tolbl: UILabel!
    @IBOutlet weak var numberlbl: UILabel!
    @IBOutlet weak var totaltimelbl: UILabel!
    @IBOutlet weak var boardingtimelbl: UILabel!
    
    @IBOutlet weak var hotelnamelbl: UILabel!
    //@IBOutlet weak var occupancyNolbl: UILabel!
    @IBOutlet weak var staylbl: UILabel!
    
    @IBOutlet weak var viewlbl: UIView!
    @IBOutlet weak var viewlbl2: UIView!
    
    @IBOutlet weak var buttonlbl: UIButton!
    @IBOutlet weak var buttonlbl2: UIButton!
    
    @IBOutlet weak var nextButton: UIBarButtonItem!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewlbl.layer.cornerRadius = 20
        viewlbl2.layer.cornerRadius = 20
        
        buttonlbl.layer.cornerRadius = 10
//        buttonlbl2.layer.cornerRadius = 8
        // Set up UI to display restaurant details
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
        
        
        if let button = nextButton {
            
            //button.tintColor = UIColor.
            button.target = self
            button.action = #selector(nextButtonTapped)
        }
        
        
        
        
        print("Selected place name: \(selectedPlace?.name)")
        if let savedData = UserDefaults.standard.data(forKey: "myDataKey"),
           let decodedPlace = try? JSONDecoder().decode(Place.self, from: savedData) {
            // Use decodedPlace as needed
            //print(decodedPlace)
            
            // Populate labels with decoded data
                    fromlbl.text = "\(decodedPlace.flight.from)"
                    tolbl.text = "\(decodedPlace.flight.to)"
                    time1.text = "\(decodedPlace.flight.startTime)"
                    time2.text = "\(decodedPlace.flight.landingTime)"
                    numberlbl.text = "\(decodedPlace.flight.flightNumber)"
                    totaltimelbl.text = "\(decodedPlace.flight.duration)"
                    boardingtimelbl.text = "\(decodedPlace.flight.boardingTime)"
                    
                    hotelnamelbl.text = "\(decodedPlace.hotel.hotelName)"
                    //occupancyNolbl.text = "\(decodedPlace.hotel.occupancyNumber)"
                    staylbl.text = "\(decodedPlace.hotel.numberOfNights) nights, \(decodedPlace.hotel.numberOfDays) days"
        }
    }
    

    @objc func nextButtonTapped() {
        // Instantiate your CustomerDetailsViewController from the storyboard
        if let customerDetailsViewController = storyboard?.instantiateViewController(withIdentifier: "customer") as? CustomerDetailsViewController {
            navigationController?.pushViewController(customerDetailsViewController, animated: true)
        }
    }
    
    }
