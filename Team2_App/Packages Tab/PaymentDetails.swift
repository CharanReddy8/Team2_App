//
//  PaymentDetails.swift
//  Exercise5_Vundela_Venkata
//
//  Created by Charan Reddy on 10/30/23.
//

import UIKit

class PaymentDetails: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    // Add these methods

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == monthPicker {
            return months.count
        } else {
            return years.count
        }
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == monthPicker {
            return "\(months[row])"
        } else {
            return "\(years[row])"
        }
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
            if pickerView == monthPicker {
                month.text = "\(months[row])"
            } else if pickerView == yearPicker {
                monthandyear.text = "\(years[row])"
            }
    }
    
    @IBOutlet weak var card: UITextField!
    @IBOutlet weak var month: UITextField!
    @IBOutlet weak var monthandyear: UITextField!
    @IBOutlet weak var cvv: UITextField!
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var state: UITextField!
    @IBOutlet weak var city: UITextField!
    @IBOutlet weak var address: UITextField!
    @IBOutlet weak var zip: UITextField!
    @IBOutlet weak var amount: UILabel!
    @IBOutlet weak var rememberSwitch: UISwitch! // Add this outlet for the "Remember Card" switch
    
    var monthPicker: UIPickerView!
    var yearPicker: UIPickerView!

    let months = Array(1...12)
    let years = Array(2023...2043)
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        let nextButton = UIButton(type: .custom)
        nextButton.setTitle("Review Details", for: .normal)
        nextButton.setTitleColor(UIColor.black, for: .normal) // Set the text color to blue
        nextButton.addTarget(self, action: #selector(ReviewButtonTapped), for: .touchUpInside)
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
        
// Create and configure month picker
       monthPicker = UIPickerView()
       monthPicker.delegate = self
       monthPicker.dataSource = self
       month.inputView = monthPicker // Set input view for month text field

       // Create and configure year picker
       yearPicker = UIPickerView()
       yearPicker.delegate = self
       yearPicker.dataSource = self
       monthandyear.inputView = yearPicker

        // Load switch state from UserDefaults
        rememberSwitch.isOn = UserDefaults.standard.bool(forKey: "rememberCard")

        // Auto-fill card details if "Remember Card" is enabled
        if rememberSwitch.isOn {
            if let savedCardNumber = UserDefaults.standard.string(forKey: "cardDetails") {
                card.text = savedCardNumber
            }
            
            if let savedMonthAndYear = UserDefaults.standard.string(forKey: "monthAndYear") {
                            monthandyear.text = savedMonthAndYear
            }
            
            if let savedAddress = UserDefaults.standard.string(forKey: "addressDetails") {
                // Assuming the full address is stored as a single string
                // You may need to parse the string based on your data structure
                let addressComponents = savedAddress.components(separatedBy: ", ")
                
                if addressComponents.count == 4 {
                    name.text = addressComponents[0]
                    address.text = addressComponents[1]
                    city.text = addressComponents[2]
                    state.text = addressComponents[3].components(separatedBy: " ")[0]
                    zip.text = addressComponents[3].components(separatedBy: " ")[1]
                }
            }
        }

        if let retrievedZ = UserDefaults.standard.object(forKey: "paymentamount") as? Int {
            amount.text = String(retrievedZ) // Convert 'retrievedZ' to a string
        }
    }
    
    @objc func ReviewButtonTapped() {
        guard let cardNumber = card.text, cardNumber.count == 16, let _ = Int(cardNumber) else {
            showAlert(message: "Please enter a valid 16-digit card number.")
            return
        }
        
//        // Validate month and year
//        guard let expirationDate = monthandyear.text, expirationDate.count == 4,
//              let month = Int(String(expirationDate.prefix(2))),
//              let year = Int(String(expirationDate.suffix(2))),
//              month >= 1, month <= 12, year >= 21, year <= 99 else {
//            showAlert(message: "Please enter a valid expiration date (MMYY).")
//            return
//        }
        
        // Validate CVV
        guard let cvvValue = cvv.text, cvvValue.count == 3, let _ = Int(cvvValue) else {
            showAlert(message: "Please enter a valid 3-digit CVV.")
            return
        }
        
        // Validate billing address
        guard let name = name.text, !name.isEmpty,
              let street = address.text, !street.isEmpty,
              let city = city.text, !city.isEmpty,
              let state = state.text, !state.isEmpty,
              let zip = zip.text, !zip.isEmpty else {
            showAlert(message: "Please enter all required billing address details.")
            return
        }
        
        let fullAddress = "\(name), \(street), \(city), \(state) \(zip)"
        
        // Save data to UserDefaults
        UserDefaults.standard.set(cardNumber, forKey: "cardDetails")
        UserDefaults.standard.set(fullAddress, forKey: "addressDetails")
        UserDefaults.standard.set(rememberSwitch.isOn, forKey: "rememberCard")
        UserDefaults.standard.synchronize()
        
        let customerDetailsViewController = storyboard?.instantiateViewController(withIdentifier: "details") as? DetailsReviewViewController
        
        if let customerDetailsViewController = customerDetailsViewController {
            navigationController?.pushViewController(customerDetailsViewController, animated: true)
        }
    }

//    @IBAction func buttonClicked(_ sender: UIButton) {
//        // Validate card details
//        guard let cardNumber = card.text, cardNumber.count == 16, let _ = Int(cardNumber) else {
//            showAlert(message: "Please enter a valid 16-digit card number.")
//            return
//        }
//
//        // Validate month and year
//        guard let expirationDate = monthandyear.text, expirationDate.count == 4,
//              let month = Int(String(expirationDate.prefix(2))),
//              let year = Int(String(expirationDate.suffix(2))),
//              month >= 1, month <= 12, year >= 21, year <= 99 else {
//            showAlert(message: "Please enter a valid expiration date (MMYY).")
//            return
//        }
//
//        // Validate CVV
//        guard let cvvValue = cvv.text, cvvValue.count == 3, let _ = Int(cvvValue) else {
//            showAlert(message: "Please enter a valid 3-digit CVV.")
//            return
//        }
//
//        // Validate billing address
//        guard let name = name.text, !name.isEmpty,
//              let street = address.text, !street.isEmpty,
//              let city = city.text, !city.isEmpty,
//              let state = state.text, !state.isEmpty,
//              let zip = zip.text, !zip.isEmpty else {
//            showAlert(message: "Please enter all required billing address details.")
//            return
//        }
//
//        let fullAddress = "\(name), \(street), \(city), \(state) \(zip)"
//
//        // Save data to UserDefaults
//        UserDefaults.standard.set(cardNumber, forKey: "cardDetails")
//        UserDefaults.standard.set(fullAddress, forKey: "addressDetails")
//        UserDefaults.standard.set(rememberSwitch.isOn, forKey: "rememberCard")
//        UserDefaults.standard.synchronize()
//
//        let customerDetailsViewController = storyboard?.instantiateViewController(withIdentifier: "details") as? DetailsReviewViewController
//
//        if let customerDetailsViewController = customerDetailsViewController {
//            navigationController?.pushViewController(customerDetailsViewController, animated: true)
//        }
//    }

    func showAlert(message: String) {
        let alertController = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
    
}
