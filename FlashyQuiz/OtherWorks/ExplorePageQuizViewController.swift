//
//  ExplorePageQuizView.swift
//  FlashyQuiz
//
//  Created by Nicholas  Schlederer on 30/5/2023.
//

import Foundation
import UIKit


class ExplorePageQuizViewController : UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let QM = FlashcardManager() // imports quiz manager
    
    var PublicFC: [FlashcardGroup] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        PublicFC = QM.getPublicFlashcardGroups() ?? []
    }
    
    
    
    
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return PublicFC.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "FlashCardCell", for: indexPath) as! FlashCardCell
        
        
        let flashCardGroup = PublicFC[indexPath.row]
        cell.flashCardTitle.text = flashCardGroup.title
        cell.termLabel.text = "\(flashCardGroup.flashcards.count) terms"
        
        return cell
    }
    
    
    

    
}
