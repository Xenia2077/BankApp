//
//  Operation.swift
//  BankApp
//
//  Created by Ксения Борисова on 16.04.2022.
//

import Foundation
import RealmSwift

class Operation {
    
    enum Kind: String, PersistableEnum {
        case topUp, writeOff
    }
    
    enum TypeOf: String, PersistableEnum {
        case topUpDeposite, topUpPhoneNumber, getCash, undefined
    }
    
    var id: String
    var kind: Kind
    var typeOf: TypeOf
    var sum: Double
    var date: Date
    
    init(id: String, kind: Kind, typeOf: TypeOf, sum: Double, date: Date) {
        self.id = id
        self.kind = kind
        self.typeOf = typeOf
        self.sum = sum
        self.date = date
    }
    
}
