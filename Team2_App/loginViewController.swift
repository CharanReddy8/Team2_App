import UIKit
import Firebase

class LoginViewController: UIViewController {
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func signUpButtonTapped(_ sender: UIButton) {
        if let authViewController = self.storyboard?.instantiateViewController(withIdentifier: "AuthViewController") {
            authViewController.modalPresentationStyle = .fullScreen
            self.present(authViewController, animated: true, completion: nil)
        }
    }
    
    func switchToTabBarController() {
           if let tabBarController = storyboard?.instantiateViewController(withIdentifier: "YourTabBarControllerIdentifier") as? UITabBarController {
               UIApplication.shared.keyWindow?.rootViewController = tabBarController
           }
       }
    @IBAction func FButtonTapped(_ sender: UIButton) {
        performSegue(withIdentifier: "forgot", sender: self)
    }
    
    
    @IBAction func loginButtonTapped(_ sender: UIButton) {
        guard let email = email.text, let password = password.text else {
            return
        }
        
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            if let error = error {
                // Handle the error (e.g., display an alert for login failure)
                let alert = UIAlertController(title: "Login Failed", message: error.localizedDescription, preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                alert.addAction(okAction)
                self.present(alert, animated: true, completion: nil)
            } else {
                // User logged in successfully
                let successAlert = UIAlertController(title: "Login Successful", message: "You have successfully logged in.", preferredStyle: .alert)
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

