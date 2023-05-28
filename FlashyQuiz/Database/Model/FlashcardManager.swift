//
//  FlashcardData.swift
//  FlashyQuiz
//
//  Created by Eren Atilgan on 23/5/2023.
//

import Foundation
import SQLite

struct FlashcardManager {
    
    // Table & View variables
    let flashcardGroupTable = Table("FlashcardGroups")
    let flashcardTable = Table("Flashcards")
    let fullFlashcardGroupView = View("FullFlashcardGroups")
    
    // Common table column variables (used in both Quizzes and Questions table)
    let userIdCol = Expression<Int?>("userId")
    let rowIdCol = Expression<Int64>("ROWID")
    
    // Table column variables for Quizzes table
    let quizIdCol = Expression<Int>("id")
    let quizIdColLiteral = Expression<Int>("flashcardGroupId")
    let titleCol = Expression<String>("title")
    let privacyCol = Expression<String>("privacy")
    
    // Table column variables for Questions table
    let questionIdCol = Expression<Int>("id")
    let questionIdColLiteral = Expression<Int>("flashcardId")
    let questionCol = Expression<String>("question")
    let correctAnswerCol = Expression<String>("correctAnswer")
    let incorrectAnswer1Col = Expression<String>("incorrectAnswer1")
    let incorrectAnswer2Col = Expression<String>("incorrectAnswer2")
    let incorrectAnswer3Col = Expression<String>("incorrectAnswer3")
    
    let databaseURL = DatabaseManager().getDatabasePath()
    

}
