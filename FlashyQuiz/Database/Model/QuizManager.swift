import Foundation
import SQLite

struct QuizManager {
    
    let databaseURL = DatabaseManager().getDatabasePath()
    
    // Function to retrieve user details by ID
    // Returns ID - Username - Email
    func getUserQuizzes(userId: Int) -> [Quiz]? {
        var quizzes: [Quiz] = []
        var questions: [Question] = []
        do {
            let db = try Connection("path/to/db.sqlite3")
            
            let quizzesView = View("FullQuiz") // Changed from Table() to View(), if encountering an error, switch back
            let quizId = Expression<Int>("id")
            var prevQuizId : Int = 0// To be used as tracking between quizzes
            let userId = Expression<Int>("userId")
            let title = Expression<String>("title")
            let privacy = Expression<String>("privacy")
            let question = Expression<String>("question")
            let correctAnswer = Expression<String>("correctAnswer")
            let incorrectAnswer1 = Expression<String>("incorrectAnswer1")
            let incorrectAnswer2 = Expression<String>("incorrectAnswer2")
            let incorrectAnswer3 = Expression<String>("incorrectAnswer3")
            
            let query = quizzesView.filter(quizzesView[userId] == userId) // Filter view to quizzes owned by provided userId
            let rows = try db.prepare(query) // Query view
            let totalRowCount = rows.lazy.map { _ in 1 }.reduce(0, +) // get total row count of data fetched
            
            for (index, row) in rows.enumerated() { // Iterate through rows of data, assigning values according to row data
                let quizIdValue = row[quizId]
                let userIdValue = row[userId]
                let titleValue = row[title]
                let privacyValue = row[privacy]
                let questionValue = row[question]
                let correctAnswerValue = row[correctAnswer]
                let incorrectAnswers = [row[incorrectAnswer1], row[incorrectAnswer2], row[incorrectAnswer3]].compactMap { $0 } // Collect incorrect answers
                let question = Question(question: questionValue, correctAnswer: correctAnswerValue, incorrectAnswers: incorrectAnswers) // Create Question
                
                if prevQuizId == 0 { // First row of data
                    questions.append(question) // Append created question to array/list
                } else if quizIdValue == prevQuizId { // Same quiz as prior row
                    questions.append(question) // Append created question to array/list
                } else { // Not the same quiz as prior row
                    let quiz = Quiz(quizId: quizIdValue, userId: userIdValue, title: titleValue, privacy: privacyValue, questions: questions) // Create Quiz
                    quizzes.append(quiz) // Append quiz to array/list
                    questions = [] // Reset questions array/list
                    questions.append(question) // Append created question to array/list
                }
                prevQuizId = quizIdValue // reassign prevQuizId before next iteration
                
                if index == totalRowCount - 1 { // Check if it's the last row of data, if it is, create and append final quiz
                    let quiz = Quiz(quizId: quizIdValue, userId: userIdValue, title: titleValue, privacy: privacyValue, questions: questions) // Create Quiz
                    quizzes.append(quiz) // Append quiz to array/list
                }
            }
        } catch {
            print("Error retrieving quizzes: \(error)")
        }
        return quizzes
    }
}
