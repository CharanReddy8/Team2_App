//
//  ForgotViewController.swift
//  Team2_App
//
//  Created by Charan Reddy on 10/26/23.
//

import UIKit
import FirebaseAuth

class ForgotViewController: UIViewController {
    @IBOutlet weak var emailLabel: UITextField!
    
    @IBAction func RButtonTapped(_ sender: UIButton) {
        if let email = emailLabel.text {
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
                    let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                    alert.addAction(okAction)
                    self.present(alert, animated: true, completion: nil)
                }
            }
        }

    }
    

}
