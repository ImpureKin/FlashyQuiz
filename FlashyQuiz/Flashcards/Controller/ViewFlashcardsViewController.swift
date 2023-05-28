//
//  ViewFlashcardsViewController.swift
//  FlashyQuiz
//
//  Created by Ashton Chan on 25/5/2023.
//

import UIKit

class ViewFlashcardsViewController: UIViewController {
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var answerLabel: UILabel!
    
    let questions = ["Question 1", "Question 2", "Question 3"]
    let answers = ["Answer 1", "Answer 2", "Answer 3"]
    
    var currentIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateCard()
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(flipCard))
        cardView.addGestureRecognizer(tapGestureRecognizer)
        
        let swipeLeftGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(nextQuestion))
        swipeLeftGestureRecognizer.direction = .left
        cardView.addGestureRecognizer(swipeLeftGestureRecognizer)
        
        let swipeRightGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(previousQuestion))
        swipeRightGestureRecognizer.direction = .right
        cardView.addGestureRecognizer(swipeRightGestureRecognizer)
    }
    
    @objc func flipCard() {
        UIView.transition(with: cardView, duration: 0.3, options: .transitionFlipFromRight, animations: {
            self.answerLabel.isHidden = !self.answerLabel.isHidden
            self.questionLabel.isHidden = !self.questionLabel.isHidden
        })
    }
    
    @objc func nextQuestion() {
        currentIndex += 1
        if currentIndex >= questions.count {
            currentIndex = questions.count - 1
            return
        }
        animateCard(direction: .transitionFlipFromRight)
        updateCard()
    }
    
    @objc func previousQuestion() {
        currentIndex -= 1
        if currentIndex < 0 {
            currentIndex = 0
            return
        }
        animateCard(direction: .transitionFlipFromLeft)
        updateCard()
    }
    
    func animateCard(direction: UIView.AnimationOptions) {
        UIView.transition(with: cardView, duration: 0.3, options: [direction, .curveEaseInOut], animations: nil, completion: nil)
    }
    
    func updateCard() {
        questionLabel.text = questions[currentIndex]
        answerLabel.text = answers[currentIndex]
        questionLabel.isHidden = false
        answerLabel.isHidden = true
    }
}
