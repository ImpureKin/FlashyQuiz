//
//  FlashCardDetailsViewController.swift
//  FlashyQuiz
//
//  Created by Ashton Chan on 29/5/2023.
//

import UIKit

class FlashCardDetailsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var flashcardGroupTitleLabel: UILabel!
    @IBOutlet weak var flashcardTable: UITableView!
    @IBOutlet weak var deleteButton: UIButton!
    
    var flashcardGroup: FlashcardGroup?
    var flashcardManager = FlashcardManager()
    var isComingFromExplorePage: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        flashcardGroupTitleLabel.text = flashcardGroup?.title
        
        let nib = UINib(nibName: "FlashCardCell", bundle: nil)
        flashcardTable.register(nib, forCellReuseIdentifier: "FlashCardCell")
        flashcardTable.delegate = self
        flashcardTable.dataSource = self
        
        if isComingFromExplorePage {
            // Hide the delete button if coming from the explore page
            deleteButton.isEnabled = false // disabled the modify button
            deleteButton.setTitleColor(.gray, for: .disabled) //sets to gray text
            deleteButton.backgroundColor = .lightGray //sets it to be gray background
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return flashcardGroup?.flashcards.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FlashCardCell", for: indexPath) as! FlashCardCell
        
        guard let flashcard = flashcardGroup?.flashcards[indexPath.row] else {
            return cell
        }
        
        cell.flashCardTitle.text = flashcard.question
        cell.termLabel.text = flashcard.answer
        
        // Configure other cell properties based on the flashcard
        
        return cell
    }
    
    @IBAction func deleteButtonTapped(_ sender: UIButton) {
        // Create an alert to confirm deletion
        let alert = UIAlertController(title: "Delete Flashcard Group",
                                      message: "Are you sure you want to delete this flashcard group?",
                                      preferredStyle: .alert)

        // Add a cancel action
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(cancelAction)

        // Add a delete action
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { [weak self] _ in
            guard let self = self else {
                return
            }

            if let flashcardGroup = self.flashcardGroup {
                let isDeleted = self.flashcardManager.deleteFlashcardGroup(flashcardGroup: flashcardGroup)

                if isDeleted {
                    self.displayAlertWithCompletion(message: "Flashcard group deleted successfully") {
                        self.navigateBackToPage()
                    }
                } else {
                    self.displayAlert(message: "Failed to delete flashcard group")
                }
            }
        }
        alert.addAction(deleteAction)

        // Present the alert
        present(alert, animated: true, completion: nil)
    }

    
    func displayAlertWithCompletion(message: String, completion: (() -> Void)? = nil) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { _ in
            completion?()
        }
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
    
    func displayAlert(message: String) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier {
            switch identifier {
            case "goToPlayFlashcard":
                if let playFlashcardVC = segue.destination as? ViewFlashcardsViewController {
                    playFlashcardVC.flashCardGroup = flashcardGroup
                    playFlashcardVC.questions = flashcardGroup?.flashcards.map { $0.question } ?? []
                    playFlashcardVC.answers = flashcardGroup?.flashcards.map { $0.answer } ?? []
                }
            default:
                break
            }
        }
    }
    
    func navigateBackToPage() {
        if let quizMainMenuVC = navigationController?.viewControllers.first(where: { $0 is BaseTabBarController }) {
            navigationController?.popToViewController(quizMainMenuVC, animated: true)
        }
    }
}
