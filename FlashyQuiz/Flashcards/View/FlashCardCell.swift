//
//  FlashCardCell.swift
//  FlashyQuiz
//
//  Created by Ashton Chan on 29/5/2023.
//

import UIKit

class FlashCardCell: UITableViewCell {
    @IBOutlet weak var flashCardTitle: UILabel!
    @IBOutlet weak var termLabel: UILabel!
    
    // Add any additional outlets or properties as needed
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Perform any additional setup or customization here
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        // Reset any cell content or state here
    }
}
