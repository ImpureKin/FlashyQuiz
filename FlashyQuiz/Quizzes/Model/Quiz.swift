//
//  Quiz.swift
//  FlashyQuiz
//
//  Created by Alyssa Rodriguez on 20/5/2023.
//

import Foundation

struct Quiz: Codable {
    var quizId: Int = UUID().hashValue
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
}

struct Question : Codable {
    var text: String
    var correctAnswer: [String]
    var incorrectAnswers: [String]
    
    init(text: String, correctAnswer: [String], incorrectAnswers: [String]) {
        self.text = text
        self.correctAnswer = correctAnswer
        self.incorrectAnswers = incorrectAnswers

    }
}

