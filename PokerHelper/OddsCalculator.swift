//
//  OddsCalculator.swift
//  PokerHelper
//
//  Created by Balázs Péter on 06/06/2024.
//  Copyright © 2024 Apple. All rights reserved.
//
//Github link for used NPM repo: https://github.com/cookpete/poker-odds

import Foundation
import JavaScriptCore


// hands are required to calculate (2 cards) Board can be nil (pre-flop) or a string of array containing 3-5 cards
private func runJavaScriptFunction(hands: [[String]],board: [String] = []) -> PokerHandStats? {
    
    let iterations = 100000
    let exhaustive = false
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
                print("Calculation Results:")
                print(result)
                print("JSON conversion:")
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

// Read contents of JS file
private func loadJavaScriptFromFile(named filename: String) -> String? {
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

func calculateOdds(card1 c1: String, card2 c2:String, board boardInputParam:[String] = []) -> PokerHandStats?{
    //let boardIn = [String]()
    let handin = [[c1, c2]]
    //let iterations = 100000
    //let exhaustive = false
    return runJavaScriptFunction(hands: handin,board: boardInputParam)
}

