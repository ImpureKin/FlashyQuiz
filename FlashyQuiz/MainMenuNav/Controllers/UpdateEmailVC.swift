//
//  UpdateEmailVC.swift
//  FlashyQuiz
//
//  Created by Nicholas  Schlederer on 30/5/2023.
//

import Foundation
import UIKit

class UpdateEmailVC : UIViewController {
    
    var LoggedUser: User?
    let userManager = UserManager()
    
    
    @IBOutlet weak var CurrentEmailTF: UITextField!
    
    @IBOutlet weak var newEmailTF: UITextField!
    
    @IBOutlet weak var RepeatNewEmailTF: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    @IBAction func UpdateEmailButton(_ sender: Any) {
        
        let currentEmail = CurrentEmailTF.text ?? ""
        let newEmailOne = newEmailTF.text ?? ""
        let newEmailTwo = RepeatNewEmailTF.text ?? ""
        
        if (currentEmail == LoggedUser?.email) {
            if (newEmailOne == newEmailTwo) {
                LoggedUser?.setEmail(newEmail: newEmailOne)
                let alert = UIAlertController(title: "Success",message: "Your email has been updated.", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                alert.addAction(okAction)
                present(alert, animated: true, completion: nil)
            } else {
                let alert = UIAlertController(title: "Mismatched Emails",message: "The new Emails provided do not match. Please ensure they are identical.", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                alert.addAction(okAction)
                present(alert, animated: true, completion: nil)
            }
        } else {
            let alert = UIAlertController(title: "Incorrect Current Email",message: "The current email provided does not match the email for this account.", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(okAction)
            present(alert, animated: true, completion: nil)
        }
        
    }
}
