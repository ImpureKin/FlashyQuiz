//
//  FlashCardViewController.swift
//  FlashyQuiz
//
//  Created by Ashton Chan on 25/5/2023.
//

import Foundation

import UIKit

class FlashcardViewController: UIViewController {
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var answerLabel: UILabel!
    
    var deck: FlashcardGroup!
    var currentIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupGestures()
        showFlashcard(at: currentIndex)
    }
    
    private func setupGestures() {
        let swipeRightGesture = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeGesture(_:)))
        swipeRightGesture.direction = .right
        view.addGestureRecognizer(swipeRightGesture)
        
        let swipeLeftGesture = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeGesture(_:)))
        swipeLeftGesture.direction = .left
        view.addGestureRecognizer(swipeLeftGesture)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTapGesture(_:)))
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc private func handleSwipeGesture(_ gesture: UISwipeGestureRecognizer) {
        if gesture.direction == .right {
            showPreviousFlashcard()
        } else if gesture.direction == .left {
            showNextFlashcard()
        }
    }
    
    @objc private func handleTapGesture(_ gesture: UITapGestureRecognizer) {
        flipFlashcard()
    }
    
    private func showFlashcard(at index: Int) {
        guard index >= 0 && index < deck.flashcards.count else { return }
        
        let flashcard = deck.flashcards[index]
        questionLabel.text = flashcard.question
        answerLabel.text = flashcard.answer
        answerLabel.isHidden = true
    }
    
    private func showNextFlashcard() {
        if currentIndex < deck.flashcards.count - 1 {
            currentIndex += 1
            showFlashcard(at: currentIndex)
            animateCardTransition(withDirection: .left)
        }
    }
    
    private func showPreviousFlashcard() {
        if currentIndex > 0 {
            currentIndex -= 1
            showFlashcard(at: currentIndex)
            animateCardTransition(withDirection: .right)
        }
    }
    
    private func flipFlashcard() {
        answerLabel.isHidden = !answerLabel.isHidden
        animateCardFlip()
    }
    
    private func animateCardTransition(withDirection direction: UIView.AnimationOptions) {
        UIView.transition(with: view, duration: 0.3, options: [.transitionFlipFromRight, .showHideTransitionViews], animations: nil, completion: nil)
    }
    
    private func animateCardFlip() {
        UIView.transition(with: view, duration: 0.3, options: [.transitionFlipFromLeft, .showHideTransitionViews], animations: nil, completion: nil)
    }
}
