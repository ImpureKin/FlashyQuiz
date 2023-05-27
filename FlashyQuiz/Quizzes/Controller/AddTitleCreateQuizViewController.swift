//
//  AddTitleCreateQuizViewController.swift
//  FlashyQuiz
//
//  Created by Alyssa Rodriguez on 21/5/2023.
//

import UIKit

class AddTittleCreateQuizViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var quizTitle: UITextField!
    @IBOutlet weak var errorMessage: UILabel!
    @IBOutlet weak var privacySwitch: UISwitch!
    
    var loggedUser: User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        errorMessage.isHidden = true
        quizTitle.delegate = self
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToQuestions" {
            if let title = quizTitle.text, !title.isEmpty {
                let VC = segue.destination as! CreateQuizViewController
                VC.selectedTitle = quizTitle.text!
                VC.selectedPrivacy = privacySwitch.isOn ? "public" : "private"
                VC.loggedUser = loggedUser
            } else {
                errorMessage.isHidden = false
            }
        }
    }
      
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if identifier == "goToQuestions" {
            if let title = quizTitle.text, title.isEmpty {
                // The quiz title is empty
                errorMessage.isHidden = false
                return false
            } else if !privacySwitch.isOn {
                // The privacy switch is off
                errorMessage.isHidden = false
                errorMessage.text = "Please enable privacy to proceed."
                return false
            }
        }
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
            errorMessage.isHidden = true
            return true
        }
  }
