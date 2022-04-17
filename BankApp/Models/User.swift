//
//  UserModel.swift
//  BankApp
//
//  Created by Ксения Борисова on 16.04.2022.
//

import Foundation

class User {
    
    class Card {
        let id: String
        let pin: String
        
        init(id: String, pin: String) {
            self.id = id
            self.pin = pin
        }
    }

    
    let id: String
    let name: String
    let card: Card
    let phoneNumber: String
    
    init(
        id: String,
        name: String,
        card: Card,
        phoneNumber: String
    ) {
        self.id = id
        self.name = name
        self.card = card
        self.phoneNumber = phoneNumber
    }
}
