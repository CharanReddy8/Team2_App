import UIKit
import Firebase

class LoginViewController: UIViewController {
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var rememberMeSwitch: UISwitch!
    @IBOutlet weak var eyeButton: UIButton!
    
    var isPasswordVisible = false

    override func viewDidLoad() {
        super.viewDidLoad()
        
        password?.isSecureTextEntry = true
        rememberMeSwitch.isOn = false
        eyeButton.setImage(UIImage(systemName: "eye.slash"), for: .normal) // Initial image should represent a hidden state
        eyeButton.addTarget(self, action: #selector(togglePasswordVisibility), for: .touchUpInside)
  
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
        
        if UserDefaults.standard.bool(forKey: "userLoggedIn") {
            if let savedEmail = UserDefaults.standard.string(forKey: "userEmail"),
               let savedPassword = UserDefaults.standard.string(forKey: "userPassword") {
                email.text = savedEmail
                password.text = savedPassword
                rememberMeSwitch.isOn = true
            }
        }
    }
    
//    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
//        return .portrait // Or any other specific orientation you want to support
//    }

    @objc func togglePasswordVisibility() {
               isPasswordVisible.toggle()
               password.isSecureTextEntry = !isPasswordVisible
               let eyeImage = isPasswordVisible ? UIImage(systemName: "eye") : UIImage(systemName: "eye.slash")
               eyeButton.setImage(eyeImage, for: .normal)
           }
    
    @IBAction func signUpButtonTapped(_ sender: UIButton) {
        if let authViewController = self.storyboard?.instantiateViewController(withIdentifier: "AuthViewController") {
            authViewController.modalPresentationStyle = .fullScreen
            self.present(authViewController, animated: false, completion: nil)
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
//                let successAlert = UIAlertController(title: "Login Successful", message: "You have successfully logged in.", preferredStyle: .alert)
//                let okAction = UIAlertAction(title: "OK", style: .default, handler: { (action) in
//                    // You can perform any additional actions upon successful login
                    self.switchToTabBarController()
//                })
//                successAlert.addAction(okAction)
//                self.present(successAlert, animated: true, completion: nil)
            }
            
            if self.rememberMeSwitch.isOn {
                                // Save user information in UserDefaults
                                UserDefaults.standard.set(email, forKey: "userEmail")
                                UserDefaults.standard.set(password, forKey: "userPassword")
                                UserDefaults.standard.set(true, forKey: "userLoggedIn")
                            } else {
                                // Clear user information from UserDefaults if "Remember Me" is turned off
                                UserDefaults.standard.removeObject(forKey: "userEmail")
                                UserDefaults.standard.removeObject(forKey: "userPassword")
                                UserDefaults.standard.set(false, forKey: "userLoggedIn")
                            }
        }
    }
}

///////////////////////////////////////////// with Face id//////////////////////////////////////////////

