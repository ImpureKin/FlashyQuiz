//
//  DeckListViewController.swift
//  FlashyQuiz
//
//  Created by Ashton Chan on 25/5/2023.
//

import Foundation
import UIKit

class DeckListViewController: UIViewController {
    
    var viewModel: DeckListViewModel!
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        viewModel.fetchDecks()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tableView.reloadData()
    }
    
    // MARK: - Actions
    
    @IBAction func addDeckButtonPressed(_ sender: UIButton) {
        let alertController = UIAlertController(title: "Create Deck", message: "Enter a name for the new deck", preferredStyle: .alert)
        
        alertController.addTextField { textField in
            textField.placeholder = "Deck Name"
        }
        
        let createAction = UIAlertAction(title: "Create", style: .default) { [weak self] _ in
            guard let deckName = alertController.textFields?.first?.text else {
                return
            }
            
            self?.viewModel.createDeck(withName: deckName)
            self?.tableView.reloadData()
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alertController.addAction(createAction)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }
}

extension DeckListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfDecks()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DeckCell", for: indexPath)
        let deck = viewModel.deck(atIndex: indexPath.row)
        cell.textLabel?.text = deck.name
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let deck = viewModel.deck(atIndex: indexPath.row)
        performSegue(withIdentifier: "ViewDeckSegue", sender: deck)
    }
}
