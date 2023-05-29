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
    
    var flashcardGroup: FlashcardGroup?
    var questions: [String] = [] // Placeholder for questions
    var answers: [String] = [] // Placeholder for answers
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        flashcardGroupTitleLabel.text = flashcardGroup?.title
        
        let nib = UINib(nibName: "FlashCardCell", bundle: nil)
        flashcardTable.register(nib, forCellReuseIdentifier: "FlashCardCell")
        
        flashcardTable.delegate = self
        flashcardTable.dataSource = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return flashcardGroup?.flashcards.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FlashCardCell", for: indexPath) as! FlashCardCell
        
        let flashcard = flashcardGroup?.flashcards[indexPath.row]
        cell.flashCardTitle.text = flashcardGroup?.title
        
        // Configure other cell properties based on the flashcard
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier {
            switch identifier {
            case "goToModifyFlashcard":
                if let modifyFlashcardVC = segue.destination as? EditFlashCardViewController {
                    // Pass necessary data to the ModifyFlashcardViewController
                }
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

}

