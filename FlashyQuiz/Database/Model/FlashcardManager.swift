//
//  FlashcardData.swift
//  FlashyFlashcardGroup
//
//  Created by Eren Atilgan on 23/5/2023.
//

import Foundation
import SQLite

struct FlashcardManager {
    
    let databaseURL = DatabaseManager().getDatabasePath()
    
    // Table & View variables
    let flashcardGroupTable = Table("FlashcardGroups")
    let flashcardTable = Table("Flashcards")
    let fullFlashcardGroupView = View("FullFlashcardGroups")
    
    // Common table column variables (used in both FlashcardGroups and Flashcards table)
    let userIdCol = Expression<Int>("userId")
    let rowIdCol = Expression<Int64>("ROWID")
    
    // Table column variables for FlashcardGroups table
    let flashcardGroupIdCol = Expression<Int>("id")
    let flashcardGroupIdColLiteral = Expression<Int>("flashcardGroupId")
    let titleCol = Expression<String>("title")
    let privacyCol = Expression<String>("privacy")
    
    // Table column variables for Flashcards table
    let flashcardIdCol = Expression<Int>("id")
    let flashcardIdColLiteral = Expression<Int>("flashcardId")
    let questionCol = Expression<String>("question")
    let answerCol = Expression<String>("answer")
    
    // Add a flashcardGroup into the database
    func addFlashcardGroup(flashcardGroup: FlashcardGroup, userId: Int) -> Bool {
        do {
            // DB connection
            let db = try Connection(databaseURL)
            
            // Insert flashcardGroup into DB and fetch created rowId
            let insertedFlashcardGroupRowId = try db.run(flashcardGroupTable.insert(titleCol <- flashcardGroup.title, userIdCol <- userId, privacyCol <- flashcardGroup.privacy))
            
            // Get the flashcardGroupId of the recently inserted flashcardGroup using the generated rowId
            let flashcardGroupId = getFlashcardGroupIdByRowid(rowId: insertedFlashcardGroupRowId)
            if flashcardGroupId != -1 { // Check if getting flashcardGroupId was successful
                // Retrieve and loop through flashcards within provided flashcardGroup
                let flashcards: [Flashcard] = flashcardGroup.flashcards
                for flashcard in flashcards {
                    // Add flashcards into DB
                    try db.run(flashcardTable.insert(userIdCol <- userId,
                                                     flashcardGroupIdColLiteral <- flashcardGroupId,
                                                    questionCol <- flashcard.question,
                                                    answerCol <- flashcard.answer))
                }
            } else {
                print("Error retrieving flashcardGroupId, did not add flashcardGroup to Database.")
                return false
            }
        } catch {
            print("Error inserting flashcardGroup: \(error)")
            return false
        }
        print("Successfully inserted flashcardGroup.")
        return true
    }
    
    // Get all public Flashcard Groups (i.e. work of others)
    func getPublicFlashcardGroups() -> [FlashcardGroup]? {
        return getFilteredFlashcardGroups(columnFilter: privacyCol, filterValue: "Public")
    }
    
    // Get Flashcard Grups owned by a user
    func getUserFlashcardGroups(userIdInput: Int) -> [FlashcardGroup]? {
        return getFilteredFlashcardGroups(columnFilter: userIdCol, filterValue: userIdInput)
    }
    
    // Get a FlashcardGroup via flashcardGroupId
    func getFlashcardGroup(flashcardGroupId: Int) -> FlashcardGroup? {
        do {
            // DB connection
            let db = try Connection(databaseURL)
            
            // Query execution and results
            let query = fullFlashcardGroupView.filter(flashcardGroupIdCol == flashcardGroupId) // SELECT * FROM FullFlashcardGroups WHERE id = flashcardGroupId
            let rowIterator = try db.prepareRowIterator(query) // Execute query via row iterator to handle errors
            let rows = try Array(rowIterator) // Create array using result
            
            // Tracking / other
            let totalRowCount = rows.count // Get total row count for tracking
            var currentRow = 1
            var flashcards: [Flashcard] = []

            // Loop through results
            for row in rows {
                // Get values from row/data and store into variables
                let flashcardGroupId = row[flashcardGroupIdCol]
                let title = row[titleCol]
                let privacy = row[privacyCol]
                let flashcardId = row[flashcardIdColLiteral]
                let question = row[questionCol]
                let answer = row[answerCol]
                let flashcard = Flashcard(flashcardId: flashcardId, question: question, answer: answer) // Create flashcard

                if currentRow == totalRowCount { // If this is the last row, append flashcardGroup before exiting loop
                    let flashcardGroup = FlashcardGroup(flashcardGroupId: flashcardGroupId, title: title, privacy: privacy, flashcards: flashcards) // Create flashcardGroup (with flashcards)
                    return flashcardGroup // Append flashcardGroup
                }
                currentRow += 1 // Track current row
            }
        } catch {
            print("Error retrieving flashcardGroups: \(error)")
        }
        print("Failed to retrieve flashcardGroup")
        return nil
    }
    
