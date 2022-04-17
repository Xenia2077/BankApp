//
//  BankApi.swift
//  BankApp
//
//  Created by Ксения Борисова on 16.04.2022.
//

import Foundation
import RealmSwift

enum BankError: Error {
    case insufficientFunds
}

enum OperationResult {
    case success, failure
}

protocol BankApi {
    func getBalance(for card: User.Card) -> Double
    func getOperations(for user: User) -> [Operation]
    
    func getCash(_ cash: Double, for user: User) -> BankError?
    func topUpPhone(amount: Double, for user: User) -> BankError?
    func topUpDeposite(amount: Double, for user: User) -> BankError?
    
    func check(pin: String, for user: User) -> OperationResult
}

class OurBankIncorporated: BankApi {
    
    private let realmDB = try! Realm()
    static let instance: OurBankIncorporated = OurBankIncorporated()
    private init() {}
    
    func getBalance(for card: User.Card) -> Double {
        guard let findedBalance = realmDB.object(ofType: BalanceModel.self, forPrimaryKey: card.id) else {
            return 0
        }
        return findedBalance.balance
    }
    
    func getCash(_ cash: Double, for user: User) -> BankError? {
        let balance = getBalance(for: user.card)
        guard balance >= cash else {
            return .insufficientFunds
        }
        update(balance: balance - cash, toCard: user.card.id)
        add(operation: Operation(id: user.id, kind: .writeOff, typeOf: .getCash, sum: cash, date: Date()))
        return nil
    }
    
    func topUpPhone(amount: Double, for user: User) -> BankError? {
        let balance = getBalance(for: user.card)
        guard balance >= amount else {
            return .insufficientFunds
        }
        update(balance: balance - amount, toCard: user.card.id)
        add(operation: Operation(id: user.id, kind: .writeOff, typeOf: .topUpPhoneNumber, sum: amount, date: Date()))
        return nil
    }
    
    func topUpDeposite(amount: Double, for user: User) -> BankError? {
        let balance = getBalance(for: user.card)
        update(balance: balance + amount, toCard: user.card.id) 
        add(operation: Operation(id: user.id, kind: .topUp, typeOf: .topUpDeposite, sum: amount, date: Date()))
        return nil
    }
    
    func check(pin: String, for user: User) -> OperationResult {
        guard !pin.isEmpty, user.card.pin == pin else {
            return .failure
        }
        return .success
    }
    
    func getOperations(for user: User) -> [Operation] {
        let realmOperations = realmDB.objects(OperationModel.self).filter { model -> Bool in
            return model.userId == user.id
        }
        let operations = realmOperations.map { operation -> Operation in
            return Operation(id: operation.userId, kind: operation.kind, typeOf: operation.typeOf, sum: operation.sum, date: operation.date)
        }
        return Array(operations)
    }
    
    func add(operation: Operation) {
        let persistedModel = OperationModel()
        persistedModel.userId = operation.id
        persistedModel.kind = operation.kind
        persistedModel.typeOf = operation.typeOf
        persistedModel.sum = operation.sum
        persistedModel.date = operation.date
        
        try! realmDB.write({
            realmDB.add(persistedModel)
        })
    }
    
    func update(balance: Double, toCard id: String) {
        if let findedBalance = realmDB.object(ofType: BalanceModel.self, forPrimaryKey: id) {
            try! realmDB.write({
                findedBalance.balance = balance
            })
        } else {
            let newBalance = BalanceModel()
            newBalance.balance = balance
            newBalance.cardId = id
            
            try! realmDB.write({
                realmDB.add(newBalance)
            })
        }
    }
    
}
