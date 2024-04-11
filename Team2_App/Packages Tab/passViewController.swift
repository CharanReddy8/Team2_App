
import UIKit

class CustomerDetailsViewController: UIViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var personCountStepper: UIStepper?
    @IBOutlet weak var lbl: UILabel!
    @IBOutlet weak var rate: UILabel!
    @IBOutlet weak var dates: UILabel!
    @IBOutlet weak var city: UILabel!
    @IBOutlet weak var imggg: UIImageView!
    
    struct Passenger: Codable {
        var id: UUID // Unique identifier for each passenger
        var name: String
        var age: String
        var gender: String
    }
    var passengerDetails: [Passenger] = []
    
    var formViews: [UIView] = []
    var paymentButton: UIButton?
    var z:Int!
    
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
            
            // Set up any initial configurations, delegates, or styling here.
            personCountStepper?.addTarget(self, action: #selector(personCountChanged(_:)), for: .valueChanged)
            
            // Create the initial form view for one person
            let formView = generateFormView(forPerson: 1)
            formViews.append(formView)
            scrollView.addSubview(formView)
            
            // Create the payment button
            createPaymentButton(afterPerson: 1)
        
        
            
            // Set the default person count to 1
            lbl.text = "1"
            if let savedData = UserDefaults.standard.data(forKey: "myDataKey"),
           let decodedPlace = try? JSONDecoder().decode(Place.self, from: savedData),
                let occupancyInt = Int(decodedPlace.occupancy) {
                   self.z = occupancyInt
                rate.text = "\(z ?? 2000)"
                dates.text = decodedPlace.date
                city.text = decodedPlace.name
                imggg.image = UIImage(named: decodedPlace.imageName)
                // Resize the label dynamically based on the content
                city.sizeToFit()
                

            }
            
            // Set the content size of the scroll view
            scrollView.contentSize = CGSize(width: scrollView.frame.width, height: 200)
        }
    
 


    @objc func personCountChanged(_ sender: UIStepper) {
        let personCount = Int(sender.value)

        if personCount <= 0 {
            showAlert(message: "Person count cannot be zero.")
            return
        }
        if personCount > 10 {
            showAlert(message: "Person count cannot be more than 10. For group bookings above 10 members Contact customer support")
            return
        }
        lbl.text = "\(personCount)"
        
        if let savedData = UserDefaults.standard.data(forKey: "myDataKey"),
           let decodedPlace = try? JSONDecoder().decode(Place.self, from: savedData),
           let occupancyInt = Int(decodedPlace.occupancy) {
            z = personCount * occupancyInt
            if let zValue = z {
                rate.text = "\(zValue)"
            } else {
                // Handle the case where z is nil (if applicable)
                rate.text = decodedPlace.occupancy
            }

        }


        // Remove existing form views and payment button
        for formView in formViews {
            formView.removeFromSuperview()
        }
        formViews.removeAll()
        paymentButton?.removeFromSuperview()

        for i in 1...personCount {
            let formView = generateFormView(forPerson: i)
            formViews.append(formView)
            scrollView.addSubview(formView)
        }

        // Position the payment button
        createPaymentButton(afterPerson: personCount)

        scrollView.contentSize = CGSize(width: scrollView.frame.width, height: CGFloat(personCount) * 200)
    }

    func generateFormView(forPerson personNumber: Int) -> UIView {
        let formView = UIView(frame: CGRect(x: 30, y: CGFloat(personNumber - 1) * 170, width: 300, height: 180))
        formView.backgroundColor = UIColor.clear
        
        let personLabel = UILabel(frame: CGRect(x: 10, y: 0, width: 100, height: 30))
        personLabel.text = "Passenger \(personNumber)"
        formView.addSubview(personLabel)

        let nameTextField = UITextField(frame: CGRect(x: 10, y: 30, width: 290, height: 30))
        nameTextField.backgroundColor = UIColor.white
        nameTextField.placeholder = "Name eg.,(Happy)"
        formView.addSubview(nameTextField)

        let ageTextField = UITextField(frame: CGRect(x: 10, y: 70, width: 290, height: 30))
        ageTextField.backgroundColor = UIColor.white
        ageTextField.placeholder = "Age eg.,(23)"
        formView.addSubview(ageTextField)

        let genderTextField = UITextField(frame: CGRect(x: 10, y: 110, width: 290, height: 30))
        genderTextField.backgroundColor = UIColor.white
        genderTextField.placeholder = "Gender eg.,(Male)"
        formView.addSubview(genderTextField)
        

        //----
        let passenger = Passenger(id: UUID(), name: nameTextField.text ?? "", age: ageTextField.text ?? "", gender: genderTextField.text ?? "")
        passengerDetails.append(passenger)
        let key = "passengerDetails"
        UserDefaults.standard.set(try? PropertyListEncoder().encode(passenger), forKey: key)
        

        return formView
    }

    func createPaymentButton(afterPerson personCount: Int) {
        let buttonWidth: CGFloat = 200
        let buttonHeight: CGFloat = 50
        let xPosition: CGFloat = 80
        let yPosition: CGFloat = CGFloat(personCount) * 170 + 10

        paymentButton = UIButton(frame: CGRect(x: xPosition, y: yPosition, width: buttonWidth, height: buttonHeight))
        paymentButton?.setTitle("Pay", for: .normal)
        paymentButton?.backgroundColor = UIColor.systemYellow
        paymentButton?.setTitleColor(UIColor.white, for: .normal)
        paymentButton?.addTarget(self, action: #selector(paymentButtonTapped), for: .touchUpInside)

        scrollView.addSubview(paymentButton!)
    }

    @objc func paymentButtonTapped() {
        
        // Validate passenger details before proceeding
        if !validatePassengerDetails() {
            return
        }
        
        // Handle payment button tap action here
        UserDefaults.standard.set(z, forKey: "paymentamount")
        UserDefaults.standard.synchronize()
        // Collect passenger details when Pay button is tapped
        passengerDetails.removeAll() // Clear previous details to avoid duplicates
        
        for i in 1...formViews.count {
            let formView = formViews[i - 1]
            let nameTextField = formView.subviews[1] as? UITextField
            let ageTextField = formView.subviews[2] as? UITextField
            let genderTextField = formView.subviews[3] as? UITextField
            
            let passenger = Passenger(
                id: UUID(),
                name: nameTextField?.text ?? "",
                age: ageTextField?.text ?? "",
                gender: genderTextField?.text ?? ""
            )
            
            passengerDetails.append(passenger)
        }

        // Store passenger details in UserDefaults
        let key = "passengerDetails"
        if !passengerDetails.isEmpty {
            UserDefaults.standard.set(try? PropertyListEncoder().encode(passengerDetails), forKey: key)
            UserDefaults.standard.synchronize()
        }
        
        
        
        let CustomerDetailsViewController = storyboard?.instantiateViewController(withIdentifier: "payment") as? PaymentDetails

        if let CustomerDetailsViewController = CustomerDetailsViewController {
            navigationController?.pushViewController(CustomerDetailsViewController, animated: true)
        }
        
    }
    
        func validatePassengerDetails() -> Bool {
            for formView in formViews {
                let nameTextField = formView.subviews[1] as? UITextField
                let ageTextField = formView.subviews[2] as? UITextField
                let genderTextField = formView.subviews[3] as? UITextField

                // Basic validation rules
                if (nameTextField?.text ?? "").isEmpty {
                    showAlert(message: "Please enter a name for all passengers.")
                    return false
                }

                if let age = ageTextField?.text, !age.isEmpty, let ageInt = Int(age), (1...100).contains(ageInt) {
                            // Age is a valid number between 1 and 100
                        } else {
                            showAlert(message: "Please enter a valid age between 1 and 100.")
                            return false
                        }

                if let gender = genderTextField?.text, !gender.isEmpty {
                            let validGenders = ["Male", "Female", "Other","male","female", "other"]
                            if validGenders.contains(gender) {
                                // Gender is valid
                            } else {
                                showAlert(message: "Please enter a valid gender (Male/Female/Other) for all passengers.")
                                return false
                            }
                        } else {
                            showAlert(message: "Please enter a gender (Male/Female/Other) for all passengers.")
                            return false
                        }
            }

            return true
        }

    func showAlert(message: String) {
        let alertController = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
}
