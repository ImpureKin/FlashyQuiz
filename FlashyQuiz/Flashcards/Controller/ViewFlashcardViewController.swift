//
//  ViewFlashcardViewController.swift
//  FlashyQuiz
//
//  Created by Ashton Chan on 25/5/2023.
//

import Foundation
import UIKit

class ViewFlashcardsViewController: UIViewController {
    
    var viewModel: FlashcardDeckViewModel!
    
    @IBOutlet weak var flashcardLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        displayNextFlashcard()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(flipFlashcard))
        flashcardLabel.addGestureRecognizer(tapGesture)
        
        let swipeRightGesture = UISwipeGestureRecognizer(target: self, action: #selector(showPreviousFlashcard))
        swipeRightGesture.direction = .right
        flashcardLabel.addGestureRecognizer(swipeRightGesture)
        
        let swipeLeftGesture = UISwipeGestureRecognizer(target: self, action: #selector(showNextFlashcard))
        swipeLeftGesture.direction = .left
        flashcardLabel.addGestureRecognizer(swipeLeftGesture)
    }
    
    // MARK: - Actions
    
    @objc func flipFlashcard() {
        viewModel.flipFlashcard()
        flashcardLabel.text = viewModel.currentFlashcardText()
    }
    
    @objc func showPreviousFlashcard() {
        viewModel.showPreviousFlashcard()
        flashcardLabel.text = viewModel.currentFlashcardText()
    }
    
    @objc func showNextFlashcard() {
        viewModel.showNextFlashcard()
        flashcardLabel.text = viewModel.currentFlashcardText()
    }
    
    // MARK: - Helper Methods
    
    func displayNextFlashcard() {
        flashcardLabel.text = viewModel.currentFlashcardText()
    }
}
