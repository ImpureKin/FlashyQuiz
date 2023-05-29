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
        let flashcardManager = FlashcardManager()
        let userId = 1
        
        /** // Pull user details test
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
        **/
        if let quizzes = quizManager.getUserQuizzes(userIdInput: 1) {
            for quiz in quizzes {
                print("Quiz ID: \(quiz.quizId ?? -1)")
                print("Quiz Title: \(quiz.title)")
                print("Quiz Privacy: \(quiz.privacy)")
                print("Quiz UserId: \(userId)")
                for question in quiz.questions {
                    print("Question: \(question.question)")
                    print("Question Answer: \(question.correctAnswer)")
                    print("Question Incorrect Answers: \(question.incorrectAnswers)")
                }
                print("----------------------------------------")
            }
        } else {
            print("Error")
        }
        
        if let flashcardGroups = flashcardManager.getUserFlashcardGroups(userIdInput: 1) {
            for flashcardGroup in flashcardGroups {
                print("Flashcard Group ID: \(flashcardGroup.flashcardGroupId ?? -1)")
                print("Flashcard Group Title: \(flashcardGroup.title)")
                print("Flashcard Group Privacy: \(flashcardGroup.privacy)")
                print("Flashcard Group UserId: \(userId)")
                for flashcard in flashcardGroup.flashcards {
                    print("Flashcard Question: \(flashcard.question)")
                    print("Flashcard Answer: \(flashcard.answer)")
                }
                print("----------------------------------------")
            }
        } else {
            print("Error")
        }
        /**
         // Update quiz test
        let updatedQuiz = Quiz(quizId: 11, userId: 1, title: "Updated Quiz", privacy: "Public", questions: [
            Question(question: "Updated Question 1", correctAnswer: "Option A", incorrectAnswers: ["Option B", "Option C", "Option D"]),
        ])

        let isSuccess = quizManager.updateQuiz(updatedQuiz: updatedQuiz)

        if isSuccess {
            print("Quiz updated successfully")
        } else {
            print("Failed to update quiz")
        }

        // Retrieve the updated quiz
        let retrievedQuiz = quizManager.getQuiz(quizId: 11, userId: 1)

        if let quiz = retrievedQuiz {
            print("Retrieved Quiz:")
            print("Quiz ID: \(quiz.quizId ?? -1)")
            print("Title: \(quiz.title)")
            print("Privacy: \(quiz.privacy)")
            print("Questions:")
            for question in quiz.questions {
                print("Question ID: \(question.questionId ?? -1)")
                print("Question: \(question.question)")
                print("Correct Answer: \(question.correctAnswer)")
                print("Incorrect Answers: \(question.incorrectAnswers)")
            }
        } else {
            print("Failed to retrieve quiz")
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
