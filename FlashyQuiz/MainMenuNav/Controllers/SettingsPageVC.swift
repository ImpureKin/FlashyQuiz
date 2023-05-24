//
//  SettingsPageVC.swift
//  FlashyQuiz
//
//  Created by Nicholas  Schlederer on 24/5/2023.
//

import Foundation
import UIKit

class SettingsPageVC: UIViewController {
    
    @IBOutlet weak var EmailTF: UITextField!
    @IBOutlet weak var NewPasswordOneTF: UITextField!
    @IBOutlet weak var UpdateButton: UIButton!
    @IBOutlet weak var NewPasswordTwoTF: UITextField!
    @IBOutlet weak var CurrentPasswordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    let userManager = UserManager()
    
    
    @IBAction func UpdatePassword(_ sender: Any) {
        let email = EmailTF.text ?? "" // handles null input
        let CurrentPassWord = CurrentPasswordTextField.text ?? ""
        let NewPassOne = NewPasswordOneTF.text ?? ""
        let NewPassTwo = NewPasswordTwoTF.text ?? ""
        
        if (userManager.loginUser(email: email, password: CurrentPassWord) != nil) {
            // functionality for existing login.
            if (NewPassOne == NewPassTwo) {
                // update Pword for Account.
            } else {
                // passwords dont match error
            }
        } else {
            // original login incorrect error
        }
        
    }
    
}
