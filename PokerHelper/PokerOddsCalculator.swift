//
//  PokerOddsCalculator.swift
//  PokerHelper
//
//  Created by Balázs Péter on 28/05/2024.
//  Copyright © 2024 Apple. All rights reserved.
//

import Foundation
import JavaScriptCore

class PokerOddsCalculator {
    private let context: JSContext

    init() {
        self.context = JSContext()!
        
        // Set up exception handler to capture any JavaScript errors
        context.exceptionHandler = { context, exception in
            print("JS Error: \(exception?.toString() ?? "unknown error")")
        }
        
        // Load the bundled JavaScript file
        if let jsSourcePath = Bundle.main.path(forResource: "bundled", ofType: "js", inDirectory: "PokerOddsJS") {
            do {
                let jsSourceContents = try String(contentsOfFile: jsSourcePath, encoding: .utf8)
                context.evaluateScript(jsSourceContents)
                print("Loaded bundled.js")
            } catch {
                print("Error loading JavaScript file: bundled.js: \(error)")
            }
        } else {
            print("JavaScript file bundled.js not found")
        }
        
        // Expose the calculateEquity function from the JavaScript context
        let script = """
        function calculateEquityWrapper(hands, board, iterations, exhaustive) {
            console.log("calculateEquityWrapper called with", hands, board, iterations, exhaustive);
            return calculateEquity(hands, board, iterations, exhaustive);
        }
        """
        context.evaluateScript(script)
        print("Defined calculateEquityWrapper function")
    }

    func calculateEquity(hands: [[String]], board: [String], iterations: Int = 100000, exhaustive: Bool = false) -> [Any] {
        let calculateEquity = context.objectForKeyedSubscript("calculateEquityWrapper")
        print("Calling calculateEquityWrapper with hands: \(hands), board: \(board), iterations: \(iterations), exhaustive: \(exhaustive)")
        
        let result = calculateEquity?.call(withArguments: [hands, board, iterations, exhaustive])
        
        if let resultArray = result?.toArray() {
            print("JS result: \(resultArray)")
            return resultArray
        } else {
            print("JS result is nil or could not be converted to array")
            return []
        }
    }
}
