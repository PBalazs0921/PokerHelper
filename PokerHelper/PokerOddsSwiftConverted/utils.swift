//
//  utils.swift
//  PokerHelper
//
//  Created by Balázs Péter on 29/05/2024.
//  Copyright © 2024 Apple. All rights reserved.
//

import Foundation

let CARD_VALUES = ["2", "3", "4", "5", "6", "7", "8", "9", "T", "J", "Q", "K", "A"]
let CARD_SUITS = ["s", "c", "h", "d"]
let RANK_NAMES = [
    "high card",
    "one pair",
    "two pair",
    "three of a kind",
    "straight",
    "flush",
    "full house",
    "four of a kind",
    "straight flush",
    "royal flush"
]

let NUMERICAL_VALUES: [Character: Int] = [
    "T": 10,
    "J": 11,
    "Q": 12,
    "K": 13,
    "A": 14
]

let STRAIGHTS = [
    "AKQJT",
    "KQJT9",
    "QJT98",
    "JT987",
    "T9876",
    "98765",
    "87654",
    "76543",
    "65432",
    "5432A"
]

func numericalValue(_ card: String) -> Int {
    return NUMERICAL_VALUES[card.first!] ?? Int(String(card.first!))!
}

func numericalSort(_ a: String, _ b: String) -> Bool {
    return numericalValue(a) > numericalValue(b)
}

func convertToHex(_ input: Any) -> String {
    let characters: [Character]
    if let inputString = input as? String {
        characters = Array(inputString)
    } else if let inputArray = input as? [Character] {
        characters = inputArray
    } else {
        return ""
    }
    
    return characters
        .map { String(numericalValue(String($0)), radix: 16) }
        .joined()
}

func parseCards(_ string: String?) -> [String]? {
    guard let string = string else {
        return nil
    }
    
    let regex = try! NSRegularExpression(pattern: "[AKQJT2-9.][schd.]", options: [])
    let matches = regex.matches(in: string, options: [], range: NSRange(location: 0, length: string.count))
    return matches.map { String(string[Range($0.range, in: string)!]) }
}

func percent(_ number: Double) -> String {
    if number == 0 {
        return "·"
    } else if number > 0 && number < 0.001 {
        return "0.1%"
    } else {
        return "\(round(number * 100, to: 1))%"
    }
}

func seconds(_ ms: Int) -> String {
    if ms >= 1000 {
        return "\(round(Double(ms) / 1000, to: 1))s"
    } else {
        return "\(ms)ms"
    }
}

func getStraight(_ hand: [String]) -> String? {
    let values = hand.joined()
    let suffix = values.first == "A" ? "A" : ""
    
    for straight in STRAIGHTS {
        if values.contains(straight) || "\(values)\(suffix)".contains(straight) {
            return convertToHex(straight)
        }
    }
    
    return nil
}

func padStart(_ string: String, toLength length: Int, with padString: String = " ") -> String {
    if string.count >= length {
        return string
    } else {
        return String(repeating: padString, count: length - string.count) + string
    }
}

func padEnd(_ string: String, toLength length: Int, with padString: String = " ") -> String {
    if string.count >= length {
        return string
    } else {
        return string + String(repeating: padString, count: length - string.count)
    }
}

func round(_ number: Double, to decimalPlaces: Int = 1) -> Double {
    let multiplier = pow(10.0, Double(decimalPlaces))
    return (number * multiplier).rounded() / multiplier
}
