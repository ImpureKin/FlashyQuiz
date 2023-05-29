//
//  FlashCardMainMenuViewController.swift
//  FlashyQuiz
//
//  Created by Ashton Chan on 29/5/2023.
//

import UIKit

class FlashCardMainMenuViewController: UIViewController {
    
    var loggedUser: User?
    var userId: Int?
    var username: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tabCont = self.tabBarController as! BaseTabBarController
        loggedUser = tabCont.loggedUser
        username = tabCont.loggedUser?.username
        
        if let userIdValue = loggedUser?.userId {
            userId = userIdValue
            print("userId: \(userId)")
        } else {
            print("userId is nil")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToCreate" {
            guard let createFlashcardVC = segue.destination as? AddTitleFlashCardViewController else {
                return
            }
            
            if let userIdValue = userId {
                createFlashcardVC.userId = userIdValue
            }
            
        } else if segue.identifier == "goToUserDecks" {
            guard let userFlashcardVC = segue.destination as? FlashCardListViewController else {
                return
            }
            
            if let userIdValue = userId {
                userFlashcardVC.userId = userIdValue
            }
            if let usernameValue = username {
                userFlashcardVC.username = usernameValue
            }
        }
    }
}

