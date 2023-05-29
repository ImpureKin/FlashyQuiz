//
//  Question.swift
//  FlashyQuiz
//
//  Created by Alyssa Rodriguez on 29/5/2023.
//

import Foundation

struct Question : Equatable {
    var questionId: Int?
    var question: String
    var correctAnswer: String
    var incorrectAnswers: [String]
    
    static func == (lhs: Question, rhs: Question) -> Bool {
        return lhs.question == rhs.question &&
            lhs.correctAnswer == rhs.correctAnswer &&
            lhs.incorrectAnswers == rhs.incorrectAnswers
    }
    
    init(question: String, correctAnswer: String, incorrectAnswers: [String]) {
        self.question = question
        self.correctAnswer = correctAnswer
        self.incorrectAnswers = incorrectAnswers
    }
    
    init(questionId: Int, question: String, correctAnswer: String, incorrectAnswers: [String]) {
        self.questionId = questionId
        self.question = question
        self.correctAnswer = correctAnswer
        self.incorrectAnswers = incorrectAnswers
    }
}
