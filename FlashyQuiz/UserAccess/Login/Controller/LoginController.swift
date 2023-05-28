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
    @IBOutlet weak var loginButton: UIButton!
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
        
    
        if let user = userManager.loginUser(email: emailInput, password: passwordInput),
           !loginSeguePerformed {
            
            loginSeguePerformed = true
            performSegue(withIdentifier: "goToHome", sender: user)
        } else {
           
            loginFailedLabel.isHidden = false
        }
    }

    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if identifier == "goToHome" && loginSeguePerformed {
            
            return false
        }
        return true
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToHome",
           let destination = segue.destination as? BaseTabBarController,
           let user = sender as? User {
            
            destination.loggedUser = user
        }
    }

}