//import UIKit
//import Firebase
//import LocalAuthentication
//
//class LoginViewController: UIViewController {
//    @IBOutlet weak var email: UITextField!
//    @IBOutlet weak var password: UITextField!
//    @IBOutlet weak var rememberMeSwitch: UISwitch!
//    @IBOutlet weak var eyeButton: UIButton!
//    
//    var isPasswordVisible = false
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        
//        password?.isSecureTextEntry = true
//        rememberMeSwitch.isOn = false
//        eyeButton.setImage(UIImage(systemName: "eye.slash"), for: .normal) // Initial image should represent a hidden state
//        eyeButton.addTarget(self, action: #selector(togglePasswordVisibility), for: .touchUpInside)
//  
//        let blueColor = UIColor(red: 189/255.0, green: 235/255.0, blue: 245/255.0, alpha: 1.0)
//        let pinkColor = UIColor(red: 245/255.0, green: 189/255.0, blue: 189/255.0, alpha: 1.0)
//        
//        // Create a gradient layer
//        let gradientLayer = CAGradientLayer()
//        gradientLayer.frame = view.bounds
//        gradientLayer.colors = [blueColor.cgColor, pinkColor.cgColor]
//        
//        // Adjust the startPoint and endPoint for a vertical gradient
//        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.0)
//        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1.0)
//
//        // Add the gradient layer to the view's layer
//        view.layer.insertSublayer(gradientLayer, at: 0)
//        
//        if UserDefaults.standard.bool(forKey: "userLoggedIn") {
//            if let savedEmail = UserDefaults.standard.string(forKey: "userEmail"),
//               let savedPassword = UserDefaults.standard.string(forKey: "userPassword") {
//                email.text = savedEmail
//                password.text = savedPassword
//                rememberMeSwitch.isOn = true
//            }
//        }
//    }
//    
//    @objc func togglePasswordVisibility() {
//        isPasswordVisible.toggle()
//        password.isSecureTextEntry = !isPasswordVisible
//        let eyeImage = isPasswordVisible ? UIImage(systemName: "eye") : UIImage(systemName: "eye.slash")
//        eyeButton.setImage(eyeImage, for: .normal)
//    }
//    
//    @IBAction func signUpButtonTapped(_ sender: UIButton) {
//        if let authViewController = self.storyboard?.instantiateViewController(withIdentifier: "AuthViewController") {
//            authViewController.modalPresentationStyle = .fullScreen
//            self.present(authViewController, animated: false, completion: nil)
//        }
//    }
//    
//    func switchToTabBarController() {
//        if let tabBarController = storyboard?.instantiateViewController(withIdentifier: "YourTabBarControllerIdentifier") as? UITabBarController {
//            UIApplication.shared.keyWindow?.rootViewController = tabBarController
//        }
//    }
//    
//    @IBAction func FButtonTapped(_ sender: UIButton) {
//        performSegue(withIdentifier: "forgot", sender: self)
//    }
//    
//    @IBAction func loginButtonTapped(_ sender: UIButton) {
//        guard let email = email.text, let password = password.text else {
//            return
//        }
//        
//        if rememberMeSwitch.isOn {
//            let context = LAContext()
//            var error: NSError?
//
//            if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
//                let reason = "Authenticate with Face ID"
//                context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { [weak self] success, authenticationError in
//                    DispatchQueue.main.async {
//                        if success {
//                            // Authentication successful, proceed with stored credentials
//                            self?.authenticateUsingSavedCredentials(email: email, password: password)
//                        } else {
//                            // Authentication failed or user canceled
//                            if let error = authenticationError {
//                                // Handle authentication error
//                                let alert = UIAlertController(title: "Authentication Failed", message: error.localizedDescription, preferredStyle: .alert)
//                                let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
//                                alert.addAction(okAction)
//                                self?.present(alert, animated: true, completion: nil)
//                            }
//                        }
//                    }
//                }
//            } else {
//                // Device doesn't support Face ID or Touch ID
//                let alert = UIAlertController(title: "Biometric Authentication Not Available", message: "Your device doesn't support Face ID or Touch ID.", preferredStyle: .alert)
//                let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
//                alert.addAction(okAction)
//                present(alert, animated: true, completion: nil)
//            }
//        } else {
//            // Normal login flow without Face ID authentication
//            Auth.auth().signIn(withEmail: email, password: password) { [weak self] (user, error) in
//                if let error = error {
//                    // Handle the error (e.g., display an alert for login failure)
//                    let alert = UIAlertController(title: "Login Failed", message: error.localizedDescription, preferredStyle: .alert)
//                    let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
//                    alert.addAction(okAction)
//                    self?.present(alert, animated: true, completion: nil)
//                } else {
//                    // User logged in successfully
//                    self?.switchToTabBarController()
//                }
//            }
//        }
//    }
//
//    func authenticateUsingSavedCredentials(email: String, password: String) {
//        Auth.auth().signIn(withEmail: email, password: password) { [weak self] (user, error) in
//            if let error = error {
//                // Handle login failure
//                // Display an alert or handle the error accordingly
//                let alert = UIAlertController(title: "Login Failed", message: error.localizedDescription, preferredStyle: .alert)
//                let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
//                alert.addAction(okAction)
//                self?.present(alert, animated: true, completion: nil)
//            } else {
//                // User logged in successfully
//                self?.switchToTabBarController()
//            }
//        }
//    }
//}
