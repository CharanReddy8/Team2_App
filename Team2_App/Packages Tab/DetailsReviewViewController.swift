

import UIKit
import Firebase

class DetailsReviewViewController: UIViewController {
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var dates: UILabel!
    @IBOutlet weak var city: UILabel!
    @IBOutlet weak var ima: UIImageView!
    @IBOutlet weak var amount: UILabel!
    var z: String?
    struct Passenger: Codable {
        var id: UUID
        var name: String
        var age: String
        var gender: String
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Create a UIButton
        let nextButton = UIButton(type: .custom)
        nextButton.setTitle("Pay", for: .normal)
        nextButton.setTitleColor(UIColor.black, for: .normal) // Set the text color to blue
        nextButton.addTarget(self, action: #selector(PayButtonTapped), for: .touchUpInside)
        nextButton.sizeToFit()

        // Wrap the button in a UIBarButtonItem
        let nextBarButtonItem = UIBarButtonItem(customView: nextButton)

        // Assigning to the right bar button item
        navigationItem.rightBarButtonItem = nextBarButtonItem

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
        
        if let savedData = UserDefaults.standard.data(forKey: "myDataKey"),
       let decodedPlace = try? JSONDecoder().decode(Place.self, from: savedData),
           let _ = Int(decodedPlace.occupancy) {
            dates.text = decodedPlace.date
            city.text = decodedPlace.name
            ima.image = UIImage(named: decodedPlace.imageName)
            // Resize the label dynamically based on the content
            city.sizeToFit()
    
        }
        if let z = UserDefaults.standard.string(forKey: "paymentamount") {
            // Assign the value from UserDefaults to the class-level z variable
            self.z = z
        }
        if let retrievedZ = UserDefaults.standard.object(forKey: "paymentamount") as? Int {
            amount.text = "$ \(String(retrievedZ))" // Convert 'retrievedZ' to a string
        }
        

        // Retrieve passenger details from UserDefaults
        if let passengerData = UserDefaults.standard.data(forKey: "passengerDetails"),
           let passengerDetails = try? PropertyListDecoder().decode([Passenger].self, from: passengerData) {

            // Use passengerDetails to display the details
            var yOffset: CGFloat = 20
            
            // Add Passenger Details Heading
            let passengerDetailsHeading = UILabel()
            passengerDetailsHeading.text = "Passenger Details"
            passengerDetailsHeading.font = UIFont.boldSystemFont(ofSize: 20)
            passengerDetailsHeading.frame = CGRect(x: 20, y: yOffset, width: 300, height: 30)
            scrollView.addSubview(passengerDetailsHeading)

            // Adjust yOffset for the next elements
            yOffset += 30

//            for loadedPassenger in passengerDetails {
//                // Create UI elements to display passenger details
//                
//                let nameLabel = UILabel()
//                nameLabel.text = "Name: \(loadedPassenger.name)"
//                nameLabel.font = UIFont.boldSystemFont(ofSize: 17)
//                nameLabel.frame = CGRect(x: 20, y: yOffset, width: 300, height: 30)
//                scrollView.addSubview(nameLabel)
//
//                // Add age and gender labels similarly
//                let ageLabel = UILabel()
//                ageLabel.text = "Age: \(loadedPassenger.age)"
//                ageLabel.font = UIFont.boldSystemFont(ofSize: 17)
//                ageLabel.frame = CGRect(x: 20, y: yOffset + 30, width: 300, height: 30)
//                scrollView.addSubview(ageLabel)
//
//                let genderLabel = UILabel()
//                genderLabel.text = "Gender: \(loadedPassenger.gender)"
//                genderLabel.font = UIFont.boldSystemFont(ofSize: 17)
//                genderLabel.frame = CGRect(x: 20, y: yOffset + 60, width: 300, height: 30)
//                scrollView.addSubview(genderLabel)
//
//                // Adjust the yOffset for the next passenger details
//                yOffset += 90
//            }
            for (index, loadedPassenger) in passengerDetails.enumerated() {
                // Create UI elements to display passenger details
                
                let passengerDetailsLabel = UILabel()
                passengerDetailsLabel.text = "\(index + 1). Name: \(loadedPassenger.name), Age: \(loadedPassenger.age), Gender: \(loadedPassenger.gender)"
                passengerDetailsLabel.numberOfLines = 0
                passengerDetailsLabel.sizeToFit()
                passengerDetailsLabel.font = UIFont.boldSystemFont(ofSize: 17)
                passengerDetailsLabel.frame = CGRect(x: 20, y: yOffset, width: 340, height: 50)
                scrollView.addSubview(passengerDetailsLabel)

                // Adjust the yOffset for the next passenger details
                yOffset += 20
            }
            
            yOffset += 40
            
            // Add Paying By Heading
            let payingByHeading = UILabel()
            payingByHeading.text = "Payment Details"
            payingByHeading.font = UIFont.boldSystemFont(ofSize: 20)
            payingByHeading.frame = CGRect(x: 20, y: yOffset, width: 300, height: 30)
            scrollView.addSubview(payingByHeading)

            // Adjust yOffset for the next elements
            yOffset += 30

            if let cardDetails = UserDefaults.standard.string(forKey: "cardDetails"), cardDetails.count >= 4 {
                // Extract the last 4 digits of the card
                let last4Digits = String(cardDetails.suffix(4))

                // Create a label to display the last 4 digits of the card
                let cardLabel = UILabel()
                cardLabel.text = "Paying By: XX\(last4Digits)"
                cardLabel.font = UIFont.boldSystemFont(ofSize: 17)
                cardLabel.frame = CGRect(x: 20, y: yOffset, width: 300, height: 30)
                scrollView.addSubview(cardLabel)

                // Adjust the yOffset for additional elements or the next section
                //yOffset += 30
            }
            
            yOffset += 40
            
            // Add Billing Address Heading
            let billingAddressHeading = UILabel()
            billingAddressHeading.text = "Billing Address"
            billingAddressHeading.font = UIFont.boldSystemFont(ofSize: 20)
            billingAddressHeading.frame = CGRect(x: 20, y: yOffset, width: 300, height: 30)
            scrollView.addSubview(billingAddressHeading)

            // Adjust yOffset for the next elements
            yOffset += 30

            
            if let cardDetails = UserDefaults.standard.string(forKey: "addressDetails") {
                // Create a label to display card details
                let cardLabel = UILabel()
                cardLabel.text = "\(cardDetails)"
                cardLabel.font = UIFont.boldSystemFont(ofSize: 17)
                cardLabel.frame = CGRect(x: 20, y: yOffset, width: 300, height: 30)
                cardLabel.numberOfLines = 0
                cardLabel.sizeToFit()
                scrollView.addSubview(cardLabel)

                // Adjust the yOffset for additional elements or the next section
                //yOffset += 40
            }
        }
    }
    func generateUniqueBookingID() -> String {
        // Get the current timestamp as a string (e.g., "1638420746" for the current timestamp)
        let timestamp = String(Int(Date().timeIntervalSince1970))

        // Generate a random 3-digit number (between 100 and 999)
        let randomPart = String(Int.random(in: 100...999))

        // Combine the timestamp and random part to create the 6-digit ID
        let bookingID = timestamp + randomPart

        return bookingID
    }
    
    
    @objc func PayButtonTapped(){
        //            let db = Firestore.firestore()
        //            let userRef = db.collection("users").document(uid)
        if let user = Auth.auth().currentUser {
            
            let db = Firestore.firestore()
            let userRef = db.collection("users").document(user.uid)  // Use the authenticated user's UID
            
            // Generate a unique booking ID (you can use a timestamp or any unique identifier)
            let bookingID = generateUniqueBookingID()
            
            if let savedData = UserDefaults.standard.data(forKey: "myDataKey"),
               let decodedPlace = try? JSONDecoder().decode(Place.self, from: savedData),
               let _ = Int(decodedPlace.occupancy) {
                let bookingsRef = userRef.collection("bookings").document(bookingID)
                        
                        // Store place details directly under the bookings document in Firestore
                        bookingsRef.setData([
                            "placeID": decodedPlace.date,
                            "placeCity": decodedPlace.name,
                            "placeImage": decodedPlace.imageName,
                            // Add other place details as needed
                        ], merge: true) { error in
                            if let error = error {
                                print("Error storing place details: \(error.localizedDescription)")
                            } else {
                                print("Place details saved successfully under bookingID: \(bookingID)")
                            }
                        }


            }
            
            if let cardDetails = UserDefaults.standard.string(forKey: "cardDetails") {
                // Store card details
                let cardData: [String: Any] = ["card": cardDetails,"amount": z]
                let cardRef = userRef.collection("bookings").document(bookingID).collection("card").document()
                cardRef.setData(cardData) { error in
                    if let error = error {
                        print("Error storing card details: \(error.localizedDescription)")
                    }
                }
            }
            
            // Store passenger details
            if let passengerData = UserDefaults.standard.data(forKey: "passengerDetails"),
               let passengerDetails = try? PropertyListDecoder().decode([Passenger].self, from: passengerData) {
                
                for (index, passenger) in passengerDetails.enumerated() {
                    let passengerData: [String: Any] = [
                        "name": passenger.name,
                        "age": passenger.age,
                        "gender": passenger.gender
                    ]
                    let passengerRef = userRef.collection("bookings").document(bookingID).collection("passengers").document()
                    passengerRef.setData(passengerData) { error in
                        if let error = error {
                            print("Error storing passenger details: \(error.localizedDescription)")
                        }
                    }
                }
            }
        }
        // In your current view controller, where you navigate to PaymentSucessViewController:
        let paymentSuccessVC = storyboard?.instantiateViewController(withIdentifier: "paymentsucess") as? PaymentSucessViewController
        paymentSuccessVC?.hidesBottomBarWhenPushed = true // Hide the tab bar
        navigationController?.pushViewController(paymentSuccessVC!, animated: true)
//        }
    }
    
    
    
//    
//    @IBAction func buttonClicked(_ sender: UIButton) {
//        //            let db = Firestore.firestore()
//        //            let userRef = db.collection("users").document(uid)
//        if let user = Auth.auth().currentUser {
//            
//            let db = Firestore.firestore()
//            let userRef = db.collection("users").document(user.uid)  // Use the authenticated user's UID
//            
//            // Generate a unique booking ID (you can use a timestamp or any unique identifier)
//            let bookingID = generateUniqueBookingID()
//            
//            if let savedData = UserDefaults.standard.data(forKey: "myDataKey"),
//               let decodedPlace = try? JSONDecoder().decode(Place.self, from: savedData),
//               let _ = Int(decodedPlace.occupancy) {
//                let bookingsRef = userRef.collection("bookings").document(bookingID)
//                        
//                        // Store place details directly under the bookings document in Firestore
//                        bookingsRef.setData([
//                            "placeID": decodedPlace.date,
//                            "placeCity": decodedPlace.name,
//                            "placeImage": decodedPlace.imageName,
//                            // Add other place details as needed
//                        ], merge: true) { error in
//                            if let error = error {
//                                print("Error storing place details: \(error.localizedDescription)")
//                            } else {
//                                print("Place details saved successfully under bookingID: \(bookingID)")
//                            }
//                        }
//
//
//            }
//            
//            if let cardDetails = UserDefaults.standard.string(forKey: "cardDetails") {
//                // Store card details
//                let cardData: [String: Any] = ["card": cardDetails,"amount": z]
//                let cardRef = userRef.collection("bookings").document(bookingID).collection("card").document()
//                cardRef.setData(cardData) { error in
//                    if let error = error {
//                        print("Error storing card details: \(error.localizedDescription)")
//                    }
//                }
//            }
//            
//            // Store passenger details
//            if let passengerData = UserDefaults.standard.data(forKey: "passengerDetails"),
//               let passengerDetails = try? PropertyListDecoder().decode([Passenger].self, from: passengerData) {
//                
//                for (index, passenger) in passengerDetails.enumerated() {
//                    let passengerData: [String: Any] = [
//                        "name": passenger.name,
//                        "age": passenger.age,
//                        "gender": passenger.gender
//                    ]
//                    let passengerRef = userRef.collection("bookings").document(bookingID).collection("passengers").document()
//                    passengerRef.setData(passengerData) { error in
//                        if let error = error {
//                            print("Error storing passenger details: \(error.localizedDescription)")
//                        }
//                    }
//                }
//            }
//        }
//        // In your current view controller, where you navigate to PaymentSucessViewController:
//        let paymentSuccessVC = storyboard?.instantiateViewController(withIdentifier: "paymentsucess") as? PaymentSucessViewController
//        paymentSuccessVC?.hidesBottomBarWhenPushed = true // Hide the tab bar
//        navigationController?.pushViewController(paymentSuccessVC!, animated: true)
////        }
//    }
}

