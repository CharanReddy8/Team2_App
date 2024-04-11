

import UIKit
import Firebase

class MyBookingsViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var documents: [QueryDocumentSnapshot] = []
    
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
        
        tableView.backgroundColor = .clear
        
        loadUserBookings()
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func loadUserBookings() {
        if let user = Auth.auth().currentUser {
            let uid = user.uid
            print("User UID: \(uid)")
            
            let db = Firestore.firestore()
            let userRef = db.collection("users").document(uid).collection("bookings")
            
            userRef.getDocuments { [weak self] (querySnapshot, error) in
                guard let self = self else { return }
                
                if let error = error {
                    print("Error getting user bookings: \(error.localizedDescription)")
                    return
                }
                
                guard let documents = querySnapshot?.documents else {
                    print("No bookings found")
                    return
                }
                
                self.documents = documents
                self.tableView.reloadData()
            }
        }
    }
}

extension MyBookingsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 310
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30  // Set the desired spacing value between cells
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return documents.isEmpty ? 1 : documents.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if documents.isEmpty {
            let cell = tableView.dequeueReusableCell(withIdentifier: "NoBookingsCells", for: indexPath)as! NoBookingCell
            cell.NotextLabel?.text = "No bookings available"
            cell.accessoryType = .none
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "BookingCell", for: indexPath) as! BookingCells
    
            
            let document = documents[indexPath.row]
            
            let bookingID = document.documentID
            let date = document["placeID"] as? String ?? "N/A"
            let place = document["placeCity"] as? String ?? "N/A"
            let image = document["placeImage"] as? String ?? "N/A"
            
            cell.namelbl.text = "Booking ID: \(bookingID)"
            cell.durationlbl.text = "\(date)"
            cell.occupancylbl.text = "\(place)"
            cell.imgg.image = UIImage(named: image) // Assuming image is the name of the image in your bundle

            cell.cancelAction = { [weak self] in
                self?.deleteBooking(at: indexPath.row)
            }
    // Set corner radius for the cell's contentView
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

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
             let selectedBooking = documents[indexPath.row] // Assuming documents is an array of bookings
             
             // Get the booking ID for the selected booking
             let bookingID = selectedBooking.documentID
            let date = selectedBooking["placeID"] as? String ?? "N/A"
            let place = selectedBooking["placeCity"] as? String ?? "N/A"
            let image = selectedBooking["placeImage"] as? String ?? "N/A"
             print(date)
            
        // Store the booking details in UserDefaults
           let defaults = UserDefaults.standard
           defaults.set(bookingID, forKey: "bookingID")
            defaults.set(date, forKey: "bookingDate")
            defaults.set(place, forKey: "bookingPlace")
            defaults.set(image, forKey: "bookingImage")
            
        
             let storyboard = UIStoryboard(name: "Main", bundle: nil) // Replace "Main" with your storyboard name
             if let detailsViewController = storyboard.instantiateViewController(withIdentifier: "BookingDetailsViewController") as? BookingDetailsViewController {
                 detailsViewController.bookingID = bookingID // Pass the booking ID to the new view controller
                 navigationController?.pushViewController(detailsViewController, animated: true)
             }
         }
    func deleteBooking(at index: Int) {
        let document = documents[index]
        let bookingID = document.documentID
        
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        let db = Firestore.firestore()
        let bookingRef = db.collection("users").document(uid).collection("bookings").document(bookingID)
        
        let alert = UIAlertController(title: "Confirm Cancellation", message: "Are you sure you want to cancel this booking?", preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "No", style: .cancel)
        
        let deleteAction = UIAlertAction(title: "Yes", style: .destructive) { [weak self] _ in
            bookingRef.delete { error in
                if let error = error {
                    print("Error deleting booking: \(error.localizedDescription)")
                } else {
                    self?.documents.remove(at: index)
                    self?.tableView.reloadData()
                    print("Booking deleted successfully")
                    
                    // Display an alert when the booking is canceled
                    let successAlert = UIAlertController(title: "Booking Cancelled", message: "Your booking has been canceled.", preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "OK", style: .default)
                    successAlert.addAction(okAction)
                    self?.present(successAlert, animated: true)
                }
            }
        }
        
        alert.addAction(cancelAction)
        alert.addAction(deleteAction)
        
        present(alert, animated: true)
    }


}
