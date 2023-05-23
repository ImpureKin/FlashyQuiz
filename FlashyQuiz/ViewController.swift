//
//  ViewController.swift
//  FlashyQuiz
//
//  Created by Eren Atilgan on 2/5/2023.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        let userManager = UserManager()
        
        if let userDetails = userManager.getUserDetails(userId: 1) {
            print("User ID: \(userDetails.id)")
            print("Username: \(userDetails.username)")
            print("Email: \(userDetails.email)")
        } else {
            print("User not found.")
        }

        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
}
