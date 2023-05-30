//
//  CreateQuizViewController.swift
//  FlashyQuiz
//
//  Created by Alyssa Rodriguez on 20/5/2023.
//

import UIKit
import Foundation

class CreateQuizViewController: UIViewController {

    @IBOutlet weak var quizTitle: UILabel! // stores the quiz title
    @IBOutlet weak var question: UITextField! // stores the question
    @IBOutlet weak var optionOne: UITextField! // optionOne stores the correctAnswer
    @IBOutlet weak var optionTwo: UITextField! // optionTwo stores an incorrectAnswers
    @IBOutlet weak var optionThree: UITextField! // optionThree store an incorrectAnswer
    @IBOutlet weak var optionFour: UITextField! // optionFour stores and incorrectAnswer 
    
    var userId: Int = 0 // To store the userID
    var selectedTitle: String = "" // To store the title choosen the user
    var selectedPrivacy: String = "" // Stores the privacy the user selected
    var questions : [Question] = [] // question array to store the questions the users are making
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // sets the title Label as the title the user inputed last view controller
        quizTitle.text = selectedTitle
    }
    
    // when function is called it clears the inputs of the textfields present
    func clearInputFields() {
        question.text = ""
        optionOne.text = ""
        optionTwo.text = ""
        optionThree.text = ""
        optionFour.text = ""
    }
    
    // add question button when the button is pressed
    @IBAction func addQuestionButtonPressed(_ sender: Any) {
        // checks if any of the any of the text fields are empty
        guard let questionText = question.text, !questionText.isEmpty,
                 let optionOneText = optionOne.text, !optionOneText.isEmpty,
                 let optionTwoText = optionTwo.text, !optionTwoText.isEmpty,
                 let optionThreeText = optionThree.text, !optionThreeText.isEmpty,
                 let optionFourText = optionFour.text, !optionFourText.isEmpty else {
               // Displays error alert if empty
              showAlert(message: "Please fill in all avaliable fields.")
               return
           }
           // if it is all text fields are filled create an new question using the question structure
           let newQuestion = Question(question: questionText, correctAnswer: optionOneText, incorrectAnswers: [optionTwoText, optionThreeText, optionFourText])
        
           // add new question to the question array
           questions.append(newQuestion)
           
           clearInputFields() // clear all inputs
       }
    
    // Removes questions thne the review quiz button is pressed
    @IBAction func reviewQuizButtonPressed(_ sender: Any) {
        //checks if the questions array is empty
        guard !questions.isEmpty else {
            return
        }
        
        // clears questions array
        questions = []
    }
    
    // Function to pepare to pass data through the segue to the review view controller
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        if segue.identifier == "goToReview" {
            let VC = segue.destination as! ReviewQuizViewController
            VC.quizTitle = selectedTitle
            VC.questions = questions
            VC.privacy = selectedPrivacy
            VC.userId = userId
        }
    }
    
    // function to create alert
    func showAlert(message: String) {
        // Sets the title for each time the alert is called and action to only be OK
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okAction) // Adds the OK action to the alert controller
        present(alert, animated: true, completion: nil) // Presents the alert
    }
}

