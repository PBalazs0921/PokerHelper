//
//  GameData.swift
//  PokerHelper
//
//  Created by Balázs Péter on 14/06/2024.
//  Copyright © 2024 Apple. All rights reserved.
//

import Foundation

class GameData{
    var handChances: [HandChance]
    var handCards: [Card]
    var boardCards: [Card]
    var count : Int
    
    init() {
        self.handChances = []
        self.handCards = []
        self.boardCards = []
        self.count = 0
    }
    
    private func updateData(handStats: PokerHandStats){
        self.handChances=handStats.handChances
        self.handCards=generateCards(from: handStats.hand)
    }
    func calculateOnlyHand(card1: String, card2: String){
        //store
        self.handCards=generateCards(from: [card1,card2])

        var temphc = calculateOdds(card1: handCards[0].code, card2: handCards[1].code, board: [])
        self.handChances = temphc!.handChances
        self.count=temphc!.count
        
        //updatepercentages
        // Update percentages
        for i in 0..<handChances.count {
            // The API returns chances, we need percentages, conversion:
            if self.count > 0 {
                print("szazalek")
                print(handChances[i].count)
                print(self.count)
                handChances[i].percentage = (Double(handChances[i].count) / Double(self.count)) * 100.0
            } else {
                handChances[i].percentage = 0
            }
        }
    }
    func calculateWithBoard( inputboard: [String]){
        handCards=generateCards(from: ["Ah","As"])
        self.boardCards = generateCards(from: inputboard)
        if handCards.isEmpty == false{
            //We have cards in hand, can calculate board
            let temphc = calculateOdds(card1: handCards[0].code, card2: handCards[1].code, board: inputboard)
            self.handChances = temphc!.handChances
            self.count = temphc!.count
            for i in 0..<handChances.count {
                // The API returns chances, we need percentages, conversion:
                if self.count > 0 {
                    print("szazalek")
                    print(handChances[i].count)
                    print(self.count)
                    handChances[i].percentage = (Double(handChances[i].count) / Double(self.count)) * 100.0
                } else {
                    handChances[i].percentage = 0
                }
            }
        } else{
            
            
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

    func printString(){
        
        
    }
}

