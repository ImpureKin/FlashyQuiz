//
//  UpdateUsername.swift
//  FlashyQuiz
//
//  Created by Nicholas  Schlederer on 30/5/2023.
//

import Foundation
import UIKit

class UpdatePasswordVC : UIViewController {
    
    
    @IBOutlet weak var CurrentPasswordTF: UITextField!
    
    @IBOutlet weak var NewPasswordOneTF: UITextField!
    @IBOutlet weak var NewPasswordTwoTF: UITextField!
    
    
    var LoggedUser: User?
    let userManager = UserManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    
    
}
