//
//  AccountManagermentVC.swift
//  FlashyQuiz
//
//  Created by Nicholas  Schlederer on 30/5/2023.
//

import Foundation
import UIKit


class AccountManagementVC : UIViewController {
    
    var LoggedUser: User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tabCont = self.tabBarController as! BaseTabBarController
        LoggedUser = tabCont.loggedUser
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
            
        case "AccToEmail":
            guard let updateEmailVC = segue.destination as? UpdateEmailVC else {return}
            updateEmailVC.LoggedUser = LoggedUser
            
        case "AccToUsername":
            guard let updateUsernameVC = segue.destination as? UpdateUsernameVC else {return}
            updateUsernameVC.LoggedUser = LoggedUser
            
        case "AccToPassword":
            guard let updatePasswordVC = segue.destination as? UpdatePasswordVC else {return}
            updatePasswordVC.LoggedUser = LoggedUser
        
            
        default:
            break
        }
    }
}
