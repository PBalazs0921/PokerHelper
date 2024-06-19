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
    

    
    func toString()-> String{
        let percentageString = String(format: "%.2f", self.percentage ?? 0.0)
        return "\(name): \(percentageString)%"
    }
}
