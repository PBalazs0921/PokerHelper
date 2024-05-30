//
//  deck.swift
//  PokerHelper
//
//  Created by Balázs Péter on 29/05/2024.
//  Copyright © 2024 Apple. All rights reserved.
//


import Foundation


let FULL_DECK: [String] = createDeck()

func createDeck(withoutCards: [String] = []) -> [String] {
    var deck: [String] = []
    
    for value in CARD_VALUES {
        for suit in CARD_SUITS {
            let card = value + suit
            if !withoutCards.contains(card) {
                deck.append(card)
            }
        }
    }
    
    return deck
}

func deal(withoutCards: [String], count: Int) -> [String] {
    var cards: [String] = []
    
    while cards.count < count {
        let index = Int.random(in: 0..<FULL_DECK.count)
        let card = FULL_DECK[index]
        if !cards.contains(card) && !withoutCards.contains(card) {
            cards.append(card)
        }
    }
    
    return cards
}
