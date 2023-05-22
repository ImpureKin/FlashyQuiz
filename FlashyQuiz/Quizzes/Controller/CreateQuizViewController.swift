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
    
    var selectedTitle: String = ""
    var questions : [Question] = []
    var dataManager = DataStorageManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
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
        guard let questionText = question.text,
              let optionOneText = optionOne.text,
              let optionTwoText = optionTwo.text,
              let optionThreeText = optionThree.text,
              let optionFourText = optionFour.text else {
            return
        }
        let newQuestion = Question(text: questionText, correctAnswer: [optionOneText], incorrectAnswers: [optionTwoText, optionThreeText, optionFourText])
        
        questions.append(newQuestion)
        
        clearInputFields()
    }
    
    @IBAction func reviewQuizButtonPressed(_ sender: Any) {
        guard !questions.isEmpty else {
            return
        }
        
        performSegue(withIdentifier: "goToReview", sender: self)
        
        questions = []
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        if segue.identifier == "goToReview" {
            let VC = segue.destination as! ReviewQuizViewController
            VC.quizTitle = selectedTitle
            VC.questions = questions
        }
    }
    
    
}
