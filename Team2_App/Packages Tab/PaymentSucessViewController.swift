//
//  PaymentSucessViewController.swift
//  Exercise5_Vundela_Venkata
//
//  Created by Charan Reddy on 10/30/23.
//

import UIKit

class PaymentSucessViewController: UIViewController {
    @IBOutlet weak var dates: UILabel!
    @IBOutlet weak var city: UILabel!
    @IBOutlet weak var ima: UIImageView!
    @IBOutlet weak var amount: UILabel!

            override func viewDidLoad() {
                
                // Create a UIButton
                let nextButton = UIButton(type: .custom)
                nextButton.setTitle("Done", for: .normal)
                nextButton.setTitleColor(UIColor.black, for: .normal) // Set the text color to blue
                nextButton.addTarget(self, action: #selector(doneButtonClicked), for: .touchUpInside)
                nextButton.sizeToFit()

                // Wrap the button in a UIBarButtonItem
                let nextBarButtonItem = UIBarButtonItem(customView: nextButton)

                // Assigning to the right bar button item
                navigationItem.rightBarButtonItem = nextBarButtonItem
                self.navigationItem.setHidesBackButton(true, animated: false)
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
                
                
                if let savedData = UserDefaults.standard.data(forKey: "myDataKey"),
               let decodedPlace = try? JSONDecoder().decode(Place.self, from: savedData),
                   let _ = Int(decodedPlace.occupancy) {
                    dates.text = decodedPlace.date
                    city.text = decodedPlace.name
                    ima.image = UIImage(named: decodedPlace.imageName)
            
                }
                if let retrievedZ = UserDefaults.standard.object(forKey: "paymentamount") as? Int {
                    amount.text = String(retrievedZ) // Convert 'retrievedZ' to a string
                }
            }
    
//    @IBAction func doneButtonClicked(_ sender: UIButton) {
//        if let tabBarController = storyboard?.instantiateViewController(withIdentifier: "YourTabBarControllerIdentifier") as? UITabBarController,
//           let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
//           let sceneDelegate = windowScene.delegate as? SceneDelegate,
//           let window = sceneDelegate.window {
//            tabBarController.selectedIndex = 0 // Change this index to the tab you want to navigate to
//            window.rootViewController = tabBarController
//        }
//    }
    
    @objc func doneButtonClicked() {
        if let tabBarController = storyboard?.instantiateViewController(withIdentifier: "YourTabBarControllerIdentifier") as? UITabBarController,
           let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let sceneDelegate = windowScene.delegate as? SceneDelegate,
           let window = sceneDelegate.window {
            tabBarController.selectedIndex = 0 // Change this index to the tab you want to navigate to
            window.rootViewController = tabBarController
        }
    }


//    @IBAction func myBookingsButtonClicked(_ sender: UIButton) {
//        if let tabBarController = self.tabBarController {
//                tabBarController.selectedIndex = 1
//            }
//    }

    
            

}

