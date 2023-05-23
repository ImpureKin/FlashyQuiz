//
//  FlashCardViewController.swift
//  FlashyQuiz
//
//  Created by Ashton Chan on 25/5/2023.
//

import Foundation

import UIKit

class FlashCardViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var viewModel: FlashcardViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel = FlashcardViewModel()
        viewModel.delegate = self
        viewModel.loadFlashcardDecks()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "CreateFlashcardSegue" {
            let createFlashcardVC = segue.destination as! CreateFlashcardViewController
            createFlashcardVC.delegate = self
            createFlashcardVC.viewModel = viewModel
        } else if segue.identifier == "ViewFlashcardsSegue" {
            let viewFlashcardsVC = segue.destination as! ViewFlashcardsViewController
            if let indexPath = tableView.indexPathForSelectedRow {
                let selectedDeck = viewModel.flashcardDeck(at: indexPath.row)
                viewFlashcardsVC.viewModel = FlashcardDeckViewModel(flashcardDeck: selectedDeck)
            }
        }
    }
    
    // MARK: - Actions
    
    @IBAction func createFlashcardDeck(_ sender: UIButton) {
        performSegue(withIdentifier: "CreateFlashcardSegue", sender: nil)
    }
    
    @IBAction func editFlashcardDeck(_ sender: UIButton) {
        if let indexPath = tableView.indexPathForSelectedRow {
            viewModel.editFlashcardDeck(at: indexPath.row)
        }
    }
    
    @IBAction func deleteFlashcardDeck(_ sender: UIButton) {
        if let indexPath = tableView.indexPathForSelectedRow {
            viewModel.deleteFlashcardDeck(at: indexPath.row)
        }
    }
}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfFlashcardDecks()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FlashcardDeckCell", for: indexPath)
        let deck = viewModel.flashcardDeck(at: indexPath.row)
        cell.textLabel?.text = deck.name
        return cell
    }
}

extension ViewController: FlashcardViewModelDelegate {
    func flashcardDecksLoaded() {
        tableView.reloadData()
    }
}
