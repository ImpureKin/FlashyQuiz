//
//  QuizMainMenuViewController.swift
//  FlashyQuiz
//
//  Created by Alyssa Rodriguez on 20/5/2023.
//

import UIKit

class QuizMainMenuViewController: UIViewController {
    
    var loggedUser: User?
    var userId: Int?
    var username : String?
    
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
            guard let createQuizVC = segue.destination as? AddTittleCreateQuizViewController else {
                return
            }
            
            if let userIdValue = userId {
                createQuizVC.userId = userIdValue
            }
            
        } else if segue.identifier == "goToUserQuiz" {
            guard let userQuizVC = segue.destination as? QuizListViewController else {
                return
            }
            
            if let userIdValue = userId {
                userQuizVC.userId = userIdValue
            }
            if let usernameValue = username {
                userQuizVC.username = usernameValue
            }
        }
    }
}
