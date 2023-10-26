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

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func signUpButtonTapped(_ sender: UIButton) {
        guard let email = emailTextField.text, let password = passwordTextField.text else {
            return
        }

        Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
            if error != nil {
                // Handle the error (e.g., display an alert)
            } else {
                // User signed up successfully
            }
        }
    }

//    @IBAction func loginButtonTapped(_ sender: UIButton) {
//        guard let email = emailTextField.text, let password = passwordTextField.text else {
//            return
//        }
//
//        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
//            if let error = error {
//                // Handle the error (e.g., display an alert)
//            } else {
//                // User logged in successfully
//            }
//        }
//    }
}

