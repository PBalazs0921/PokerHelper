import UIKit
import Foundation

// Define the PauseViewController
class CameraViewController: UIViewController {
    
    @IBOutlet weak var test: UILabel!
    
    private var cards: [Card] = []
    
    var HandStats: PokerHandStats?
    
    func setup(card: Card) {
        let instance = cards
        test.text = instance.description
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let backButton = UIButton(type: .system)
        backButton.setTitle("Back", for: .normal)
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        
        // Set button frame and add it to the view
        backButton.frame = CGRect(x: 20, y: 40, width: 60, height: 30)
        view.addSubview(backButton)
        
    }
    
    
    @objc func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    func calculateOddsTemp(c1: String, c2:String)-> PokerHandStats?{
        HandStats = calculateOdds(card1: c1, card2: c2)
        
        return HandStats
    }



}
