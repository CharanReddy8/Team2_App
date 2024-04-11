
//
//  AuthViewController.swift
//  Team2_App
//
//  Created by Charan Reddy on 10/25/23.
//
import UIKit
import Firebase

class AuthViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var nameText: UITextField!
    @IBOutlet weak var phnText: UITextField!
    @IBOutlet weak var AddLabel: UITextField?
    @IBOutlet weak var confirmPass: UITextField?

    override func viewDidLoad() {
        super.viewDidLoad()
        passwordTextField?.isSecureTextEntry = true
        confirmPass?.isSecureTextEntry = true

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
    }

    @IBAction func LoginButtonTapped(_ sender: UIButton) {
        if let authViewController = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") {
            authViewController.modalPresentationStyle = .fullScreen
            self.present(authViewController, animated: true, completion: nil)
        }
    }

    @IBAction func signUpButtonTapped(_ sender: UIButton) {
        guard let email = emailTextField.text,
              let password = passwordTextField.text,
              let name = nameText.text,
              let phoneNumber = phnText.text,
              let confirmPassword = confirmPass?.text else {
            return
        }
        
        // Validate name
                if !isValidName(name) {
                    showAlert(title: "Invalid Name", message: "Please enter a valid full name.")
                    return
                }

                // Validate email
                if !isValidEmail(email) {
                    showAlert(title: "Invalid Email", message: "Please enter a valid email address.")
                    return
                }

                // Validate phone number
                if !isValidPhoneNumber(phoneNumber) {
                    showAlert(title: "Invalid Phone Number", message: "Please enter a valid phone number.")
                    return
                }

                // Validate password
                if !isValidPassword(password) {
                    showAlert(title: "Invalid Password", message: "Please enter a valid password. It should contain at least one uppercase letter, one lowercase letter, one digit, and one special character.")
                    return
                }

                // Check if passwords match
                if password != confirmPassword {
                    showAlert(title: "Password Mismatch", message: "The password and confirm password do not match.")
                    return
                }

        // Validate name, email, phone number, and password as you're already doing.

        // Check if the email is already registered
        let db = Firestore.firestore()
        let usersRef = db.collection("users")
        usersRef.whereField("email", isEqualTo: email).getDocuments { (querySnapshot, error) in
            if let error = error {
                print("Error querying the database: \(error.localizedDescription)")
                return
            }
            
            if let documents = querySnapshot?.documents, !documents.isEmpty {
                // The email is already registered
                self.showAlert(title: "Email Already Registered", message: "This email address is already associated with an account.")
            } else {
                // The email is not registered, continue with user creation
                Auth.auth().createUser(withEmail: email, password: password) { (authResult, error) in
                    if let error = error {
                        print("Error signing up: \(error.localizedDescription)")
                    } else {
                        // User signed up successfully
                        guard let user = authResult?.user else {
                            return
                        }

                        // Additional user details
                        let userRef = db.collection("users").document(user.uid)
                        let userData: [String: Any] = [
                            "name": name,
                            "email": email,
                            "phn": phoneNumber,
                            "add": self.AddLabel?.text ?? "", // Use default value if AddLabel is nil
                            "uiid": user.uid
                        ]

                        userRef.setData(userData) { error in
                            if let error = error {
                                print("Error saving user data to Firestore: \(error.localizedDescription)")
                            } else {
                                print("User data saved to Firestore successfully")
                                // You can perform any additional actions upon successful signup
                                let successAlert = UIAlertController(title: "SignUp Successful", message: "You have successfully Signed up!", preferredStyle: .alert)
                                let okAction = UIAlertAction(title: "OK", style: .default, handler: { (action) in
                                    // You can perform any additional actions upon successful login
                                    self.switchToTabBarController()
                                })
                                successAlert.addAction(okAction)
                                self.present(successAlert, animated: true, completion: nil)
                            }
                        }
                    }
                }
            }
        }
    }

    func isValidName(_ name: String) -> Bool {
        let nameRegex = "^[a-zA-Z]+( [a-zA-Z]+)?$"
        return NSPredicate(format: "SELF MATCHES %@", nameRegex).evaluate(with: name)
    }

    func isValidEmail(_ email: String) -> Bool {
        return email.contains("@") && email.contains(".")
    }

    func isValidPhoneNumber(_ phoneNumber: String) -> Bool {
        let phoneNumberRegex = "^[0-9]{10}$"
        return NSPredicate(format: "SELF MATCHES %@", phoneNumberRegex).evaluate(with: phoneNumber)
    }

    func switchToTabBarController() {
        if let tabBarController = storyboard?.instantiateViewController(withIdentifier: "YourTabBarControllerIdentifier") as? UITabBarController {
            UIApplication.shared.keyWindow?.rootViewController = tabBarController
        }
    }

    func isValidPassword(_ password: String) -> Bool {
        let passwordRegex = "^(?=.*[A-Z])(?=.*[a-z])(?=.*\\d)(?=.*[@$!%*?&])[A-Za-z\\d@$!%*?&]{8,}$"
        return NSPredicate(format: "SELF MATCHES %@", passwordRegex).evaluate(with: password)
    }

    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}
