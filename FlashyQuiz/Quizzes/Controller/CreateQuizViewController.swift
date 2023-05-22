//
//  CreateQuizViewController.swift
//  FlashyQuiz
//
//  Created by Alyssa Rodriguez on 20/5/2023.
//

import UIKit
import Foundation

class CreateQuizViewController: UIViewController {

    @IBOutlet weak var quizTitle: UILabel!
    @IBOutlet weak var question: UITextField!
    @IBOutlet weak var optionOne: UITextField!
    @IBOutlet weak var optionTwo: UITextField!
    @IBOutlet weak var optionThree: UITextField!
    @IBOutlet weak var optionFour: UITextField!
    
    var selectedTitle: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        quizTitle.text = selectedTitle
    }

}
