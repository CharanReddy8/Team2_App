//
//  BookingDetailsViewController.swift
//  Team2_App
//
//  Created by Charan Reddy on 11/26/23.
//

import UIKit
import Firebase

class BookingDetailsViewController: UIViewController {
    
    @IBOutlet weak var bookingidlabel: UILabel!
    @IBOutlet weak var imglabel: UIImageView!
    @IBOutlet weak var dayslabel: UILabel!
    @IBOutlet weak var placelabel: UILabel!
    
    @IBOutlet weak var cardDetailsLabel: UILabel!
    @IBOutlet weak var amountlabel: UILabel!
    @IBOutlet weak var passengerDetailsLabel: UILabel!
    
    var db: Firestore!
    var userID: String = ""
    var bookingID: String = ""

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
        
        // Retrieve booking details from UserDefaults
                let defaults = UserDefaults.standard
                let bookingID = defaults.string(forKey: "bookingID") ?? "N/A"
                let date = defaults.string(forKey: "bookingDate") ?? "N/A"
                let place = defaults.string(forKey: "bookingPlace") ?? "N/A"
                let image = defaults.string(forKey: "bookingImage") ?? "N/A"
                
                // Now you can use these values as needed in your BookingDetailsViewController
                bookingidlabel.text = "Booking ID: \(bookingID)"
                dayslabel.text = "Date: \(date)"
                placelabel.text = "Place: \(place)"
                imglabel.image = UIImage(named: image) // Assuming image is the name of the image in your bundle
                
        // Get the current user ID
        if let user = Auth.auth().currentUser {
            userID = user.uid
        } else {
            // Handle scenario when the user is not logged in
            // You can redirect the user to log in or take appropriate action
            print("No user logged in.")
            return
        }
        
        // Initialize Firestore
        db = Firestore.firestore()
        
        fetchDetails()
    }

    func fetchDetails() {
        let bookingRef = db.collection("users").document(userID).collection("bookings").document(bookingID)
        
        // Fetch card details from Firestore
        bookingRef.collection("card").getDocuments { [weak self] (cardSnapshot, cardError) in
            guard let self = self else { return }
            
            if let cardError = cardError {
                print("Error fetching card details: \(cardError.localizedDescription)")
                return
            }
            
            if let cardDocument = cardSnapshot?.documents.first {
                let cardData = cardDocument.data()
                // Assuming card details are stored as fields in Firestore
                let cardDetails4 = cardData["card"] as! String
                let last4Digits = String(cardDetails4.suffix(4))
                
                let cardDetails = "Paid through: XXXX\(last4Digits)"
                let Amount = "Amount Paid: \(cardData["amount"] ?? "")"
                self.cardDetailsLabel.text = cardDetails
                self.amountlabel.text = Amount
            } else {
                print("No card details found.")
            }
        }
        
        // Fetch passenger details from Firestore
        bookingRef.collection("passengers").getDocuments { [weak self] (passengerSnapshot, passengerError) in
            guard let self = self else { return }
            
            if let passengerError = passengerError {
                print("Error fetching passenger details: \(passengerError.localizedDescription)")
                return
            }
            
            var passengerDetailsText = ""
            for passengerDocument in passengerSnapshot?.documents ?? [] {
                let passengerData = passengerDocument.data()
                // Assuming passenger details are stored as fields in Firestore
                let passengerInfo = "Name: \(passengerData["name"] ?? "") Age: \(passengerData["age"] ?? "") gender: \(passengerData["gender"] ?? "")\n"
                passengerDetailsText.append(passengerInfo)
            }
            
            if !passengerDetailsText.isEmpty {
                self.passengerDetailsLabel.text = passengerDetailsText
                passengerDetailsLabel.sizeToFit()
            } else {
                print("No passenger details found.")
            }
        }
    }
}
