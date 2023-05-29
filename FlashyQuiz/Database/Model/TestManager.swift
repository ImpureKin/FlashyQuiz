//
//  Tester.swift
//  FlashyQuiz
//
//  Created by Eren Atilgan on 29/5/2023.
//

import Foundation
import SQLite

struct TestManager {
    
    let userManager = UserManager()
    let quizManager = QuizManager()
    let flashcardManager = FlashcardManager()
    let userId = 1
    
    func getUserQuizzes() {
        print("-------------------Test: Get User Quizzes-------------------")
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
    }
    
    func getUserFlashcards() {
        print("-------------------Test: Get User Flashcards-------------------")
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
    }
    
    
    
    
    
    
    func runTests() {
        getUserQuizzes()
        getUserFlashcards()
    }
    
}
