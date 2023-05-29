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
    
    func addQuiz() {
        print("\n-------------------Test: Add Quiz-------------------")
        
        let question1 = Question(question: "How many apples in a pear?", correctAnswer: "2", incorrectAnswers: ["3", "4", "5"])
        let question2 = Question(question: "How many watermelons in a mango?", correctAnswer: "7", incorrectAnswers: ["10", "6", "8"])
        let questions = [question1, question2]
        let quiz = Quiz(title: "Fruit Quiz", privacy: "Public", questions: questions)
        let _ = quizManager.addQuiz(quiz: quiz, userId: 1)
    }
    
    func addFlashcardGroup() {
        print("\n-------------------Test: Add Flashcard Group-------------------")
        
        let flashcard1 = Flashcard(question: "Colour of a green apple", answer: "Green")
        let flashcard2 = Flashcard(question: "Colour of a red apple", answer: "Red")
        let flashcards = [flashcard1, flashcard2]
        let flashcardGroup = FlashcardGroup(title: "Colour of fruit", privacy: "Public", flashcards: flashcards)
        let _ = flashcardManager.addFlashcardGroup(flashcardGroup: flashcardGroup, userId: 1)
    }
    
    func getUserQuizzes() {
        print("\n-------------------Test: Get User Quizzes-------------------")
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
                print("----------------------------------------------------------------")
            }
        } else {
            print("Error")
        }
    }
    
    func getUserFlashcards() {
        print("\n-------------------Test: Get User Flashcards-------------------")
        if let flashcardGroups = flashcardManager.getUserFlashcardGroups(userIdInput: 1) {
            for flashcardGroup in flashcardGroups {
                print("Flashcard Group ID: \(flashcardGroup.flashcardGroupId ?? -1)")
                print("Flashcard Group Title: \(flashcardGroup.title)")
                print("Flashcard Group Privacy: \(flashcardGroup.privacy)")
                print("Flashcard Group UserId: \(userId)")
                for flashcard in flashcardGroup.flashcards {
                    print("Flashcard ID: \(flashcard.flashcardId!)")
                    print("Flashcard Question: \(flashcard.question)")
                    print("Flashcard Answer: \(flashcard.answer)")
                }
                print("----------------------------------------------------------------")
            }
        } else {
            print("Error")
        }
    }
    
    func getPublicQuizzes() {
        print("\n-------------------Test: Get Public Quizzes-------------------")
        if let quizzes = quizManager.getPublicQuizzes() {
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
                print("----------------------------------------------------------------")
            }
        } else {
            print("Error")
        }
    }
    
    func getPublicFlashcards() {
        print("\n-------------------Test: Get Public Flashcards-------------------")
        if let flashcardGroups = flashcardManager.getPublicFlashcardGroups() {
            for flashcardGroup in flashcardGroups {
                print("Flashcard Group ID: \(flashcardGroup.flashcardGroupId ?? -1)")
                print("Flashcard Group Title: \(flashcardGroup.title)")
                print("Flashcard Group Privacy: \(flashcardGroup.privacy)")
                print("Flashcard Group UserId: \(userId)")
                for flashcard in flashcardGroup.flashcards {
                    print("Flashcard Question: \(flashcard.question)")
                    print("Flashcard Answer: \(flashcard.answer)")
                }
                print("----------------------------------------------------------------")
            }
        } else {
            print("Error")
        }
    }
    
    func updateQuiz(id: Int) {
        print("\n-------------------Test: Update Quiz-------------------")
        let question = Question(question: "How many apples in a pear?", correctAnswer: "200", incorrectAnswers: ["300", "400", "500"])
        let updatedQuiz = Quiz(quizId: id, title: "Fruit Quiz - Modified", privacy: "Private", questions: [question])
        let _ = quizManager.updateQuiz(updatedQuiz: updatedQuiz, userId: 1)
    }
    
    func updateFlashcardGroup(id: Int) {
        print("\n-------------------Test: Update Flashcard-------------------")
        let flashcard = Flashcard(question: "Colour of a green apple - Modified", answer: "Dark Green")
        let updatedFlashcardGroup = FlashcardGroup(flashcardGroupId: id, title: "Colour of fruit - Modified", privacy: "Private", flashcards: [flashcard])
        let _ = flashcardManager.updateFlashcardGroup(updatedFlashcardGroup: updatedFlashcardGroup, userId: 1)
    }
    
    func deleteQuiz(id: Int) {
        print("\n-------------------Test: Delete Quiz-------------------")
        if let quiz = quizManager.getQuiz(quizId: id) {
            let _ = quizManager.deleteQuiz(quiz: quiz)
        } else {
            print("Failed to get quiz.")
        }
    }
    
    func deleteFlashcardGroup(id: Int) {
        print("\n-------------------Test: Delete Flashcard Group-------------------")
        if let flashcardGroup = flashcardManager.getFlashcardGroup(flashcardGroupId: id) {
            let _ = flashcardManager.deleteFlashcardGroup(flashcardGroup: flashcardGroup)
        } else {
            print("Failed to get flashcard group.")
        }
    }
    
    
    func runTests() {
        let id = 17 // need to update
        
        // C - Create
        addQuiz()
        addFlashcardGroup()
        
        // R - Read
        getUserQuizzes()
        getUserFlashcards()
        getPublicQuizzes()
        getPublicFlashcards()
        
        // U - Update
        updateQuiz(id: id)
        updateFlashcardGroup(id: id)

        // Read again
        getUserQuizzes()
        getUserFlashcards()
        getPublicQuizzes()
        getPublicFlashcards()

        // D - Delete
        deleteQuiz(id: id)
        deleteFlashcardGroup(id: id)

        // Read again
        getUserQuizzes()
        getUserFlashcards()
        getPublicQuizzes()
        getPublicFlashcards()
    }
}
