//
//  ViewController.swift
//  FlashyQuiz
//
//  Created by Eren Atilgan on 2/5/2023.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        let database = Database()
        if let userDetails = database.getUserDetailsById(userId: 1) {
            print("User ID: \(userDetails.id)")
            print("Username: \(userDetails.username)")
            print("Email: \(userDetails.email)")
            print("Password: \(userDetails.password)")
        } else {
            print("User not found.")
        }
        
        if let userDetails = database.getUserDetailsById(usernameInput: "eatilgan") {
            print("User ID: \(userDetails.id)")
            print("Username: \(userDetails.username)")
            print("Email: \(userDetails.email)")
            print("Password: \(userDetails.password)")
        } else {
            print("User not found.")
        }

        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

}
