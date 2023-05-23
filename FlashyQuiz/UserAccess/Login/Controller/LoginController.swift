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
    
    @IBAction func loginButtonPressed(_ sender: Any) {
        let emailInput = emailTextField.text ?? ""
        let passwordInput = passwordTextField.text ?? ""
        
        // Attempt to log in the user
        if let user = userManager.loginUser(email: emailInput, password: passwordInput) {
            // Login successful - redirect to home, passing User as well
            performSegue(withIdentifier: "goToHome", sender: user)
        } else {
            // Login failed - show login failed message
            loginFailedLabel.isHidden = false
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToHome",
           let destination = segue.destination as? HomeViewController,
           let user = sender as? User {
            // Pass the user object to the Home view controller
            destination.loggedUser = user
        }
    }
}

