//
//  Quiz.swift
//  FlashyQuiz
//
//  Created by Alyssa Rodriguez on 20/5/2023.
//

import Foundation

struct Quiz: Codable {
    var quizId: Int = UUID().hashValue //make ? optional when merging with database
    var userId : Int
    var title: String
    var privacy: String
    var questions: [Question]
    
    init(userId: Int, title: String, privacy: String, questions: [Question]) {
        self.userId = userId
        self.title = title
        self.questions = questions
        self.privacy = privacy
    }
    
    init(quizId: Int,userId: Int, title: String, privacy: String, questions: [Question]) {
        self.quizId = quizId
        self.userId = userId
        self.title = title
        self.questions = questions
        self.privacy = privacy
    }
    
    mutating func modifyQuestions(_ newQuestions: [Question]) {
            self.questions = newQuestions
        }
}



struct Question : Codable {
    var question: String
    var correctAnswer: String
    var incorrectAnswers: [String]
    
    init(question: String, correctAnswer: String, incorrectAnswers: [String]) {
        self.question = question
        self.correctAnswer = correctAnswer
        self.incorrectAnswers = incorrectAnswers

    }
}

