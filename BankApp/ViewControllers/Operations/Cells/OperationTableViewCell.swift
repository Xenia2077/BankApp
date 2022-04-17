//
//  OperationTableViewCell.swift
//  BankApp
//
//  Created by Ксения Борисова on 16.04.2022.
//

import UIKit

class OperationTableViewCell: UITableViewCell {
    
    @IBOutlet private var operationTitleLabel: UILabel?
    @IBOutlet private var amountLabel: UILabel?
    @IBOutlet private var dateLabel: UILabel?
    @IBOutlet private var dollarSignImageView: UIImageView?
    
    func configure(with operation: Operation) {
        var kind = ""
        switch operation.kind {
        case .topUp:
            kind = "Пополнение"
            dollarSignImageView?.tintColor = .green
        case .writeOff:
            kind = "Списание"
            dollarSignImageView?.tintColor = .red
        }
        
        var typeOf = ""
        switch operation.typeOf {
        case .getCash:
            typeOf = "снятие наличных"
        case .topUpDeposite:
            typeOf = "пополнение счета"
        case .topUpPhoneNumber:
            typeOf = "оплата мобильного телефона"
        case .undefined:
            typeOf = "другое"
        }
        operationTitleLabel?.text = kind + ": " + typeOf
        amountLabel?.text = "\(operation.sum) ₽"
        dateLabel?.text = convert(date: operation.date)
    }
    
    private func convert(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        return dateFormatter.string(from: date)
    }
    
}
