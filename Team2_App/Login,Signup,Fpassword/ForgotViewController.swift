//
//  ForgotViewController.swift
//  Team2_App
//
//  Created by Charan Reddy on 10/26/23.
//

import UIKit
import FirebaseAuth
import Firebase

class ForgotViewController: UIViewController {
    @IBOutlet weak var emailLabel: UITextField!
    
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
    }
    
    @IBAction func RButtonTapped(_ sender: UIButton) {
        guard let email = emailLabel.text else {
            return
        }
        
        // Check if the email exists in Firestore
        let db = Firestore.firestore()
        let usersRef = db.collection("users")
        usersRef.whereField("email", isEqualTo: email).getDocuments { (querySnapshot, error) in
            if let error = error {
                // Handle the error (e.g., display an alert with the error message)
                let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                alert.addAction(okAction)
                self.present(alert, animated: true, completion: nil)
            } else {
                if let documents = querySnapshot?.documents, documents.isEmpty {
                    // The email is not registered in the database
                    let alert = UIAlertController(title: "Email Not Found", message: "This email address is not associated with any account.", preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                    alert.addAction(okAction)
                    self.present(alert, animated: true, completion: nil)
                } else {
                    // The email exists in the database, so send a password reset email
                    Auth.auth().sendPasswordReset(withEmail: email) { error in
                        if let error = error {
                            // Handle the error (e.g., display an alert with the error message)
                            let alert = UIAlertController(title: "Password Reset Failed", message: error.localizedDescription, preferredStyle: .alert)
                            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                            alert.addAction(okAction)
                            self.present(alert, animated: true, completion: nil)
                        } else {
                            // Password reset email sent successfully
                            let alert = UIAlertController(title: "Email Sent", message: "A password reset email has been sent to your email address.", preferredStyle: .alert)
                            
                            // Create an "OK" action with a handler to navigate to another view controller
                            let okAction = UIAlertAction(title: "OK", style: .default) { (action) in
                                // Get the reference to the storyboard
                                self.dismiss(animated: true, completion: nil)
                            }
                            
                            alert.addAction(okAction)
                            
                            self.present(alert, animated: true, completion: nil)
                        }
                    }
                }
            }
        }
    }
    
    @IBAction func CButtonTapped(_ sender: UIButton) {
        if let authViewController = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") {
            authViewController.modalPresentationStyle = .fullScreen
            self.present(authViewController, animated: false, completion: nil)
            
        }
        
        
    }
}
