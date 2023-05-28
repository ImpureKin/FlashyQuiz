//
//  AddTitleDeckViewController.swift
//  FlashyQuiz
//
//  Created by Ashton Chan on 29/5/2023.
//

import UIKit

class AddTitleFlashCardViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var flashcardTitle: UITextField!
    @IBOutlet weak var errorMessage: UILabel!
    @IBOutlet weak var privacySwitch: UISwitch!
    
    var userId: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("userId: \(userId)")
        errorMessage.isHidden = true
        flashcardTitle.delegate = self
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToCreateFlashCard" {
            if let title = flashcardTitle.text, !title.isEmpty {
                let VC = segue.destination as! CreateFlashCardViewController
                VC.selectedTitle = flashcardTitle.text!
                VC.selectedPrivacy = privacySwitch.isOn ? "public" : "private"
                VC.userId = userId
            } else {
                errorMessage.isHidden = false
            }
        }
    }
      
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if identifier == "goToCreateFlashCard" {
            if let title = flashcardTitle.text, title.isEmpty {
                // The flashcard title is empty
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
