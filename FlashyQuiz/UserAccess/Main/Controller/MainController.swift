import UIKit

class MainController: UIViewController {
    
    @IBOutlet weak var maxBubblesLabel: UILabel!
    @IBOutlet weak var gameDurationLabel: UILabel!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var gameDurationSlider: UISlider!
    @IBOutlet weak var maxBubbleSlider: UISlider!
    
    override func viewDidLoad() {
        print("loaded")
        super.viewDidLoad()
    }
    
    // Used to adjust label values after a slider is adjusted by using slider tags
    @IBAction func printurl(_ sender: Any) {
        // The sender is the gameDurationSlider
        let db = Database()
        db.performDatabaseOperations()
    }
    
    @IBAction func dostuff() {
        let db = Database()
        db.performDatabaseOperations()
    }
}


