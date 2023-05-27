import Foundation
import SQLite

struct QuizManager {

    let databaseURL = DatabaseManager().getDatabasePath()

    func getUserQuizzes(userId: Int) -> [Quiz]? {
        var quizzes: [Quiz] = []
        var questions: [Question] = []

        do {
            let db = try Connection(databaseURL)

            let quizzesView = View("FullQuiz")
            let quizId = Expression<Int>("id")
            var prevQuizId: Int = 0
            let userId = Expression<Int>("userId")
            let title = Expression<String>("title")
            let privacy = Expression<String>("privacy")
            let question = Expression<String>("question")
            let correctAnswer = Expression<String>("correctAnswer")
            let incorrectAnswer1 = Expression<String>("incorrectAnswer1")
            let incorrectAnswer2 = Expression<String>("incorrectAnswer2")
            let incorrectAnswer3 = Expression<String>("incorrectAnswer3")

            let query = quizzesView.filter(quizzesView[userId] == userId)
            let rows = try db.prepare(query)
            let totalRowCount = rows.lazy.map { _ in 1 }.reduce(0, +)
            var index = 0

            for row in rows {
                let quizIdValue = row[quizId]
                let userIdValue = row[userId]
                let titleValue = row[title]
                let privacyValue = row[privacy]
                let questionValue = row[question]
                let correctAnswerValue = row[correctAnswer]
                let incorrectAnswers = [row[incorrectAnswer1], row[incorrectAnswer2], row[incorrectAnswer3]].compactMap { $0 }
                let question = Question(question: questionValue, correctAnswer: correctAnswerValue, incorrectAnswers: incorrectAnswers)

                if prevQuizId == 0 {
                    questions.append(question)
                } else if quizIdValue == prevQuizId {
                    questions.append(question)
                } else {
                    let quiz = Quiz(quizId: prevQuizId, userId: userIdValue, title: titleValue, privacy: privacyValue, questions: questions)
                    quizzes.append(quiz)
                    questions = []
                    questions.append(question)
                }
                prevQuizId = quizIdValue

                if index == totalRowCount - 1 {
                    let quiz = Quiz(quizId: quizIdValue, userId: userIdValue, title: titleValue, privacy: privacyValue, questions: questions)
                    quizzes.append(quiz)
                }
                index += 1
            }
        } catch {
            print("Error retrieving quizzes: \(error)")
        }
        return quizzes
    }
}

