import UIKit
import Firebase

class ProfileOverview: UITableViewController {

    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var email: UILabel!
    @IBOutlet weak var phone: UILabel!
    @IBOutlet weak var organizationName: UILabel!
    
    
    var ref: DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        ref = Database.database().reference()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        retrieveInfo()
    }
    
    @IBAction func logoutAction(_ sender: Any) {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            performSegueFunction(storyboardName: "Main")
        } catch let signOutError as NSError {
            showAlert(title: "Error!", message: signOutError.localizedDescription)
        }
        
    }
    
    func retrieveInfo() {
        let userID = Auth.auth().currentUser?.uid
        ref.child("users").child(userID!).observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            let value = snapshot.value as? NSDictionary
            let name = value?["fullName"] as? String ?? ""
            let email = value?["email"] as? String ?? ""
            let phone = value?["phone"] as? String ?? ""
            let organization = value?["organization"] as? String ?? ""
            
            self.name.text = name
            self.email.text = email
            self.phone.text = phone
            self.organizationName.text = organization
            
            if (organization == "") {
                self.organizationName.text = "None"
            }
            
            // ...
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
        
        self.present(alert, animated: true)
        
    }
    
    func performSegueFunction(storyboardName: String) {
        let viewController:UIViewController = UIStoryboard(name: storyboardName, bundle: nil).instantiateViewController(withIdentifier: "initialController") as UIViewController
        self.present(viewController, animated: false, completion: nil)
    }

}
