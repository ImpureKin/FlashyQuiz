import Foundation
import SQLite

struct QuizManager {

    let databaseURL = DatabaseManager().getDatabasePath()
    
    // Table & View variables
    let quizTable = Table("Quizzes")
    let questionTable = Table("Questions")
    let fullQuizView = View("FullQuiz")
    
    // Common Column variable (used in both Quizzes and Questions table)
    let userIdCol = Expression<Int?>("userId")
    let rowIdCol = Expression<Int64>("ROWID")
    
    // Column variables for Quizzes table
    let quizIdCol = Expression<Int>("id")
    let quizIdColLiteral = Expression<Int>("quizId")
    let titleCol = Expression<String>("title")
    let privacyCol = Expression<String>("privacy")
    
    // Column variables for Questions table
    let questionIdCol = Expression<Int>("id")
    let questionIdColLiteral = Expression<Int>("questionId")
    let questionCol = Expression<String>("question")
    let correctAnswerCol = Expression<String>("correctAnswer")
    let incorrectAnswer1Col = Expression<String>("incorrectAnswer1")
    let incorrectAnswer2Col = Expression<String>("incorrectAnswer2")
    let incorrectAnswer3Col = Expression<String>("incorrectAnswer3")

    // Get all Quizzes owned by a user via their userId
    func getUserQuizzes(userIdInput: Int) -> [Quiz]? {
        var quizzes: [Quiz] = []
        var questions: [Question] = []

        do {
            // DB connection
            let db = try Connection(databaseURL)
            
            // Query execution and results
            let query = fullQuizView.filter(userIdCol == userIdInput) // SELECT * FROM FullQuiz WHERE userId = (userIdInput)
            let rowIterator = try db.prepareRowIterator(query) // Execute query via row iterator to handle errors
            let rows = try Array(rowIterator) // Create array using result (to allow .count)
            
            // Tracking / other
            let totalRowCount = rows.count // Get total row count for tracking
            var prevQuizId: Int = 0
            var currentRow = 1

            // Loop through results
            for row in rows {
                // Get values from row/data and store into variables
                let quizId = row[quizIdColLiteral]
                let userId = row[userIdCol]
                let title = row[titleCol]
                let privacy = row[privacyCol]
                let questionId = row[questionIdColLiteral]
                let questionText = row[questionCol]
                let correctAnswer = row[correctAnswerCol]
                let incorrectAnswers = [row[incorrectAnswer1Col], row[incorrectAnswer2Col], row[incorrectAnswer3Col]].compactMap { $0 }
                let question = Question(questionId: questionId, question: questionText, correctAnswer: correctAnswer, incorrectAnswers: incorrectAnswers) // Create question

                if prevQuizId == 0 { // Is the first iteration/row
                    questions.append(question) // Append question
                } else if quizId == prevQuizId { // If the current row is a part of the same row
                    questions.append(question) // Append question
                } else { // Current row is part of a different quiz than before, append quiz, reset questions array
                    let quiz = Quiz(quizId: prevQuizId, userId: userId ?? userIdInput, title: title, privacy: privacy, questions: questions) // Create quiz (with questions)
                    quizzes.append(quiz) // Append quiz
                    questions = [] // Reset questions array
                    questions.append(question) // Append question to clean questions array
                }
                prevQuizId = quizId // Track previous quizId

                if currentRow == totalRowCount { // If this is the last row, append quiz before exiting loop
                    let quiz = Quiz(quizId: quizId, userId: userId ?? userIdInput, title: title, privacy: privacy, questions: questions) // Create quiz (with questions)
                    quizzes.append(quiz) // Append quiz
                }
                currentRow += 1 // Track current row
            }
        } catch {
            print("Error retrieving quizzes: \(error)")
        }
        print("Successfully retrieved quizzes")
        return quizzes
    }
    
    // Add a quiz into the database
    func addQuiz(quiz: Quiz) -> Bool {
        do {
            // DB connection
            let db = try Connection(databaseURL)
            
            // Insert quiz into DB and fetch created rowId
            let insertedQuizRowId = try db.run(quizTable.insert(titleCol <- quiz.title, userIdCol <- quiz.userId, privacyCol <- quiz.privacy))
            
            // Get the quizId of the recently inserted quiz using the generated rowId
            let quizId = getQuizIdByRowid(rowIdInput: insertedQuizRowId)
            if quizId != -1 { // Check if getting quizId was successful
                // Retrieve and loop through questions within provided quiz
                let questions: [Question] = quiz.questions
                for question in questions {
                    // Add questions into DB
                    try db.run(questionTable.insert(userIdCol <- quiz.userId,
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
    
    // Get a QuizId by table ROWID
    func getQuizIdByRowid(rowIdInput: Int64) -> Int {
        do {
            // DB connection
            let db = try Connection(databaseURL)
            
            let query = quizTable.filter(rowIdCol == rowIdInput)
            guard let quizRow = try db.pluck(query) else {
                return -1
            }
            let quizIdValue = quizRow[quizIdCol]
            return quizIdValue
        } catch {
            print("Error retrieving quizId: \(error)")
            return -1
        }
    }
    
    // Update Quiz
    func updateQuiz(updatedQuiz: Quiz) -> Bool {
        do {
            // DB connection
            let db = try Connection(databaseURL)
            
            let quizId = updatedQuiz.quizId!
            let quizToUpdate = quizTable.filter(quizIdCol == quizId)
            
            try db.run(quizToUpdate.update())
            
            return true
        } catch {
            print("Error retrieving quizId: \(error)")
            return false
        }
    }
    
    // Update Questions
    func updateQuestion(updatedQuiz: Quiz) -> Bool {
        do {
            // DB connection
            let db = try Connection(databaseURL)
            
            let quizId = updatedQuiz.quizId!
            let quizToUpdate = quizTable.filter(quizIdCol == quizId)
            
            try db.run(quizToUpdate.update())
            
            return true
        } catch {
            print("Error retrieving quizId: \(error)")
            return false
        }
    }
}

