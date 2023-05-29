//
//  SettingsPageVC.swift
//  FlashyQuiz
//
//  Created by Nicholas  Schlederer on 24/5/2023.
//

import Foundation
import UIKit

class SettingsPageVC: UIViewController {
    
    @IBOutlet weak var CurrentPassWordTF: UITextField!
    
    @IBOutlet weak var PasswordOneTF: UITextField!
    
    @IBOutlet weak var PasswordTwoTF: UITextField!
    
    @IBOutlet weak var UpdateButton: UIButton!
    
    var LoggedUser: User?
    let userManager = UserManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let TabCont = self.tabBarController as! BaseTabBarController
        LoggedUser = TabCont.loggedUser;
    }
    
    
    @IBAction func UpdateButtonPressed(_ sender: Any) {
        
        let currentEmail = LoggedUser?.email ?? ""
        let currentPassword = CurrentPassWordTF.text ?? ""
        
        let newPasswordOne = PasswordOneTF.text ?? ""
        let newPasswordTwo = PasswordTwoTF.text ?? ""
        
        if userManager.loginUser(email: currentEmail, password: currentPassword) != nil { // checks if the current password would log into the current account
            
            if (newPasswordOne == newPasswordTwo) {
                LoggedUser?.setPassword(oldPassword: currentPassword, newPassword: newPasswordOne)
                let success = UIAlertController(title: "Success!",
                                              message: "Your password has been updated for future logins!",
                                              preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                success.addAction(okAction)
                present(success, animated: true, completion: nil)
                
                
            } else {
                let alert = UIAlertController(title: "Mismatched Passwords",
                                              message: "You have provided two different password. Please provide the same password twice.",
                                              preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                alert.addAction(okAction)
                present(alert, animated: true, completion: nil)
            }
            
        } else {
            let alert = UIAlertController(title: "Incorrect Current Password",
                                          message: "You have provided the wrong details. Incorrect Current Password.",
                                          preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(okAction)
            present(alert, animated: true, completion: nil)
        }
        
        
    }
    

    
}
