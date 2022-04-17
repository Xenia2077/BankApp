//
//  UserRealmModel.swift
//  BankApp
//
//  Created by Ксения Борисова on 17.04.2022.
//

import RealmSwift

class UserRealmModel: Object {
    @Persisted(primaryKey: true) var id: String
    @Persisted var name: String = ""
    @Persisted var card: CardRealmModel?
    @Persisted var phoneNumber: String = ""
}

class CardRealmModel: Object {
    @Persisted(primaryKey: true) var id: String
    @Persisted var pin: String = ""
}

class OperationModel: Object {
    @Persisted var userId: String
    @Persisted var sum: Double
    @Persisted var date: Date
    @Persisted var kind: Operation.Kind = Operation.Kind.writeOff
    @Persisted var typeOf: Operation.TypeOf = Operation.TypeOf.undefined
}

class BalanceModel: Object {
    @Persisted(primaryKey: true) var cardId: String
    @Persisted var balance: Double
}
