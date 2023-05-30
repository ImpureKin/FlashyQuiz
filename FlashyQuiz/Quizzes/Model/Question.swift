//
//  Question.swift
//  FlashyQuiz
//
//  Created by Alyssa Rodriguez on 29/5/2023.
//

import Foundation

struct Question : Equatable { // the structure is reperesnting a question in a quiz 
    var questionId: Int? // the unique identifier for question is an optional int
    var question: String // test for the question
    var correctAnswer: String // correct answer to the question
    var incorrectAnswers: [String] // an array of incorrect answers
    
    //cusorm implementation of the equality operater in question
    static func == (lhs: Question, rhs: Question) -> Bool {
        return lhs.question == rhs.question &&
            lhs.correctAnswer == rhs.correctAnswer &&
            lhs.incorrectAnswers == rhs.incorrectAnswers
    }
    
    // Initalise without questionID
    init(question: String, correctAnswer: String, incorrectAnswers: [String]) {
        self.question = question
        self.correctAnswer = correctAnswer
        self.incorrectAnswers = incorrectAnswers
    }
    
    // Initalise wih questionId
    init(questionId: Int, question: String, correctAnswer: String, incorrectAnswers: [String]) {
        self.questionId = questionId
        self.question = question
        self.correctAnswer = correctAnswer
        self.incorrectAnswers = incorrectAnswers
    }
}
