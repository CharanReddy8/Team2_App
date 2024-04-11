

import UIKit
import FirebaseAuth
import FirebaseFirestore

class DetailViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var nametxtfield: UITextField!
    @IBOutlet weak var dobtxtfield: UITextField!
    @IBOutlet weak var addresstxtfield: UITextField!
    @IBOutlet weak var phonetxtfield: UITextField!
    @IBOutlet weak var emailtxtfield: UITextField!
    @IBOutlet weak var profileImageView: UIImageView!
    
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var uploadImageButton: UIButton!
    
    var user: User?
    var originalUserData: [String: Any] = [:]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(profileImageViewTapped))
           profileImageView.addGestureRecognizer(tapGesture)
           profileImageView.isUserInteractionEnabled = true
        
        let blueColor = UIColor(red: 189/255.0, green: 235/255.0, blue: 245/255.0, alpha: 1.0)
        let pinkColor = UIColor(red: 245/255.0, green: 189/255.0, blue: 189/255.0, alpha: 1.0)
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = view.bounds
        gradientLayer.colors = [blueColor.cgColor, pinkColor.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1.0)

        view.layer.insertSublayer(gradientLayer, at: 0)
        
        loadUserDetails()
        saveButton.isEnabled = false
        profileImageView.layer.cornerRadius = profileImageView.bounds.width / 2
        profileImageView.layer.masksToBounds = true
        profileImageView.contentMode = .scaleAspectFill
        
        loadProfileImage() // Load saved profile image if exists
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadUserDetails()
        loadProfileImage()
        profileImageView.layer.cornerRadius = profileImageView.bounds.width / 2
        profileImageView.layer.masksToBounds = true
        profileImageView.contentMode = .scaleAspectFill
    }
    
    @IBAction func SoutButtonTapped(_ sender: UIButton) {
        do {
            try Auth.auth().signOut()
            if let authViewController = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") {
                authViewController.modalPresentationStyle = .fullScreen
                self.present(authViewController, animated: true, completion: nil)
            }
        } catch let error as NSError {
            print("Sign Out Error: \(error.localizedDescription)")
        }
    }
    
    @IBAction func uploadImageButtonTapped(_ sender: UIButton) {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.sourceType = .photoLibrary
        present(imagePickerController, animated: true, completion: nil)
    }
    
    @objc func profileImageViewTapped() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.sourceType = .photoLibrary
        present(imagePickerController, animated: true, completion: nil)
    }

    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[.originalImage] as? UIImage {
            profileImageView.image = pickedImage
            saveButton.isEnabled = true
            
            saveProfileImage(image: pickedImage) // Save the picked image locally
        }
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveButtonTapped(_ sender: UIButton) {
           // Save the updated user data to Firebase
           if let user = Auth.auth().currentUser {
               let uid = user.uid
               let db = Firestore.firestore()
               let userRef = db.collection("users").document(uid)
   
               // Update Firestore document with new data
               userRef.updateData([
                   "name": nametxtfield.text ?? "",
                   "email": emailtxtfield.text ?? "",
                   "phn": phonetxtfield.text ?? "",
                   "add": addresstxtfield.text ?? "",
                   "dob": dobtxtfield.text ?? ""
               ]) { error in
                   if let error = error {
                       print("Error updating document: \(error.localizedDescription)")
                   } else {
                       print("Document successfully updated")
                       // Update the original user data
                       self.originalUserData = [
                           "name": self.nametxtfield.text ?? "",
                           "email": self.emailtxtfield.text ?? "",
                           "phn": self.phonetxtfield.text ?? "",
                           "add": self.addresstxtfield.text ?? "",
                           "dob": self.dobtxtfield.text ?? ""
                       ]
   
                       // Disable the save button again after saving
                       self.saveButton.isEnabled = false
                   }
               }
           }
       }
    
    func userHasChanges() -> Bool {
            return nametxtfield.text != originalUserData["name"] as? String ||
                   emailtxtfield.text != originalUserData["email"] as? String ||
                   phonetxtfield.text != originalUserData["phn"] as? String ||
                   addresstxtfield.text != originalUserData["add"] as? String ||
                   dobtxtfield.text != originalUserData["dob"] as? String
        }
    
        // Update the save button status based on user changes
        @IBAction func textFieldDidChange(_ sender: UITextField) {
            saveButton.isEnabled = userHasChanges()
        }
   
       // Function to load and display user details
       func loadUserDetails() {
           if let user = Auth.auth().currentUser {
               let uid = user.uid
               let db = Firestore.firestore()
               let userRef = db.collection("users").document(uid)
   
               userRef.getDocument { (document, error) in
                   if let document = document, document.exists {
                       if let data = document.data() {
                           // Populate the UI labels with the user's data
                           self.nametxtfield.text = data["name"] as? String ?? "No Name"
                           self.emailtxtfield.text = data["email"] as? String ?? "No Email"
                           self.phonetxtfield?.text = data["phn"] as? String ?? "No phone"
                           self.addresstxtfield?.text = data["add"] as? String ?? "No address"
                           self.dobtxtfield?.text = data["dob"] as? String ?? "please update the DOB"
   
                           // Save the original user data for later comparison
                           self.originalUserData = data
                       }
                   } else {
                       print("Document does not exist")
                   }
               }
           }
       }
   
    
    // Save profile image locally using UserDefaults with user's UID as a key
    func saveProfileImage(image: UIImage) {
        if let user = Auth.auth().currentUser {
            let uid = user.uid
            if let imageData = image.jpegData(compressionQuality: 0.25) {
                let key = "profileImageData_\(uid)"
                UserDefaults.standard.set(imageData, forKey: key)
            }
        }
    }
    
    // Load saved profile image using user's UID
    func loadProfileImage() {
        if let user = Auth.auth().currentUser {
            let uid = user.uid
            let key = "profileImageData_\(uid)"
            if let imageData = UserDefaults.standard.data(forKey: key) {
                if let image = UIImage(data: imageData) {
                    profileImageView.image = image
                }
            }
        }
    }
}
