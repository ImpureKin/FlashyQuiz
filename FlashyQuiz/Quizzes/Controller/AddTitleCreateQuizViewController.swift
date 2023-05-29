//
//  AddTitleCreateQuizViewController.swift
//  FlashyQuiz
//
//  Created by Alyssa Rodriguez on 21/5/2023.
//

import UIKit

class AddTittleCreateQuizViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var quizTitle: UITextField! // Textfielf to quiz title
    @IBOutlet weak var errorMessage: UILabel! // Displays error message
    @IBOutlet weak var privacySwitch: UISwitch! // Switch to determine the privacy

    let quizManager = QuizManager() // Calls in the quiz manager class
    var userId: Int = 0 // Stores userID

    override func viewDidLoad() {
        super.viewDidLoad()

        errorMessage.isHidden = true // Sets error message as hidden
        quizTitle.delegate = self // Sets the delegate for the quiz textfield to self
    }

    // Segue to passes the variables into the next view controller
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToQuestions" {
            let VC = segue.destination as! CreateQuizViewController

            // passes the title, privacy and userid to the next view controller
            VC.selectedTitle = quizTitle.text!
            VC.selectedPrivacy = privacySwitch.isOn ? "public" : "private"
            VC.userId = userId
        }
    }
    // Stops the segue from performing if it returns false. If it returns true then segue is performed
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if identifier == "goToQuestions" {
            // Checks the quiz title is empty
            if let title = quizTitle.text, title.isEmpty {
                //shows error message
                errorMessage.isHidden = false
                return false //segue is not performed
            }

            // Check if the quiz title already exists
            if let title = quizTitle.text, quizManager.isExitingTitle(title: title, userId: userId) {
                // if its exits the error message will be shown with the error below
                errorMessage.isHidden = false
                errorMessage.text = "Error: Title already exists."
                return false //segue is not performed
            }
        }
        return true // segue is performed
    }

    // Function that Handles text field chnages
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        errorMessage.isHidden = true // hides the textfield when the textfield changes
        return true
    }
}
