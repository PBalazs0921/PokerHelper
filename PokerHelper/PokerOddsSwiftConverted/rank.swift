//
//  rank.swift
//  PokerHelper
//
//  Created by Balázs Péter on 29/05/2024.
//  Copyright © 2024 Apple. All rights reserved.
//


import Foundation

// Load lookup.json into a dictionary
let lookup: [String: [String: String]] = {
    guard let url = Bundle.main.url(forResource: "lookup", withExtension: "json"),
          let data = try? Data(contentsOf: url),
          let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: [String: String]] else {
        fatalError("Unable to load lookup.json")
    }
    return json
}()

func rankValues(_ values: [String]) -> String? {
    var total = 0
    var maxCount = 0
    var cardMatches: [String: Int] = [:]
    
    for value in values {
        cardMatches[value] = 0
    }
    
    for i in 0..<values.count {
        let first = values[i]
        for j in 0..<values.count {
            if i == j { continue }
            let second = values[j]
            if first == second {
                cardMatches[first, default: 0] += 1
                total += 1
                maxCount = max(maxCount, cardMatches[first]!)
            }
        }
    }
    
    let matches = total / 2
    let straight = getStraight(dedupe(values)) // Dedupe to match straights like AKKKQJT
    let kickers = convertToHex(values.sorted { cardMatches[$1]! - cardMatches[$0]! })
    
    if maxCount > 3 {
        return nil
    }
    if maxCount == 3 {
        return "7" + String(kickers.prefix(4)) + getHighestKicker(String(kickers.suffix(kickers.count - 4)))
    }
    if maxCount == 2 && matches > 3 {
        return "6" + String(kickers.prefix(5))
    }
    if let straight = straight {
        return "4" + straight
    }
    if maxCount == 2 {
        return "3" + String(kickers.prefix(5))
    }
    if maxCount == 1 && matches > 1 {
        return "2" + String(kickers.prefix(4)) + getHighestKicker(String(kickers.suffix(kickers.count - 4)))
    }
    if maxCount == 1 {
        return "1" + String(kickers.prefix(5))
    }
    return "0" + String(kickers.prefix(5))
}

func rankHand(_ input: [String]) -> String {
    let hand = input.sorted(by: numericalSort)
    let values = hand.map { String($0.first!) }.joined()
    let suits = hand.map { String($0.last!) }.sorted().joined()
    
    guard let rank = lookup["rank"]?[values],
          let flush = lookup["flush"]?[suits] else {
        fatalError("Invalid hand: \(hand.joined(separator: " "))")
    }
    
    let straight = rank.first == "4"
    
    if straight && flush=="flush" {
        let flushed = hand.filter { String($0.last!) == flush }.map { String($0.first!) }
        if let kickers = getStraight(flushed) {
            return (kickers.first == "e" ? "9" : "8") + kickers
        }
    }
    if flush == "flush" {
        let kickers = convertToHex(hand.filter { String($0.last!) == flush }.prefix(5))
        return "5" + kickers
    }
    return rank
}

func getFlush(_ string: String) -> String? {
    let regex = try! NSRegularExpression(pattern: "(s{5}|c{5}|d{5}|h{5})", options: [])
    if let match = regex.firstMatch(in: string, options: [], range: NSRange(location: 0, length: string.count)) {
        return String(string[Range(match.range, in: string)!].first!)
    }
    return nil
}

func getHighestKicker(_ string: String) -> String {
    return String(string.sorted().reversed().first!)
}

func dedupe(_ array: [String]) -> [String] {
    return Array(Set(array))
}


