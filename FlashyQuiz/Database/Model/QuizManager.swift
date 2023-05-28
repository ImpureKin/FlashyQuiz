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
                let quizId = row[quizIdCol]
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
    
    // Get a quiz via quizId
    func getQuiz(quizId: Int) -> Quiz? {
        do {
            // DB connection
            let db = try Connection(databaseURL)
            
            // Query execution and results
            let query = fullQuizView.filter(quizIdCol == quizId) // SELECT * FROM FullQuiz WHERE userId = (userIdInput)
            let rowIterator = try db.prepareRowIterator(query) // Execute query via row iterator to handle errors
            let rows = try Array(rowIterator) // Create array using result (to allow .count)
            
            // Tracking / other
            let totalRowCount = rows.count // Get total row count for tracking
            var currentRow = 1
            var questions: [Question] = []

            // Loop through results
            for row in rows {
                // Get values from row/data and store into variables
                let quizId = row[quizIdCol]
                let userId = row[userIdCol]
                let title = row[titleCol]
                let privacy = row[privacyCol]
                let questionId = row[questionIdColLiteral]
                let questionText = row[questionCol]
                let correctAnswer = row[correctAnswerCol]
                let incorrectAnswers = [row[incorrectAnswer1Col], row[incorrectAnswer2Col], row[incorrectAnswer3Col]].compactMap { $0 }
                let question = Question(questionId: questionId, question: questionText, correctAnswer: correctAnswer, incorrectAnswers: incorrectAnswers) // Create question

                if currentRow == totalRowCount { // If this is the last row, append quiz before exiting loop
                    let quiz = Quiz(quizId: quizId, userId: userId!, title: title, privacy: privacy, questions: questions) // Create quiz (with questions)
                    return quiz // Append quiz
                }
                currentRow += 1 // Track current row
            }
        } catch {
            print("Error retrieving quizzes: \(error)")
        }
        print("Successfully retrieved quizzes")
        return nil
    }
    
    // Get a quizId by table ROWID
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
            
            guard let oldQuizRow = try db.pluck(quizTable.filter(quizIdCol == quizId)) else { // Get row of data for old quiz
                return false
            }
            guard let oldQuiz = getQuiz(quizId: oldQuizRow[quizIdCol]) else { // Get old quiz as Quiz object
                return false
            }
            guard deleteRemovedQuestions(oldQuiz: oldQuiz, updatedQuiz: updatedQuiz) else { // Check for and delete any removed questions
                return false
            }
            guard updateQuestions(questions: updatedQuiz.questions) else { // Update remaining questions
                return false
            }
            
        } catch {
            print("Error retrieving quizId: \(error)")
            return false
        }
        return true
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
            print("Error retrieving quizId: \(error)")
            return false
        }
    }
    
    // Check for questions that can be deleted
    func deleteRemovedQuestions(oldQuiz: Quiz, updatedQuiz: Quiz) -> Bool {
        let deletedQuestions = oldQuiz.questions.filter { !updatedQuiz.questions.contains($0) }
        for deletableQuestion in deletedQuestions {
            if deleteQuestion(question: deletableQuestion) {
                print("Deleted question.")
            } else {
                print("Unable to delete question.")
                return false
            }
        }
        return true
    }
    
    // Delete quiz
    func deleteQuiz(quiz: Quiz) -> Bool {
        do {
            // DB connection
            let db = try Connection(databaseURL)
            
            let quizId = quiz.quizId!
            let quizToDelete = quizTable.filter(quizIdCol == quizId) // Get quiz with matching quizId
            let questionsToDelete = questionTable.filter(quizIdColLiteral == quizId) // Get questions with matching quizId
            
            // Delete all questions with matching quizId first due to FOREIGN KEY restraint
            if try db.run(questionsToDelete.delete()) > 0 { // DELETE FROM questions WHERE quizId = quizId;
                print("Deleted questions.")
            } else {
                print("Did not delete any questions.")
            }
            // Proceed to deleting quiz
            if try db.run(quizToDelete.delete()) > 0 { // DELETE FROM quizzes WHERE quizId = quizId;
                print("Deleted quiz.")
                return true
            } else {
                print("Did not delete quiz.")
                return false
            }
        } catch {
            print("Error retrieving quizId: \(error)")
            return false
        }
    }
    
    // Delete question
    func deleteQuestion(question: Question) -> Bool {
        do {
            // DB connection
            let db = try Connection(databaseURL)
            
            let questionId = question.questionId!
            let questionToDelete = questionTable.filter(questionIdCol == questionId)
            
            if try db.run(questionToDelete.delete()) > 0 {
                print("Deleted question.")
                return true
            } else {
                return false
            }
        } catch {
            print("Error retrieving quizId: \(error)")
            return false
        }
    }
}