    // Get quizzes based on filter - used to recycle code
    func getFilteredFlashcardGroups<T: Value>(columnFilter: Expression<T>, filterValue: T) -> [FlashcardGroup] where T.Datatype: Equatable {
        var flashcardGroups: [FlashcardGroup] = []
        var flashcards: [Flashcard] = []

        do {
            // DB connection
            let db = try Connection(databaseURL)
            
            // Query execution and results
            let query = fullFlashcardGroupView.filter(columnFilter == filterValue)
                                              .order(flashcardGroupIdCol) // SELECT * FROM FullFlashcardGroups WHERE privacy = "Public" ORDER BY id
            let rowIterator = try db.prepareRowIterator(query) // Execute query via row iterator to handle errors
            let rows = try Array(rowIterator) // Create array using result

            // Loop through results
            for (index, row) in rows.enumerated() {
                
                // Get values from row/data and store into variables
                let flashcardGroupId = row[flashcardGroupIdCol]
                let title = row[titleCol]
                let privacy = row[privacyCol]
                let flashcardId = row[flashcardIdColLiteral]
                let question = row[questionCol]
                let answer = row[answerCol]
                let flashcard = Flashcard(flashcardId: flashcardId, question: question, answer: answer) // Create flashcard
                
                if index < rows.count - 1 {
                    let nextRow = rows[index + 1]
                    let nextFlashcardGroupId = nextRow[flashcardGroupIdCol]
                    
                    if flashcardGroupId == nextFlashcardGroupId {
                        flashcards.append(flashcard) // Append flashcard
                    } else { // Current row is part of a different flashcardGroup than before, append flashcardGroup, reset flashcards array
                        flashcards.append(flashcard)
                        let flashcardGroup = FlashcardGroup(flashcardGroupId: flashcardGroupId, title: title, privacy: privacy, flashcards: flashcards) // Create flashcardGroup (with flashcards)
                        flashcardGroups.append(flashcardGroup) // Append flashcardGroup
                        flashcards = [] // Reset flashcards array
                    }
                } else {
                    flashcards.append(flashcard)
                    let flashcardGroup = FlashcardGroup(flashcardGroupId: flashcardGroupId, title: title, privacy: privacy, flashcards: flashcards) // Create flashcardGroup (with flashcards)
                    flashcardGroups.append(flashcardGroup)
                }
            }
        } catch {
            print("Error retrieving flashcardGroupzes: \(error)")
        }
        print("Successfully retrieved flashcardGroupzes")
        return flashcardGroups
    }
    
    // Update FlashcardGroup
    func updateFlashcardGroup(updatedFlashcardGroup: FlashcardGroup, userId: Int) -> Bool {
        do {
            // DB connection
            let db = try Connection(databaseURL)
            
            guard let flashcardGroupId = updatedFlashcardGroup.flashcardGroupId else {
                print("Invalid flashcardGroupId")
                return false
            }
            
            // Update title and privacy
            let updatedRow = flashcardGroupTable.filter(flashcardGroupIdCol == flashcardGroupId)
                .update(titleCol <- updatedFlashcardGroup.title,
                        privacyCol <- updatedFlashcardGroup.privacy)
            
            // Delete existing questions for the quiz
            try deleteFlashcards(forFlashcardGroupId: flashcardGroupId, inDatabase: db)
            
            // Insert or update questions
            try insertOrUpdateFlashcards(updatedFlashcardGroup.flashcards, flashcardGroupId: flashcardGroupId, userId: userId, inDatabase: db)
            
            // Commit the updates
            try db.run(updatedRow)
            
            return true
        } catch {
            print("Error updating quiz: \(error)")
            return false
        }
        
        func deleteFlashcards(forFlashcardGroupId flashcardGroupId: Int, inDatabase db: Connection) throws {
            let deleteQuery = flashcardTable.filter(flashcardGroupIdColLiteral == flashcardGroupId)
            try db.run(deleteQuery.delete())
        }

        func insertOrUpdateFlashcards(_ flashcards: [Flashcard], flashcardGroupId: Int, userId: Int, inDatabase db: Connection) throws {
            for updatedFlashcard in flashcards {
                let insertQuery = flashcardTable.insert(flashcardGroupIdColLiteral <- flashcardGroupId,
                                                       userIdCol <- userId,
                                                       questionCol <- updatedFlashcard.question,
                                                       answerCol <- updatedFlashcard.answer)
                
                // Update or insert the question
                let flashcardId = updatedFlashcard.flashcardId ?? -1
                if try db.run(insertQuery) > 0 {
                    let lastInsertedRowID = db.lastInsertRowid
                    if flashcardId != -1 {
                        // Update the questionId with the newly inserted row ID
                        let updateQuery = flashcardTable.filter(rowIdCol == lastInsertedRowID)
                            .update(flashcardIdCol <- flashcardId)
                        try db.run(updateQuery)
                    }
                }
            }
        }
    }
    
