//
//  SignUpController.swift
//  FlashyQuiz
//
//  Created by Eren Atilgan on 22/5/2023.
//

import Foundation
import UIKit

class SignupController: UIViewController {
    
    @IBOutlet weak var signupButton: UIButton!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    // Acquire UserManager
    let userManager = UserManager()
    
    // Extra loading
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func signupButtonPressed(_ sender: Any) {
        let emailInput = emailTextField.text ?? ""
        let usernameInput = usernameTextField.text ?? ""
        let passwordInput = passwordTextField.text ?? ""
        var result = ""
        
        // Validate input - move to function
        if emailInput.isEmpty || usernameInput.isEmpty || passwordInput.isEmpty {
            displayError(message: "Please fill in all fields and try again.")
            return
        }
        
        // Attempt to add/sign up user
        result = userManager.addUser(username: usernameInput, email: emailInput, password: passwordInput)
        if result.contains("Success"){
            // Signup successful - redirect to successful signup page
            performSegue(withIdentifier: "goToSuccessfulSignup", sender: sender)
        } else if result.contains("UNIQUE") && result.contains("Users.email") {
            // Signup failed due to existing email - show signup failed message
            displayError(message: "This email already exists. Please try again.")
        } else if result.contains("UNIQUE") && result.contains("Users.username") {
            // Signup failed due to existing username - show signup failed message
            displayError(message: "This username already exists. Please try again.")
        } else {
            // Signup failed due to unknown error - show signup failed message
            displayError(message: "Please try again.")
        }
    }
    
    func displayError(message: String) {
        let alert = UIAlertController(title: "Signup Failed",
                                      message: "\(message)",
                                      preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
}
