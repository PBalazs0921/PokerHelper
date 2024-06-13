//
//  PokerHandStats.swift
//  PokerHelper
//
//  Created by Balázs Péter on 06/06/2024.
//  Copyright © 2024 Apple. All rights reserved.
//

import Foundation
class PokerHandStats: Codable {
    var hand: [String]
    //var cards: [Card]
    var count: Int
    var wins: Int
    var ties: Int
    var handChances: [HandChance]
    var favourite: Bool
    var handCards: [Card]?
    
    init(hand: [String], count: Int, wins: Int, ties: Int, handChances: [HandChance], favourite: Bool) {
        self.hand = hand
        self.count = count
        self.wins = wins
        self.ties = ties
        self.handChances = handChances
        self.favourite = favourite
        //self.cards = []
        //self.cards = self.generateCards(from: hand)
        self.handCards = [] // Initialize handCards with an empty array


    }
    //Setup method need to be called after JSON parsing, the function calls in init does not run
    func setup(){
        self.handCards = self.generateCards(from: self.hand)
        self.loadHandPercentages()
    }
    private func loadHandPercentages(){
        for handChance in self.handChances {
            handChance.calculatePercentage(totalIterations: self.count)
        }
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
