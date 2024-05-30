import UIKit
import Foundation
import JavaScriptCore

// Define a class for the hand chances
class HandChance: Codable {
    var name: String
    var count: Int
    
    init(name: String, count: Int) {
        self.name = name
        self.count = count
    }
}

// Define a class for the main data
class PokerHandStats: Codable {
    var hand: [String]
    //var cards: [Card]
    var count: Int
    var wins: Int
    var ties: Int
    var handChances: [HandChance]
    var favourite: Bool
    
    init(hand: [String], count: Int, wins: Int, ties: Int, handChances: [HandChance], favourite: Bool) {
        self.hand = hand
        self.count = count
        self.wins = wins
        self.ties = ties
        self.handChances = handChances
        self.favourite = favourite
        //self.cards = []
        //self.cards = self.generateCards(from: hand)
    }
    
    private func generateCards(from hand: [String]) -> [Card] {
        var cards: [Card] = []
        for code in hand {
            let card = Card(code: code)
            cards.append(card)
        }
        return cards
    }
}

// Define a class to wrap the data (if it's an array of PokerHandStats)
class PokerHandStatsWrapper: Codable {
    var stats: [PokerHandStats]
    
    init(stats: [PokerHandStats]) {
        self.stats = stats
    }
    
    enum CodingKeys: String, CodingKey {
        case stats = ""
    }
}

// Define the PauseViewController
class PauseViewController: UIViewController {
    
    @IBOutlet weak var test: UILabel!
    
    private var cards: [Card] = []
    
    var PokerCalcs: PokerHandStats?
    
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
 
        // Run the function

        // Define the parameters to pass to the JavaScript function
        //let handIn = [["Ah", "Kh"]]
        //let boardIn = [String]()
        //let iterations = 100000
        //let exhaustive = false
        //PokerCalcs=runJavaScriptFunction(hands: handIn,board: boardIn)
        
        //print(PokerCalcs?.hand.count)

    }
    
    func calculateOdds(c1: String, c2:String){
        let boardIn = [String]()
        let handin = [[c1, c2]]
        //let iterations = 100000
        //let exhaustive = false
        PokerCalcs=runJavaScriptFunction(hands: handin,board: boardIn)
        
        print(PokerCalcs?.hand.count)
    }
    @objc func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    
    // Function to read the contents of the bundle.js file
    func loadJavaScriptFromFile(named filename: String) -> String? {
        if let filepath = Bundle.main.path(forResource: filename, ofType: "js") {
            do {
                let contents = try String(contentsOfFile: filepath)
                return contents
            } catch {
                print("Could not load the file: \(error)")
            }
        } else {
            print("File not found")
        }
        return nil
    }

    // hands are required to calculate (2 cards) Board can be nil (pre-flop) or a string of array containing 3-5 cards
    func runJavaScriptFunction(hands: [[String]],board: [String] = [],iterations: Int = 100000,exhaustive: Bool = false) -> PokerHandStats? {
        
        let context = JSContext()
        
        // Load JavaScript from file
        if let script = loadJavaScriptFromFile(named: "bundle") {
            // Evaluate the script in the JavaScript context
            context?.evaluateScript(script)
            
            // Access the exported function from the global variable
            if let myLibrary = context?.objectForKeyedSubscript("MyLibrary"),
               let getStringFunction = myLibrary.objectForKeyedSubscript("getString") {
                
                
                // Call the JavaScript function with parameters
                if let result = getStringFunction.call(withArguments: [hands, board, iterations, exhaustive]) {
                    // Convert the result to a JSON string
                    print("REULT")
                    print(result)
                    // Convert the JSON string to Data
                    if let jsonData = result.toString().data(using: .utf8) {
                        do {
                            // Decode the JSON data to an array of PokerHandStats
                            let pokerHandStats = try JSONDecoder().decode([PokerHandStats].self, from: jsonData)
                            // Access the parsed data
                            for stat in pokerHandStats {
                                //print("Hand: \(stat.hand)")
                                //print("Count: \(stat.count)")
                                //print("Wins: \(stat.wins)")
                                //print("Ties: \(stat.ties)")
                                //print("Favourite: \(stat.favourite)")
                                //for handChance in stat.handChances {
                                 //   print("Hand Chance - Name: \(handChance.name), Count: \(handChance.count)")
                                //}
                            }
                            return pokerHandStats[0]
                        } catch {
                            print("Failed to decode JSON: \(error.localizedDescription)")
                        }
                    }
                    print("EUR")
                   

                } else {
                    print("Failed to execute JavaScript function")
                }
            } else {
                print("Failed to access JavaScript library or function")
            }
        } else {
            print("Failed to load JavaScript file")
            return nil
        }
        return nil
    }

}
