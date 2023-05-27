//
//  SettingsPageVC.swift
//  FlashyQuiz
//
//  Created by Nicholas  Schlederer on 24/5/2023.
//

import Foundation
import UIKit

class SettingsPageVC: UIViewController {
    
    
    @IBOutlet weak var Error_Label: UILabel!
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
        Error_Label.isHidden = true;
    }
    
    
    @IBAction func UpdateButtonPressed(_ sender: Any) {
        
        let currentEmail = LoggedUser?.email ?? ""
        let currentPassword = CurrentPassWordTF.text ?? ""
        
        let newPasswordOne = PasswordOneTF.text ?? ""
        let newPasswordTwo = PasswordTwoTF.text ?? ""
        
        if userManager.loginUser(email: currentEmail, password: currentPassword) != nil { // checks if the current password would log into the current account
            
            if (newPasswordOne == newPasswordTwo) {
                LoggedUser?.setPassword(oldPassword: currentPassword, newPassword: newPasswordOne)
                Error_Label.isHidden = false
                Error_Label.text = "Password Updated!"
                Error_Label.textColor = .green
                
                
            } else {
                Error_Label.textColor = .red
                Error_Label.isHidden = false
                Error_Label.text = "New Passwords Dont Match"
            }
            
        } else {
            Error_Label.textColor = .red
            Error_Label.isHidden = false
            Error_Label.text = "Incorrect Current Password"
        }
        
        
    }
    

    
}
