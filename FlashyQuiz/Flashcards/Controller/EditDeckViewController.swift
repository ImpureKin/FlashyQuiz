//
//  EditDeckViewController.swift
//  FlashyQuiz
//
//  Created by Ashton Chan on 25/5/2023.
//

import Foundation
import UiKit

class EditDeckViewController: UIViewController {
    
    var viewModel: EditDeckViewModel!
    var deck: FlashcardDeck!
    
    @IBOutlet weak var deckNameLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        deckNameLabel.text = deck.name
        
        tableView.delegate = self
        tableView.dataSource = self
        
        viewModel.fetchFlashcards(forDeck: deck)
    }
    
    // MARK: - Actions
    
    @IBAction func deleteDeckButtonPressed(_ sender: UIButton) {
        let alertController = UIAlertController(title: "Delete Deck", message: "Are you sure you want to delete this deck?", preferredStyle: .alert)
        
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { [weak self] _ in
            self?.viewModel.deleteDeck(self?.deck)
            self?.navigationController?.popViewController(animated: true)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alertController.addAction(deleteAction)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }
}

extension EditDeckViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfFlashcards()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FlashcardCell", for: indexPath)
        let flashcard = viewModel.flashcard(atIndex: indexPath.row)
        cell.textLabel?.text = flashcard.question
        return cell
    }
}
