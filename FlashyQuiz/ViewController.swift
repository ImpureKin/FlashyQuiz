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
        
        /**  // Pull user details test
        if let userDetails = userManager.getUserDetails(userId: 1) {
            print("User ID: \(userDetails.id)")
            print("Username: \(userDetails.username)")
            print("Email: \(userDetails.email)")
        } else {
            print("User not found.")
        }
//        // Get all user Quizzes test
//        if let quizzes = quizManager.getUserQuizzes(userIdInput: 1) {
//            for quiz in quizzes {
//                print("Quiz ID: \(quiz.quizId ?? -1)")
//                print("Quiz Title: \(quiz.title)")
//                print("Quiz Privacy: \(quiz.privacy)")
//                print("Quiz UserId: \(quiz.userId)")
//                for question in quiz.questions {
//                    print("Question: \(question.question)")
//                    print("Question Answer: \(question.correctAnswer)")
//                    print("Question Incorrect Answers: \(question.incorrectAnswers)")
//                }
//            }
//        } else {
//            print("Error")
//        }
        
        // Add quiz test
        let question1: Question = Question(question: "How are you?", correctAnswer: "No idea", incorrectAnswers: ["Good", "Bad", "Fine"])
        let question2: Question = Question(question: "What's the weather like today?", correctAnswer: "Sunny", incorrectAnswers: ["Rainy", "Cloudy", "Freezing"])
        let questions: [Question] = [question1, question2]
        let quizToAdd = Quiz(userId: 1, title: "Code Insert Test Quiz", privacy: "Public", questions: questions)
        if quizManager.addQuiz(quiz: quizToAdd) {
            print("SUCCESSFULLY ADDED QUIZ.")
        } else {
            print("ERROR: QUIZ NOT ADDED.")
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
        
        // Update quiz test
        var testQuiz = quizManager.getQuiz(quizId: 7, userId: 1)
        testQuiz?.questions.remove(at: 1)
        if quizManager.updateQuiz(updatedQuiz: testQuiz!) {
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
        }
        
        // Delete quiz test
        if quizManager.deleteQuiz(quiz: testQuiz!) {
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
        }
        
        **/
        
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
}
