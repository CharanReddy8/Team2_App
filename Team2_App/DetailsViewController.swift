import UIKit
import FirebaseAuth
import FirebaseFirestore

class DetailViewController: UIViewController {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel?
    
    var user: User? // Create a User object to store user details
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Call a function to load and display user details
        loadUserDetails()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Call a function to load and display user details
        loadUserDetails()
    }
    
    @IBAction func SoutButtonTapped(_ sender: UIButton) {
        do {
            try Auth.auth().signOut()
            // Sign out was successful
            // You can also navigate the user back to the login screen or perform other actions
            if let authViewController = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") {
                authViewController.modalPresentationStyle = .fullScreen
                self.present(authViewController, animated: true, completion: nil)
            }
        } catch let error as NSError {
            // Handle any sign-out errors
            print("Sign Out Error: \(error.localizedDescription)")
        }
        
    }
    func loadUserDetails() {
        if let user = Auth.auth().currentUser {
            // Access the UID of the currently signed-in user
            let uid = user.uid
            print("User UID: \(uid)")
            
            // Access Firestore and retrieve the user's data based on the current user's UID
            let db = Firestore.firestore()
            let userRef = db.collection("users").document(uid) // Use the current user's UID
            
            userRef.getDocument { (document, error) in
                if let document = document, document.exists {
                    if let data = document.data() {
                        // Populate the UI labels with the user's data
                        self.nameLabel.text = data["name"] as? String ?? "No Name"
                        self.emailLabel.text = data["email"] as? String ?? "No Email"
                        self.phoneLabel?.text = data["phn"] as? String ?? "No phone"
                    }
                } else {
                    print("Document does not exist")
                }
            }
        }
        
    }
}
