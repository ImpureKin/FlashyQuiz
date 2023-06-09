//
//  UpdateUsernameVC.swift
//  FlashyQuiz
//
//  Created by Nicholas  Schlederer on 30/5/2023.
//

import Foundation
import UIKit

class UpdateUsernameVC : UIViewController {
    
    @IBOutlet weak var CurrentUserNameTF: UITextField!
    
    @IBOutlet weak var NewUsernameOneTF: UITextField!
    
    @IBOutlet weak var UpdateUsernameButton: UIButton!
    @IBOutlet weak var NewUsernameTwoTF: UITextField!
    
    var LoggedUser: User?
    let userManager = UserManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    @IBAction func UpdateUsernameButtonPressed(_ sender: Any) {
        
        let currentUsername = CurrentUserNameTF.text ?? ""
        let NewUsernameOne = NewUsernameOneTF.text ?? ""
        let NewUsernameTwo = NewUsernameTwoTF.text ?? ""
        
        if (LoggedUser?.username == currentUsername) {
            if (NewUsernameOne == NewUsernameTwo) {
                LoggedUser?.setUsername(newUsername: NewUsernameOne)
                let alert = UIAlertController(title: "Success",message: "Your username has been updated.", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .default, handler: {action in self.performSegue(withIdentifier: "resetPasswordBackToMain", sender: self)})
                alert.addAction(okAction)
                present(alert, animated: true, completion: nil)
            } else {
                let alert = UIAlertController(title: "Mismatched Usernames",message: "The new usernames provided do not match. Please ensure they are identical.", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                alert.addAction(okAction)
                present(alert, animated: true, completion: nil)
            }
            
        }
        let alert = UIAlertController(title: "Incorrect Current Username",message: "The current username provided, does not match the username for this account.", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "resetPasswordBackToMain" {
            guard let backToMainTV = segue.destination as? BaseTabBarController else {
                return
            }
            backToMainTV.loggedUser = self.LoggedUser;
        }
                
    }
    
    
    
    
}
