//
//  FlashCard.swift
//  FlashyQuiz
//
//  Created by Jeremy Chye on 23/5/2023.
//

import Foundation

struct Flashcard {
    var question: String
    var answer: String
}

// FlashcardDeck.swift

struct FlashcardDeck {
    var name: String
    var permission: String
    var flashcards: [Flashcard]
}
