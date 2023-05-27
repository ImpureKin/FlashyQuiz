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
            let userId = Expression<Int>("userId")
            let title = Expression<String>("title")
            let privacy = Expression<String>("privacy")
            let question = Expression<String>("question")
            let correctAnswer = Expression<String>("correctAnswer")
            let incorrectAnswer1 = Expression<String>("incorrectAnswer1")
            let incorrectAnswer2 = Expression<String>("incorrectAnswer2")
            let incorrectAnswer3 = Expression<String>("incorrectAnswer3")
            
            // Construct query
            let query = quizzesView.filter(quizzesView[userId] == userId) // Quizzes owned by provided userId
            let rows = try db.prepare(query)
            let totalRowCount = rows.lazy.map { _ in 1 }.reduce(0, +)
            
            for (index, row) in rows.enumerated() {
                let quizIdValue = row[quizId]
                let userIdValue = row[userId]
                let titleValue = row[title]
                let privacyValue = row[privacy]
                let questionValue = row[question]
                let correctAnswerValue = row[correctAnswer]
                let incorrectAnswers = [row[incorrectAnswer1], row[incorrectAnswer2], row[incorrectAnswer3]].compactMap { $0 }
                
                let question = Question(question: questionValue, correctAnswer: correctAnswerValue, incorrectAnswers: incorrectAnswers)
                questions.append(question)
                
                if index == totalRowCount - 1 {
                    let quiz = Quiz(quizId: quizIdValue, userId: userIdValue, title: titleValue, privacy: privacyValue, questions: questions)
                    quizzes.append(quiz)                }
            }
        } catch {
            print("Error retrieving quizzes: \(error)")
        }
        return quizzes
    }
}
