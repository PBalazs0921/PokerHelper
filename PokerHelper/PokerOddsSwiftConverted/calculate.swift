//
//  calculate.swift
//  PokerHelper
//
//  Created by Balázs Péter on 29/05/2024.
//  Copyright © 2024 Apple. All rights reserved.
//

import Foundation


struct Rank {
    let name: String
    var count: Int
}

struct HandResult {
    let hand: [String]
    var count: Int
    var wins: Int
    var ties: Int
    var handChances: [Rank]
}


func deal(_ cards: [String], _ count: Int) -> [String] {
    // Implement deal function here
    return []
}

func analyse(_ results: [HandResult], _ board: [String]) -> [HandResult] {
    // Implement analyse function here
    return []
}

func calculateEquity(hands: [[String]], board: [String] = [], iterations: Int = 100000, exhaustive: Bool = false) -> [HandResult] {
    var results = hands.map { hand in
        HandResult(hand: hand,
                   count: 0,
                   wins: 0,
                   ties: 0,
                   handChances: Array(repeating: Rank(name: "", count: 0), count: 9))
    }
    
    if board.count == 5 {
        results = analyse(results, board)
    } else if board.count >= 3 {
        let deck = createDeck(withoutCards: board + hands.flatMap { $0 })
        for i in 0..<deck.count {
            if board.count == 4 {
                results = analyse(results, board + [deck[i]])
                continue
            }
            for j in i+1..<deck.count {
                results = analyse(results, board + [deck[i], deck[j]])
            }
        }
    } else if exhaustive {
        let deck = createDeck(withoutCards: board + hands.flatMap { $0 })
        for a in 0..<deck.count {
            for b in a+1..<deck.count {
                for c in b+1..<deck.count {
                    for d in c+1..<deck.count {
                        for e in d+1..<deck.count {
                            results = analyse(results, [deck[a], deck[b], deck[c], deck[d], deck[e]])
                        }
                    }
                }
            }
        }
    } else {
        for _ in 0..<iterations {
            let randomCards = deal(Array(hands.joined()), 5 - board.count)
            results = analyse(results, board + randomCards)
        }
    }
    
    let maxWins = results.map { $0.wins }.max() ?? 0
    return results.map { result in
        var newResult = result
        newResult.favourite = result.wins == maxWins
        return newResult
    }
}



// Main entry point
let hands: [[String]] = [["A♠", "K♠"], ["Q♠", "J♠"]]
let board: [String] = ["10♠", "9♠", "8♠"]
let equity = calculateEquity(hands: hands, board: board)
