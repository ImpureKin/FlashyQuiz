//
//  CreateQuizViewController.swift
//  FlashyQuiz
//
//  Created by Alyssa Rodriguez on 20/5/2023.
//

import UIKit
import Foundation

class CreateQuizViewController: UIViewController {

    @IBOutlet weak var quizTitle: UILabel!
    @IBOutlet weak var question: UITextField!
    @IBOutlet weak var optionOne: UITextField!
    @IBOutlet weak var optionTwo: UITextField!
    @IBOutlet weak var optionThree: UITextField!
    @IBOutlet weak var optionFour: UITextField!
    
    var userId: Int = 0
    var selectedTitle: String = ""
    var selectedPrivacy: String = ""
    var questions : [Question] = []
    var dataManager = DataStorageManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        print("userId: \(userId)")
        quizTitle.text = selectedTitle
    }
    
    func clearInputFields() {
        question.text = ""
        optionOne.text = ""
        optionTwo.text = ""
        optionThree.text = ""
        optionFour.text = ""
    }
    
    
    @IBAction func addQuestionButtonPressed(_ sender: Any) {
        guard let questionText = question.text, !questionText.isEmpty,
                 let optionOneText = optionOne.text, !optionOneText.isEmpty,
                 let optionTwoText = optionTwo.text, !optionTwoText.isEmpty,
                 let optionThreeText = optionThree.text, !optionThreeText.isEmpty,
                 let optionFourText = optionFour.text, !optionFourText.isEmpty else {
               // Display error alert
               UIAlertController.showAlert(title: "Error", message: "Please fill in all the fields.", in: self)
               return
           }
           
           let newQuestion = Question(question: questionText, correctAnswer: optionOneText, incorrectAnswers: [optionTwoText, optionThreeText, optionFourText])
           
           questions.append(newQuestion)
           
           clearInputFields()
       }
    
    @IBAction func reviewQuizButtonPressed(_ sender: Any) {
        guard !questions.isEmpty else {
            return
        }
        
        questions = []
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        if segue.identifier == "goToReview" {
            let VC = segue.destination as! ReviewQuizViewController
            VC.quizTitle = selectedTitle
            VC.questions = questions
            VC.privacy = selectedPrivacy
            VC.userId = userId
        }
    }
    
    
}

extension UIAlertController {
    static func showAlert(title: String, message: String, in viewController: UIViewController) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        viewController.present(alertController, animated: true, completion: nil)
    }
}
