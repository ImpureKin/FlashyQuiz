//
//  QuizMainMenuViewController.swift
//  FlashyQuiz
//
//  Created by Alyssa Rodriguez on 20/5/2023.
//

import UIKit

class QuizMainMenuViewController: UIViewController {
    
    var loggedUser: User!
    var userId: Int!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tabCont = self.tabBarController as! BaseTabBarController
        loggedUser = tabCont.loggedUser
        
        if let userIdValue = loggedUser?.userId {
            userId = userIdValue
            print("userId: \(userId)")
        } else {
            print("userId is nil")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToCreate" {
            // Retrieve the destination view controller
            guard let createQuizVC = segue.destination as? CreateQuizViewController else {
                return
            }
            
            // Pass the loggedUser to createQuizVC
            createQuizVC.loggedUser = loggedUser
        } else if segue.identifier == "goToUserQuiz" {
            // Retrieve the destination view controller
            guard let userQuizVC = segue.destination as? QuizListViewController else {
                return
            }
            
            // Pass the userId to userQuizVC
            userQuizVC.userId = userId
        }
    }
}
