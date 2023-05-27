//
//  SettingsPageVC.swift
//  FlashyQuiz
//
//  Created by Nicholas  Schlederer on 24/5/2023.
//

import Foundation
import UIKit

class SettingsPageVC: UIViewController {
    
    var LoggedUser: User?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let TabCont = self.tabBarController as! BaseTabBarController
        LoggedUser = TabCont.loggedUser;
    }
    

    
}
