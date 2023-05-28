//
//  HomeViewController.swift
//  FlashyQuiz
//
//  Created by Eren Atilgan on 23/5/2023.
//

import Foundation
import UIKit

class HomeViewController: UIViewController {
    
    @IBOutlet weak var usernameLabel: UILabel!
    var loggedUser: User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        usernameLabel.text = loggedUser?.username
    }
    
    

}
