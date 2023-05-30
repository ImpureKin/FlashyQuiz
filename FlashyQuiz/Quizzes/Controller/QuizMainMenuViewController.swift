//
//  QuizMainMenuViewController.swift
//  FlashyQuiz
//
//  Created by Alyssa Rodriguez on 20/5/2023.
//

import UIKit

class QuizMainMenuViewController: UIViewController {

    var loggedUser: User? // To store the logged User and make it conform to the user data model
    var userId: Int? // Used to store the usersId
    var username: String? // Used to store the user's username

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.hidesBackButton = true // hides back button

        // used to pull the logged in users data from the BaseTabBarController which the data is currently being stored in.
        let tabCont = self.tabBarController as! BaseTabBarController
        loggedUser = tabCont.loggedUser // pulls the logged user data
        username = tabCont.loggedUser?.username // pulls the user name

        if let userIdValue = loggedUser?.userId {
            userId = userIdValue // only way I could find to pass the value without it being 0
        }
    }

    // Segue to push the user data to the different part storyboard screens
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "goToCreate": // if the segue identify equals this string a segue will occur
            guard let createQuizVC = segue.destination as? AddTittleCreateQuizViewController else {
                return
            }
            if let userIdValue = userId { // takes userid and makes it not an optional anymore
                createQuizVC.userId = userIdValue // passes value through
            }
        case "goToUserQuiz": // if the segue identify equals this string a segue will occur
            guard let userQuizVC = segue.destination as? QuizListViewController else {
                return
            }
            // takes userid and username and make not an option anymore for userId
            if let userIdValue = userId, let usernameValue = username {
                userQuizVC.userId = userIdValue // passes value through
                userQuizVC.username = usernameValue // passes value through
            }
        default:
            break
        }
    }
}
