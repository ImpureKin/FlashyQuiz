import Foundation
import SQLite

struct QuizManager {

    let databaseURL = DatabaseManager().getDatabasePath()
    
    // Table & View variables
    let quizTable = Table("Quizzes")
    let questionTable = Table("Questions")
    let fullQuizView = View("FullQuiz")
    
    // Common table column variables (used in both Quizzes and Questions table)
    let userIdCol = Expression<Int>("userId")
    let rowIdCol = Expression<Int64>("ROWID")
    
    // Table column variables for Quizzes table
    let quizIdCol = Expression<Int>("id")
    let quizIdColLiteral = Expression<Int>("quizId")
    let titleCol = Expression<String>("title")
    let privacyCol = Expression<String>("privacy")
    
    // Table column variables for Questions table
    let questionIdCol = Expression<Int>("id")
    let questionIdColLiteral = Expression<Int>("questionId")
    let questionCol = Expression<String>("question")
    let correctAnswerCol = Expression<String>("correctAnswer")
    let incorrectAnswer1Col = Expression<String>("incorrectAnswer1")
    let incorrectAnswer2Col = Expression<String>("incorrectAnswer2")
    let incorrectAnswer3Col = Expression<String>("incorrectAnswer3")

    // Add a quiz into the database
    func addQuiz(quiz: Quiz, userId: Int) -> Bool {
        do {
            // DB connection
            let db = try Connection(databaseURL)
            
            // Insert quiz into DB and fetch created rowId
            let insertedQuizRowId = try db.run(quizTable.insert(titleCol <- quiz.title, userIdCol <- userId, privacyCol <- quiz.privacy))
            
            // Get the quizId of the recently inserted quiz using the generated rowId
            let quizId = getQuizIdByRowid(rowId: insertedQuizRowId)
            if quizId != -1 { // Check if getting quizId was successful
                // Retrieve and loop through questions within provided quiz
                let questions: [Question] = quiz.questions
                for question in questions {
                    // Add questions into DB
                    try db.run(questionTable.insert(userIdCol <- userId,
                                                    quizIdColLiteral <- quizId,
                                                    questionCol <- question.question,
                                                    correctAnswerCol <- question.correctAnswer,
                                                    incorrectAnswer1Col <- question.incorrectAnswers[0],
                                                    incorrectAnswer2Col <- question.incorrectAnswers[1],
                                                    incorrectAnswer3Col <- question.incorrectAnswers[2]))
                }
            } else {
                print("Error retrieving quizId, did not add quiz to Database.")
                return false
            }
        } catch {
            print("Error inserting quiz: \(error)")
            return false
        }
        print("Successfully inserted quiz.")
        return true
    }
    
    // Get all public Quizzes (i.e. work of others)
    func getPublicQuizzes() -> [Quiz]? {
        return getFilteredQuizzes(columnFilter: privacyCol, filterValue: "Public")
    }
    
    // Get all Quizzes owned by a user via their userId
    func getUserQuizzes(userIdInput: Int) -> [Quiz]? {
        return getFilteredQuizzes(columnFilter: userIdCol, filterValue: userIdInput)
    }
    
    // Get a quiz via quizId & userId
    func getQuiz(quizId: Int) -> Quiz? {
        do {
            // DB connection
            let db = try Connection(databaseURL)
            
            // Query execution and results
            let query = fullQuizView.filter(quizIdCol == quizId) // SELECT * FROM FullQuiz WHERE id = quizId
            let rowIterator = try db.prepareRowIterator(query) // Execute query via row iterator to handle errors
            let rows = try Array(rowIterator) // Create array using result
            
            // Tracking / other
            let totalRowCount = rows.count // Get total row count for tracking
            var currentRow = 1
            var questions: [Question] = []

            // Loop through results
            for row in rows {
                // Get values from row/data and store into variables
                let quizId = row[quizIdCol]
                let title = row[titleCol]
                let privacy = row[privacyCol]
                let questionId = row[questionIdColLiteral]
                let questionText = row[questionCol]
                let correctAnswer = row[correctAnswerCol]
                let incorrectAnswers = [row[incorrectAnswer1Col], row[incorrectAnswer2Col], row[incorrectAnswer3Col]].compactMap { $0 }
                let question = Question(questionId: questionId, question: questionText, correctAnswer: correctAnswer, incorrectAnswers: incorrectAnswers) // Create question
                questions.append(question)

                if currentRow == totalRowCount { // If this is the last row, append quiz before exiting loop
                    let quiz = Quiz(quizId: quizId, title: title, privacy: privacy, questions: questions) // Create quiz (with questions)
                    return quiz // Append quiz
                }
                currentRow += 1 // Track current row
            }
        } catch {
            print("Error retrieving quiz: \(error)")
        }
        print("Did not retrieve quiz.")
        return nil
    }
    
