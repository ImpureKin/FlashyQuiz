//
//  Quiz.swift
//  FlashyQuiz
//
//  Created by Alyssa Rodriguez on 20/5/2023.
//

import Foundation

class Quiz: Codable {
    var title: String
    var questions: [Question]
    var userId : String
    
    init(title: String, questions: [Question], userID: String) {
        self.title = title
        self.questions = questions
        self.userId = userID
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
