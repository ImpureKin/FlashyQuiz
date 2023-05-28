//
//  SignUpController.swift
//  FlashyQuiz
//
//  Created by Eren Atilgan on 22/5/2023.
//

import Foundation
import UIKit

// To do

// 1. Insert label for failed sign up attempts
// 2. Add function(s) to validate user inputs (i.e. email requires '@', username is minimum 8 chars, password.... etc

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
        
        // Validate input
        if emailInput.isEmpty || usernameInput.isEmpty || passwordInput.isEmpty {
            print("Please fill in all fields.") // Convert to label
            return
        }
        
        // Attempt to add/sign up user
        result = userManager.addUser(username: usernameInput, email: emailInput, password: passwordInput)
        if result.contains("Success"){
            // Signup successful - redirect to successful signup page
            performSegue(withIdentifier: "goToSuccessfulSignup", sender: sender)
        } else if result.contains("UNIQUE") && result.contains("Users.email") {
            // Signup failed due to existing email - show signup failed message
            print("Signup was not successful - The email you have provided is already being used.") // Convert to label -- add more cases
        } else if result.contains("UNIQUE") && result.contains("Users.username") {
            // Signup failed due to existing username - show signup failed message
            print("Signup was not successful - The username you have provided is already being used.") // Convert to label -- add more cases
        } else {
            // Signup failed due to unknown error - show signup failed message
            print("Signup was not successful - Unknown error.") // Convert to label -- add more cases
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
