import UIKit
import Foundation

// Define the PauseViewController
class CameraViewController: UIViewController {
    
    @IBOutlet weak var test: UILabel!
    
    private var cards: [Card] = []
    
    var HandStats: PokerHandStats?
    var statsLabel: UILabel!
    
    func setup(card: Card) {
        let instance = cards
        test.text = nil
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()

    }
    
    
    @objc func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    func calculateOddsTemp(c1: String, c2:String, board boardInputParam:[String] = [])-> PokerHandStats?{
        HandStats = calculateOdds(card1: c1, card2: c2, board: boardInputParam)
        return HandStats
    }
    
    //Update the string to display
    func displayStats(_ gameData: GameData) {
        let totalIterations = gameData.count
        var statsText = "Hand: \(gameData.handCards[0].code), \(gameData.handCards[1].code)\n"
        if(gameData.boardCards.count)>0{
            statsText+="Board:"
            for bc in gameData.boardCards{
                statsText+=" \(bc.code)"
            }
            statsText+="\n"
        }
        for handChance in gameData.handChances {
            statsText += handChance.toString() + "\n"
        }
        
        statsLabel.text = statsText
        view.setNeedsLayout() // Update layout
    }
    
    func setupUI() {
        // Initialize the statsLabel
        statsLabel = UILabel()
        statsLabel.numberOfLines = 0 // Allow multiple lines
        statsLabel.textAlignment = .left
        statsLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(statsLabel)
        
        // Set constraints for statsLabel
        NSLayoutConstraint.activate([
            statsLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 80),
            statsLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            statsLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
    }



}
