//
//  UpdateUsername.swift
//  FlashyQuiz
//
//  Created by Nicholas  Schlederer on 30/5/2023.
//

import Foundation
import UIKit

class UpdatePasswordVC : UIViewController {
    
    @IBOutlet weak var updateButton: UIButton!
    
    @IBOutlet weak var currentPasswordTF: UITextField!
    
    @IBOutlet weak var newPasswordTF: UITextField!
    
    @IBOutlet weak var newPasswordTwoTF: UITextField!
    
    var LoggedUser: User?
    let userManager = UserManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func UpdatePasswordButtonPressed(_ sender: Any) {
        let currentPassword = currentPasswordTF.text ?? ""
        let NewPasswordOne = newPasswordTF.text ?? ""
        let NewPasswordTwo = newPasswordTwoTF.text ?? ""
        
        if (userManager.loginUser(email: LoggedUser!.email , password: currentPassword) != nil) {
            
            
            if (NewPasswordOne == NewPasswordTwo) {
                LoggedUser?.setPassword(newPassword: NewPasswordOne)
                
                let alert = UIAlertController(title: "Success!",message: "Your password has been updated.", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .default, handler: {action in self.performSegue(withIdentifier: "PasswordBackToNV", sender: self)})
                alert.addAction(okAction)
                present(alert, animated: true, completion: nil)
                
            } else {
                let alert = UIAlertController(title: "Mismatched Passwords",message: "The new passwords provided do not match. Please ensure they are identical.", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                alert.addAction(okAction)
                present(alert, animated: true, completion: nil)
            }
        } else {
            let alert = UIAlertController(title: "Incorrect Current Password",message: "The current password provided does not match the password for this account.", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(okAction)
            present(alert, animated: true, completion: nil)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "PasswordBackToNV" {
            guard let backToMainTV = segue.destination as? BaseTabBarController else {
                return
            }
            backToMainTV.loggedUser = self.LoggedUser;
        }
                
    }
    

    
}