    // Get a quizId by table ROWID
    func getQuizIdByRowid(rowId: Int64) -> Int {
        do {
            // DB connection
            let db = try Connection(databaseURL)
            
            let query = quizTable.filter(rowIdCol == rowId) // SELECT * FROM quizzes WHERE ROWID = rowId
            guard let row = try db.pluck(query) else {
                return -1
            }
            let quizIdValue = row[quizIdCol]
            return quizIdValue
        } catch {
            print("Error retrieving quizId: \(error)")
            return -1
        }
    }
    
    // Get quizzes based on filter - used to recycle code
    func getFilteredQuizzes<T: Value>(columnFilter: Expression<T>, filterValue: T) -> [Quiz] where T.Datatype: Equatable {
        var quizzes: [Quiz] = []
        var questions: [Question] = []

        do {
            // DB connection
            let db = try Connection(databaseURL)
            // Query execution and results
            let query = fullQuizView.filter(columnFilter == filterValue) // SELECT * FROM FullQuiz WHERE userId = userIdInput ORDER BY id
                                    .order(quizIdCol)
            let rowIterator = try db.prepareRowIterator(query) // Execute query via row iterator to handle errors
            let rows = try Array(rowIterator) // Create array using result

            // Loop through results
            for (index, row) in rows.enumerated() {
                
                // Get values from row/data and store into variables
                let quizId = row[quizIdCol]
                let title = row[titleCol]
                let privacy = row[privacyCol]
                let questionId = row[questionIdColLiteral]
                let questionText = row[questionCol]
                let correctAnswer = row[correctAnswerCol]
                let incorrectAnswers = [row[incorrectAnswer1Col], row[incorrectAnswer2Col], row[incorrectAnswer3Col]].compactMap { $0 }
                let question = Question(questionId: questionId, question: questionText, correctAnswer: correctAnswer, incorrectAnswers: incorrectAnswers) // Create question

                if index < rows.count - 1 {
                    let nextRow = rows[index + 1]
                    let nextQuizId = nextRow[quizIdCol]
                    
                    if quizId == nextQuizId { // Is the first iteration/row
                        questions.append(question) // Append question
                    } else { // Current row is part of a different quiz than before, append quiz, reset questions array
                        questions.append(question) // Append question
                        let quiz = Quiz(quizId: quizId, title: title, privacy: privacy, questions: questions) // Create quiz (with questions)
                        // print(quiz)
                        quizzes.append(quiz) // Append quiz
                        questions = [] // Reset questions array
                    }
                } else {
                    questions.append(question) // Append question
                    let quiz = Quiz(quizId: quizId, title: title, privacy: privacy, questions: questions) // Create quiz (with questions)
                    quizzes.append(quiz) // Append quiz
                }
            }
        } catch {
            print("Error retrieving quizzes: \(error)")
        }
        print("Successfully retrieved quizzes")
        return quizzes
    }
    
    // Update Quiz
    func updateQuiz(updatedQuiz: Quiz, userId: Int) -> Bool {
        do {
            // DB connection
            let db = try Connection(databaseURL)
            
            guard let quizId = updatedQuiz.quizId else {
                print("Invalid quiz ID")
                return false
            }
            
            // Update title and privacy
            let updatedRow = quizTable.filter(quizIdCol == quizId)
                .update(titleCol <- updatedQuiz.title,
                        privacyCol <- updatedQuiz.privacy)
            
            // Delete existing questions for the quiz
            try deleteQuestions(forQuizId: quizId, inDatabase: db)
            
            // Insert or update questions
            try insertOrUpdateQuestions(updatedQuiz.questions, quizId: quizId, userId: userId, inDatabase: db)
            
            // Commit the updates
            try db.run(updatedRow)
            
            return true
        } catch {
            print("Error updating quiz: \(error)")
            return false
        }
        
        func deleteQuestions(forQuizId quizId: Int, inDatabase db: Connection) throws {
            let deleteQuery = questionTable.filter(quizIdColLiteral == quizId)
            try db.run(deleteQuery.delete())
        }

        func insertOrUpdateQuestions(_ questions: [Question], quizId: Int, userId: Int, inDatabase db: Connection) throws {
            for updatedQuestion in questions {
                let insertQuery = questionTable.insert(quizIdColLiteral <- quizId,
                                                       userIdCol <- userId,
                                                       questionCol <- updatedQuestion.question,
                                                       correctAnswerCol <- updatedQuestion.correctAnswer,
                                                       incorrectAnswer1Col <- updatedQuestion.incorrectAnswers[0],
                                                       incorrectAnswer2Col <- updatedQuestion.incorrectAnswers[1],
                                                       incorrectAnswer3Col <- updatedQuestion.incorrectAnswers[2])
                
                // Update or insert the question
                let questionId = updatedQuestion.questionId ?? -1
                if try db.run(insertQuery) > 0 {
                    let lastInsertedRowID = db.lastInsertRowid
                    if questionId != -1 {
                        // Update the questionId with the newly inserted row ID
                        let updateQuery = questionTable.filter(rowIdCol == lastInsertedRowID)
                            .update(questionIdColLiteral <- questionId)
                        try db.run(updateQuery)
                    }
                }
            }
        }
    }
    
