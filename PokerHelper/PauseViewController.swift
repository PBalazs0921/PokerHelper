import UIKit
import Foundation
import JavaScriptCore

// Define the Swift structs to match the JSON structure
struct HandResult: Codable {
    let hand: [String]
    let count: Int
    let wins: Int
    let ties: Int
    let handChances: [HandChance]
    let favourite: Bool
}

struct HandChance: Codable {
    let name: String
    let count: Int
}

// Define a class to hold the poker results
class PokerResults {
    var results: [HandResult]
    
    init(results: [HandResult]) {
        self.results = results
    }
}

// Define the PauseViewController
class PauseViewController: UIViewController {
    
    @IBOutlet weak var test: UILabel!
    
    private var cards: [Card] = []
    private var pokerResults: PokerResults?
    
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

        func runJavaScriptFunction() {
            let context = JSContext()
            
            // Load JavaScript from file
            if let script = loadJavaScriptFromFile(named: "bundle") {
                // Evaluate the script in the JavaScript context
                context?.evaluateScript(script)
                
                // Access the exported function from the global variable
                if let myLibrary = context?.objectForKeyedSubscript("MyLibrary"),
                   let getStringFunction = myLibrary.objectForKeyedSubscript("getString") {
                    
                    // Define the parameters to pass to the JavaScript function
                    let hands = [["Ah", "Kh"]]
                    let board = [String]()
                    let iterations = 100000
                    let exhaustive = false
                    
                    // Call the JavaScript function with parameters
                    if let result = getStringFunction.call(withArguments: [hands, board, iterations, exhaustive]) {
                        // Convert the result to a JSON string
                        print("REULT")
                        print(result.toString())
                        print("EUR")
                        if let resultString = result.toString(),
                           let resultData = resultString.data(using: .utf8) {
                            do {
                                // Decode the JSON data into Swift structs
                                let decoder = JSONDecoder()
                                let handResults = try decoder.decode([HandResult].self, from: resultData)
                                
                                // Save the results to the PokerResults class
                                self.pokerResults = PokerResults(results: handResults)
                                print(self.pokerResults?.results)
                                // Print the result to the Swift console
                                print("Result from JavaScript function: \(handResults)")
                                
                                // Update the UILabel with the result (for demonstration)
                                test.text = handResults.map { "\($0)" }.joined(separator: "\n\n")
                                
                            } catch {
                                print("Failed to decode JSON: \(error)")
                            }
                        } else {
                            print("Failed to convert result to String or Data")
                        }
                    } else {
                        print("Failed to execute JavaScript function")
                    }
                } else {
                    print("Failed to access JavaScript library or function")
                }
            } else {
                print("Failed to load JavaScript file")
            }
        }

        // Run the function
        runJavaScriptFunction()

    }
    @objc func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
}
