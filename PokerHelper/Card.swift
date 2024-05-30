//
//  Card.swift
//  BreakfastFinder
//
//  Created by Balázs Péter on 27/05/2024.
//  Copyright © 2024 Apple. All rights reserved.
//

import Foundation

class Card {
    let code: String
    let color: String?
    let value: String?
    //need to add an image for the UI
    
    init(code: String, color: String?, value: String?) {
        self.code = code
        self.color = color
        self.value = value
    }
    
    var description: String {
        // Return a string representation of your class
        return code // You can customize this based on the properties and state of your class
    }
}
