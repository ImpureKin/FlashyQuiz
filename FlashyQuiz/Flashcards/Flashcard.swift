//
//  Quiz.swift
//  FlashyQuiz
//
//  Created by Alyssa Rodriguez on 20/5/2023.
//

import Foundation

struct FlashcardGroup: Equatable {
    var flashcardGroupId: Int?
    var title: String
    var userId : Int
    var privacy: String
    var flashcards: [Flashcard]
    
    init(userId: Int, title: String, privacy: String, flashcards: [Flashcard]) {
        self.userId = userId
        self.title = title
        self.privacy = privacy
        self.flashcards = flashcards
    }
    
    init(flashcardGroupId: Int,userId: Int, title: String, privacy: String, flashcards: [Flashcard]) {
        self.flashcardGroupId = flashcardGroupId
        self.userId = userId
        self.title = title
        self.flashcards = flashcards
        self.privacy = privacy
    }
}

struct Flashcard : Equatable {
    var flashcardId: Int?
    var question: String
    var answer: String
    
    static func == (lhs: Flashcard, rhs: Flashcard) -> Bool {
        return lhs.question == rhs.question &&
            lhs.answer == rhs.answer
    }
    
    init(question: String, answer: String) {
        self.question = question
        self.answer = answer
    }
    
    init(flashcardId: Int, question: String, answer: String) {
        self.flashcardId = flashcardId
        self.question = question
        self.answer = answer
    }
}

