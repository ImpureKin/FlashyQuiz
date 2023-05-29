//
//  FlashcardGroup.swift
//  FlashyQuiz
//
//  Created by Jeremy Chye on 29/5/2023.
//

import Foundation

struct FlashcardGroup: Equatable {
    var flashcardId: Int = UUID().hashValue //make ? optional when merging with database
    var title: String
    var privacy: String
    var flashcards: [Flashcard]
    
    init(userId: Int, title: String, privacy: String, flashcards: [Flashcard]) {
        self.title = title
        self.privacy = privacy
        self.flashcards = flashcards
    }
    
    init(flashcardId: Int, title: String, privacy: String, flashcards: [Flashcard]) {
        self.flashcardId = flashcardId
        self.title = title
        self.flashcards = flashcards
        self.privacy = privacy
    }
}
