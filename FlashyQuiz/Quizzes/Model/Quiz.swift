//
//  Quiz.swift
//  FlashyQuiz
//
//  Created by Alyssa Rodriguez on 20/5/2023.
//

import Foundation

struct Quiz: Equatable {
    var quizId: Int?
    var title: String
    var privacy: String
    var questions: [Question]
    
    init(title: String, privacy: String, questions: [Question]) {
        self.title = title
        self.questions = questions
        self.privacy = privacy
    }
    
    init(quizId: Int, title: String, privacy: String, questions: [Question]) {
        self.quizId = quizId
        self.title = title
        self.questions = questions
        self.privacy = privacy
    }
    
    mutating func modifyQuestions(_ newQuestions: [Question]) {
            self.questions = newQuestions
        }
    
    mutating func updateTitle(_ newTitle: String) {
        self.title = newTitle
    }
    
    mutating func updatePrivacy(_ newPrivacy: String) {
        self.privacy = newPrivacy
    }
    
}

