//
//  QuizMainMenuViewController.swift
//  FlashyQuiz
//
//  Created by Alyssa Rodriguez on 20/5/2023.
//

import UIKit

class QuizMainMenuViewController: UIViewController {
    
    var LoggedUser: User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let TabCont = self.tabBarController as! BaseTabBarController
        LoggedUser = TabCont.loggedUser;
    }

}
