//
//  Quiz.swift
//  FlashyQuiz
//
//  Created by Alyssa Rodriguez on 20/5/2023.
//

import Foundation

struct Quiz: Equatable { // the structure is reperesnting a quiz 
    var quizId: Int? // unique identifier for quiz is optional
    var title: String // title of the quiz
    var privacy: String // privacy setting for the quiz (public or private)
    var questions: [Question] // an array of question objects represented in an array

    // Initalise without quizId
    init(title: String, privacy: String, questions: [Question]) {
        self.title = title
        self.questions = questions
        self.privacy = privacy
    }

    //  Initalise with quizId
    init(quizId: Int, title: String, privacy: String, questions: [Question]) {
        self.quizId = quizId
        self.title = title
        self.questions = questions
        self.privacy = privacy
    }

}

