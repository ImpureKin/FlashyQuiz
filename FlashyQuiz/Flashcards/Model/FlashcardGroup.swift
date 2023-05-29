//
//  FlashcardGroup.swift
//  FlashyQuiz
//
//  Created by Jeremy Chye on 29/5/2023.
//

import Foundation

struct FlashcardGroup: Equatable {
    var flashcardGroupId: Int?
    var title: String
    var privacy: String
    var flashcards: [Flashcard]
    
    init(title: String, privacy: String, flashcards: [Flashcard]) {
        self.title = title
        self.privacy = privacy
        self.flashcards = flashcards
    }
    
    init(flashcardGroupId: Int, title: String, privacy: String, flashcards: [Flashcard]) {
        self.flashcardGroupId = flashcardGroupId
        self.title = title
        self.flashcards = flashcards
        self.privacy = privacy
    }
}
