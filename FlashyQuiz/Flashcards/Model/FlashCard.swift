//
//  FlashCard.swift
//  FlashyQuiz
//
//  Created by Jeremy Chye on 23/5/2023.
//

import Foundation

struct Flashcard : Equatable {
    var flashcardId: Int?
    var question: String
    var answer: String
    
    
    
    init(question: String, answer: String) {
        self.question = question
        self.answer = answer
    }
    
    init(flashcardId: Int,question: String, answer: String) {
        self.flashcardId = flashcardId
        self.question = question
        self.answer = answer
    }
}
