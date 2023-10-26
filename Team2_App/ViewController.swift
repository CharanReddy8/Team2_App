//
//  ViewController.swift
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
    

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func LoginButtonTapped(_ sender: UIButton) {
        if let authViewController = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") {
            authViewController.modalPresentationStyle = .fullScreen
            self.present(authViewController, animated: true, completion: nil)
        }
    }
    
    @IBAction func signUpButtonTapped(_ sender: UIButton) {
        guard let email = emailTextField.text, let password = passwordTextField.text else {
            return
        }

        Auth.auth().createUser(withEmail: email, password: password) { (authResult, error) in
            if let error = error {
                // Handle the error (e.g., display an alert)
                print("Error signing up: \(error.localizedDescription)")
            } else {
                // User signed up successfully
                guard let user = authResult?.user else {
                    return
                }

                // Additional user details
                let name = self.nameText.text // Replace with the actual name
                let phoneNumber = self.phnText.text // Replace with the actual phone number

                // Store additional user details in Firestore
                let db = Firestore.firestore()
                let userRef = db.collection("users").document(user.uid)
                let uiid = user.uid

                let userData: [String: Any] = [
                    "name": name ,
                    "email": email,
                    "phn": phoneNumber,
                    "uiid": user.uid
                ]

                userRef.setData(userData) { error in
                    if let error = error {
                        print("Error saving user data to Firestore: \(error.localizedDescription)")
                    } else {
                        print("User data saved to Firestore successfully")
                        // You can perform any additional actions upon successful signup
                    }
                }
            }
        }
    }


}

