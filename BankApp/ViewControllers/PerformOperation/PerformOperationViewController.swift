//
//  PerformOperationViewController.swift
//  BankApp
//
//  Created by Ксения Борисова on 16.04.2022.
//

import UIKit

class PerformOperationViewController: UIViewController {
    
    var operation: Operation.TypeOf = .undefined
    
    @IBOutlet private var operationTypeLabel: UILabel?
    @IBOutlet private var balanceLabel: UILabel?
    @IBOutlet private var inputTextField: UITextField?
    @IBOutlet private var confirmationButton: UIButton?
    @IBOutlet private var cancelButton: UIButton?
    
    private var bankApi: BankApi = OurBankIncorporated.instance
    private var userRepository: UserRepository = RealmUserRepository.instance
    private var user: User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        confirmationButton?.isEnabled = false
        view.addGestureRecognizer(
            UITapGestureRecognizer(
                target: self,
                action: #selector(tapGestureRecognized(_:))
            )
        )
        
        user = userRepository.getUser(by: "123")
        updateUI()
    }
    
    private func updateUI() {
        guard let user = user else {
            return
        }
        
        let balance = bankApi.getBalance(for: user.card)
        balanceLabel?.text = "\(balance) ₽"
        
        switch operation {
        case .getCash:
            operationTypeLabel?.text = "Снятие наличных"
        case .topUpDeposite:
            operationTypeLabel?.text = "Пополнение счета"
        case .topUpPhoneNumber:
            operationTypeLabel?.text = "Пополнение счета мобильного телефона"
        case .undefined:
            operationTypeLabel?.text = ""
        }
    }
    
    @objc private func tapGestureRecognized(_ gestureRecognizer: UITapGestureRecognizer) {
        inputTextField?.resignFirstResponder()
    }
    
    @IBAction private func textFieldDidEdit(_ sender: UITextField) {
        guard let value = sender.text, !value.isEmpty else {
            confirmationButton?.isEnabled = false
            return
        }
        confirmationButton?.isEnabled = true
    }
    
    @IBAction private func confirmationButtonTouchUpInside(_ sender: UIButton) {
        guard let value = inputTextField?.text,
              !value.isEmpty,
              let amount = Double(value),
              let user = user
        else {
            return
        }
        
        switch operation {
        case .getCash:
            getCash(amount: amount, for: user)
        case .topUpDeposite:
             topUpDeposite(amount: amount, for: user)
        case .topUpPhoneNumber:
            topUpPhoneNumber(amount: amount, for: user)
        case .undefined:
            return
        }
    }
    
    @IBAction private func cancelButtonTouchUpInside(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    private func getCash(amount: Double, for user: User) {
        guard let error = bankApi.getCash(amount, for: user) else {
            updateUI()
            return
        }
        processingError(error)
    }
    
    private func topUpDeposite(amount: Double, for user: User) {
        guard let error = bankApi.topUpDeposite(amount: amount, for: user) else {
            updateUI()
            return
        }
        processingError(error)
    }
    
    private func topUpPhoneNumber(amount: Double, for user: User) {
        guard let error = bankApi.topUpPhone(amount: amount, for: user) else {
            updateUI()
            return
        }
        processingError(error)
    }
    
    private func processingError(_ error: BankError) {
        switch error {
        case .insufficientFunds:
            let alert = UIAlertController(title: "Ошибка", message: "Недостаточно средств на счете", preferredStyle: .alert)
            alert.addAction(UIAlertAction.init(title: "Закрыть", style: .destructive, handler: nil))
            present(alert, animated: true, completion: nil)
        }
    }
    
}
