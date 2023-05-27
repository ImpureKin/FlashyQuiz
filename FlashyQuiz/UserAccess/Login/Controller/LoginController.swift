//
//  LoginController.swift
//  FlashyQuiz
//
//  Created by Eren Atilgan on 22/5/2023.
//

import Foundation
import UIKit

class LoginController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginFailedLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        loginFailedLabel.isHidden = true
    }

    // Acquire UserManager
    let userManager = UserManager()
    var loginSeguePerformed = false

    @IBAction func loginButtonPressed(_ sender: Any) {
        let emailInput = emailTextField.text ?? ""
        let passwordInput = passwordTextField.text ?? ""


        if let user = userManager.loginUser(email: emailInput, password: passwordInput) {
            if let destinationVC = storyboard?.instantiateViewController(withIdentifier: "BaseTabBarController") as? BaseTabBarController {

                destinationVC.loggedUser = user

                destinationVC.modalTransitionStyle = .crossDissolve
                            
                destinationVC.modalPresentationStyle = .overFullScreen


                present(destinationVC, animated: true, completion: nil)
            }
        } else {

            loginFailedLabel.isHidden = false
        }
    }
}

