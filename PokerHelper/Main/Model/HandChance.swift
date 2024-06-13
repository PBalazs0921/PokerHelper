//
//  HandChance.swift
//  PokerHelper
//
//  Created by Balázs Péter on 06/06/2024.
//  Copyright © 2024 Apple. All rights reserved.
//

import Foundation

class HandChance: Codable {
    var name: String
    var count: Int
    var percentage: Double?
    
    init(name: String, count: Int) {
        self.name = name
        self.count = count
    }
    
    //The API returns chances, we need percentages, conversion:
    func calculatePercentage(totalIterations: Int) {
        guard totalIterations > 0 else {
            self.percentage = 0
            return
        }
        self.percentage = (Double(count) / Double(totalIterations)) * 100.0
    }
    
    func toString()-> String{
        let percentageString = String(format: "%.2f", self.percentage ?? 0.0)
        return "\(name): \(percentageString)%"
    }
}
