//
//  Card.swift
//  BreakfastFinder
//
//  Created by Balázs Péter on 27/05/2024.
//  Copyright © 2024 Apple. All rights reserved.
//

import Foundation

class Card:Codable {
    let code: String
    //need to add an image for the UI
    
    init(code: String) {
        self.code = code
    }
    
    var description: String {
        // Return a string representation of your class
        return code // You can customize this based on the properties and state of your class
    }
}