    // Used as a loop to delete flashcards
    func updateFlashcards(flashcards: [Flashcard]) -> Bool {
        for question in flashcards {
            if updateFlashcard(updatedFlashcard: question) {
                print("Updated flashcards.")
            } else {
                print("Unable to update flashcards.")
                return false
            }
        }
        return true
    }
    
    // Update question details
    func updateFlashcard(updatedFlashcard: Flashcard) -> Bool {
        do {
            // DB connection
            let db = try Connection(databaseURL)
            
            let flashcardId = updatedFlashcard.flashcardId!
            let flashcardToUpdate = flashcardTable.filter(flashcardIdCol == flashcardId)
            
            try db.run(flashcardToUpdate.update(questionCol <- updatedFlashcard.question,
                                               answerCol <- updatedFlashcard.answer))
            return true
        } catch {
            print("Error updating flashcard: \(error)")
            return false
        }
    }
    
    // Check for flashcards that can be deleted and send for deletion
//    func deleteRemovedFlashcards(oldFlashcardGroup: FlashcardGroup, updatedFlashcardGroup: FlashcardGroup) -> Bool {
//        let deletedFlashcards = oldFlashcardGroup.flashcards.filter { !updatedFlashcardGroup.flashcards.contains($0) }
//
//        for deletableFlashcard in deletedFlashcards {
//            if deleteFlashcard(flashcard: deletableFlashcard) {
//                print("Deleted flashcard.")
//            } else {
//                print("Unable to delete flashcard.")
//                return false
//            }
//        }
//        return true
//    }
    
    // Delete flashcardGroup
    func deleteFlashcardGroup(flashcardGroup: FlashcardGroup) -> Bool {
        do {
            // DB connection
            let db = try Connection(databaseURL)
            
            let flashcardGroupId = flashcardGroup.flashcardGroupId!
            let flashcardGroupToDelete = flashcardGroupTable.filter(flashcardGroupIdCol == flashcardGroupId) // Get flashcardGroup with matching flashcardGroupId
            let flashcardsToDelete = flashcardTable.filter(flashcardGroupIdColLiteral == flashcardGroupId) // Get flashcards with matching flashcardGroupId
            
            let deletedFlashcardsCount = try db.run(flashcardsToDelete.delete()) // Delete all flashcards with matching flashcardGroupId first due to FOREIGN KEY restraint
            
            let deletedFlashcardGroupCount = try db.run(flashcardGroupToDelete.delete()) // Proceed to deleting flashcardGroup
            
            print("Successfully deleted flashcardGroup.")
            return deletedFlashcardsCount > 0 && deletedFlashcardGroupCount > 0
        } catch {
            print("Error deleting flashcardGroup: \(error)")
            return false
        }
    }
    
    // Delete question
    func deleteFlashcard(flashcard: Flashcard) -> Bool {
        do {
            // DB connection
            let db = try Connection(databaseURL)
            
            let flashcardId = flashcard.flashcardId!
            let flashcardsToDelete = flashcardTable.filter(flashcardIdCol == flashcardId) // SELECT * FROM flashcards WHERE id = flashcardId
            
            return try db.run(flashcardsToDelete.delete()) > 0
        } catch {
            print("Error deleting flashcard: \(error)")
            return false
        }
    }
    
    // Check for existing flashcardGroup title
    func isExitingTitle(title: String, userId: Int) -> Bool {
        do {
            // DB connection
            let db = try Connection(databaseURL)
            
            let query = flashcardGroupTable.filter(userIdCol == userId) // SELECT * FROM flashcardGroupzes WHERE userId = userId
            let rowIterator = try db.prepareRowIterator(query) // Execute query via row iterator to handle errors
            let rows = try Array(rowIterator) // Create array using result
            
            for row in rows { // Loop through results
                if row[titleCol] == title { // Check if the current row's flashcardGroup title is equal to the provided title and return true if it is
                    return true
                }
            }
            return false
        } catch {
            print("Error checking for existing flashcardGroup title: \(error)")
            return true
        }
    }
    
    // Get a flashcardGroupId by table ROWID
    func getFlashcardGroupIdByRowid(rowId: Int64) -> Int {
        do {
            // DB connection
            let db = try Connection(databaseURL)
            
            let query = flashcardGroupTable.filter(rowIdCol == rowId) // SELECT * FROM flashcardGroupzes WHERE ROWID = rowId
            guard let row = try db.pluck(query) else {
                return -1
            }
            let flashcardGroupIdValue = row[flashcardGroupIdCol]
            return flashcardGroupIdValue
        } catch {
            print("Error retrieving flashcardGroupId: \(error)")
            return -1
        }
    }
}
