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
    var count: Int //Needed
    var wins: Int
    var ties: Int
    var handChances: [HandChance] //Needed
    var favourite: Bool
    var handCards: [Card]? //Needed
    
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
}