    // Used as a loop to delete questions
    func updateQuestions(questions: [Question]) -> Bool {
        for question in questions {
            if updateQuestion(updatedQuestion: question) {
                print("Updated question.")
            } else {
                print("Unable to update question.")
                return false
            }
        }
        return true
    }
    
    // Update question details
    func updateQuestion(updatedQuestion: Question) -> Bool {
        do {
            // DB connection
            let db = try Connection(databaseURL)
            
            let questionId = updatedQuestion.questionId!
            let questionToUpdate = questionTable.filter(questionIdCol == questionId)
            
            try db.run(questionToUpdate.update(questionCol <- updatedQuestion.question,
                                               correctAnswerCol <- updatedQuestion.correctAnswer,
                                               incorrectAnswer1Col <- updatedQuestion.incorrectAnswers[0],
                                               incorrectAnswer2Col <- updatedQuestion.incorrectAnswers[1],
                                               incorrectAnswer3Col <- updatedQuestion.incorrectAnswers[2]))
            return true
        } catch {
            print("Error updating question: \(error)")
            return false
        }
    }
    
    // Check for questions that can be deleted
//    func deleteRemovedQuestions(oldQuiz: Quiz, updatedQuiz: Quiz) -> Bool {
//        let deletedQuestions = oldQuiz.questions.filter { !updatedQuiz.questions.contains($0) }
//        for deletableQuestion in deletedQuestions {
//            if deleteQuestion(question: deletableQuestion) {
//                print("Deleted question.")
//            } else {
//                print("Unable to delete question.")
//                return false
//            }
//        }
//        return true
//    }
    
    // Delete quiz
    func deleteQuiz(quiz: Quiz) -> Bool {
        do {
            // DB connection
            let db = try Connection(databaseURL)
            
            let quizId = quiz.quizId!
            let quizToDelete = quizTable.filter(quizIdCol == quizId) // Get quiz with matching quizId
            let questionsToDelete = questionTable.filter(quizIdColLiteral == quizId) // Get questions with matching quizId
            
            let deletedQuestionsCount = try db.run(questionsToDelete.delete()) // Delete all questions with matching quizId first due to FOREIGN KEY restraint
            
            let deletedQuizCount = try db.run(quizToDelete.delete()) // Proceed to deleting quiz
            
            print("Successfully deleted quiz.")
            return deletedQuestionsCount > 0 && deletedQuizCount > 0
        } catch {
            print("Error deleting quiz: \(error)")
            return false
        }
    }
    
    // Delete question
    func deleteQuestion(question: Question) -> Bool {
        do {
            // DB connection
            let db = try Connection(databaseURL)
            
            let questionId = question.questionId!
            let questionToDelete = questionTable.filter(questionIdCol == questionId) // SELECT * FROM questions WHERE id = questionId
            
            return try db.run(questionToDelete.delete()) > 0
        } catch {
            print("Error deleting question: \(error)")
            return false
        }
    }
    
    // Check for existing quiz title
    func isExitingTitle(title: String, userId: Int) -> Bool {
        do {
            // DB connection
            let db = try Connection(databaseURL)
            
            let query = quizTable.filter(userIdCol == userId) // SELECT * FROM quizzes WHERE userId = userId
            let rowIterator = try db.prepareRowIterator(query) // Execute query via row iterator to handle errors
            let rows = try Array(rowIterator) // Create array using result
            
            for row in rows { // Loop through results
                if row[titleCol] == title { // Check if the current row's quiz title is equal to the provided title and return true if it is
                    return true
                }
            }
            return false
        } catch {
            print("Error checking for existing quiz title: \(error)")
            return true
        }
    }
}
