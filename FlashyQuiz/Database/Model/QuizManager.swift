import Foundation
import SQLite

struct QuizManager {

    let databaseURL = DatabaseManager().getDatabasePath()

    func getUserQuizzes(userIdInput: Int) -> [Quiz]? {
        var quizzes: [Quiz] = []
        var questions: [Question] = []

        do {
            let db = try Connection(databaseURL)

            let quizzesView = View("FullQuiz")
            let quizId = Expression<Int>("id")
            var prevQuizId: Int = 0
            let userId = Expression<Int?>("userId")
            let title = Expression<String>("title")
            let privacy = Expression<String>("privacy")
            let question = Expression<String>("question")
            let correctAnswer = Expression<String>("correctAnswer")
            let incorrectAnswer1 = Expression<String>("incorrectAnswer1")
            let incorrectAnswer2 = Expression<String>("incorrectAnswer2")
            let incorrectAnswer3 = Expression<String>("incorrectAnswer3")

            let query = quizzesView.filter(userId == userIdInput)
            print("SQL query: \(query)")
            // let rows = try db.prepare(query)
            let rowIterator = try db.prepareRowIterator(query)
            print("Queried view")
//            let totalRowCount = Array(rowIterator).count
//            print("Total row count = \(totalRowCount)")
            var currentRow = 1

            print("Entering for loop")
            for row in try Array(rowIterator) {
                print("Beginning of for loop")
                let quizIdValue = row[quizId]
                let userIdValue = row[userId] // I UNCOMMENTED THIS TO TRY
                let titleValue = row[title]
                let privacyValue = row[privacy]
                let questionValue = row[question]
                let correctAnswerValue = row[correctAnswer]
                let incorrectAnswers = [row[incorrectAnswer1], row[incorrectAnswer2], row[incorrectAnswer3]].compactMap { $0 }
                let question = Question(question: questionValue, correctAnswer: correctAnswerValue, incorrectAnswers: incorrectAnswers)
                print("Stored question variable ")

                if prevQuizId == 0 {
                    questions.append(question)
                } else if quizIdValue == prevQuizId {
                    questions.append(question)
                } else {
                    let quiz = Quiz(quizId: prevQuizId, userId: userIdValue ?? userIdInput, title: titleValue, privacy: privacyValue, questions: questions)
                    quizzes.append(quiz)
                    print("Stored quiz variable")
                    questions = []
                    questions.append(question)
                }
                prevQuizId = quizIdValue

                if currentRow == 4 {
                    let quiz = Quiz(quizId: quizIdValue, userId: userIdValue ?? userIdInput, title: titleValue, privacy: privacyValue, questions: questions)
                    quizzes.append(quiz)
                    print("Stored quiz variable")
                }
                currentRow += 1
                print("Going to next row/end of for loop. Index = \(currentRow)")
            }
        } catch {
            print("Error retrieving quizzes: \(error)")
        }
        print("Return quizzes")
        return quizzes
    }
}

