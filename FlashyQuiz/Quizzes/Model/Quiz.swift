//
//  Quiz.swift
//  FlashyQuiz
//
//  Created by Alyssa Rodriguez on 20/5/2023.
//

import Foundation

class Quiz: Codable {
    var quizId = UUID().hashValue
    var userId : String
    var title: String
    var questions: [Question]
    
    init(userId: String, title: String, questions: [Question]) {
        self.userId = userId
        self.title = title
        self.questions = questions
    }
}

class Question : Codable {
    var text: String
    var correctAnswer: [String]
    var incorrectAnswers: [String]
    
    init(text: String, correctAnswer: [String], incorrectAnswers: [String]) {
        self.text = text
        self.correctAnswer = correctAnswer
        self.incorrectAnswers = incorrectAnswers
    }
}

