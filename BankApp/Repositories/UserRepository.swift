//
//  UserRepository.swift
//  BankApp
//
//  Created by Ксения Борисова on 16.04.2022.
//

import Foundation
import RealmSwift

protocol UserRepository {
    
    func getUser(by id: String) -> User?
    
}

class RealmUserRepository: UserRepository {
    
    private let realmDB = try! Realm()
    static let instance: RealmUserRepository = RealmUserRepository()
    private init() {}
    
    func getUser(by id: String) -> User? {
        guard let findedUser = realmDB.objects(UserRealmModel.self).filter({ $0.id == id }).first, let card = findedUser.card else {
            return nil
        }
        
        return User(
            id: findedUser.id,
            name: findedUser.name,
            card: User.Card(
                id: card.id,
                pin: card.pin),
            phoneNumber: findedUser.phoneNumber
        )
    }
    
    func add(user: User) {
        let userModel = UserRealmModel()
        userModel.id = user.id
        userModel.name = user.name
        userModel.phoneNumber = user.phoneNumber
        
        let cardModel = CardRealmModel()
        cardModel.id = user.card.id
        cardModel.pin = user.card.pin
        
        userModel.card = cardModel
        
        try! realmDB.write {
            realmDB.add(userModel)
        }
    }
    
}
