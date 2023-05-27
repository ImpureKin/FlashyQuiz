//
//  ViewController.swift
//  FlashyQuiz
//
//  Created by Eren Atilgan on 2/5/2023.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        let userManager = UserManager()
        let quizManager = QuizManager()
        
        if let userDetails = userManager.getUserDetails(userId: 1) {
            print("User ID: \(userDetails.id)")
            print("Username: \(userDetails.username)")
            print("Email: \(userDetails.email)")
        } else {
            print("User not found.")
        }
        
        if let quizzes = quizManager.getUserQuizzes(userIdInput: 1) {
            for quiz in quizzes {
                print("Quiz ID: \(quiz.quizId ?? -1)")
                print("Quiz Title: \(quiz.title)")
                print("Quiz Privacy: \(quiz.privacy)")
                print("Quiz UserId: \(quiz.userId)")
                for question in quiz.questions {
                    print("Question: \(question.question)")
                    print("Question Answer: \(question.correctAnswer)")
                    print("Question Incorrect Answers: \(question.incorrectAnswers)")
                }
            }
        } else {
            print("Error")
        }

        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
}
