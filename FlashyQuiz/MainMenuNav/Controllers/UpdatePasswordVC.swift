//
//  UpdateUsername.swift
//  FlashyQuiz
//
//  Created by Nicholas  Schlederer on 30/5/2023.
//

import Foundation
import UIKit

class UpdatePasswordVC : UIViewController {
    
    @IBOutlet weak var CurrentPasswordTF: UITextField!
    
    @IBOutlet weak var UpdateButton: UIButton!
    

    @IBOutlet weak var NewPasswordOneTF: UITextField!
    
    @IBOutlet weak var NewPasswordTwoTF: UITextField!
    
    
    var LoggedUser: User?
    let userManager = UserManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    @IBAction func UpdatePasswordButton(_ sender: Any) {
        let currentPassword = CurrentPasswordTF.text ?? ""
        let NewPasswordOne = NewPasswordOneTF.text ?? ""
        let NewPasswordTwo = NewPasswordTwoTF.text ?? ""
        
        if (userManager.loginUser(email: LoggedUser!.email , password: currentPassword) != nil) {
            
            
            if (NewPasswordOne == NewPasswordTwo) {
                LoggedUser?.setPassword(oldPassword: currentPassword, newPassword: NewPasswordOne)
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
    
    
}
