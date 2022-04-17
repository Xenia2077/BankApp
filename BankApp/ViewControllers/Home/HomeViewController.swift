//
//  HomeViewController.swift
//  BankApp
//
//  Created by Ксения Борисова on 15.04.2022.
//

import UIKit

class HomeViewController: UIViewController {

    @IBOutlet private var getCashButton: UIButton?
    @IBOutlet private var topUpDepositButton: UIButton?
    @IBOutlet private var topUpPhoneBalance: UIButton?
    @IBOutlet private var balanceLabel: UILabel?
    @IBOutlet private var userNameLabel: UILabel?
    
    var bankApi: BankApi = OurBankIncorporated.instance
    var userRepository: UserRepository = RealmUserRepository.instance
    var user: User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        user = userRepository.getUser(by: "123")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        updateUI()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toPerformOperationSegue" {
            guard let vc = segue.destination as? PerformOperationViewController, let button = sender as? UIButton else {
                return
            }
            if button == getCashButton {
                vc.operation = .getCash
            } else if button == topUpPhoneBalance {
                vc.operation = .topUpPhoneNumber
            } else if button == topUpDepositButton {
                vc.operation = .topUpDeposite
            }
        }
    }
    
    private func updateUI() {
        guard let user = user else {
            return
        }
        
        let balance = bankApi.getBalance(for: user.card)
        balanceLabel?.text = "\(balance) ₽"
        userNameLabel?.text = user.name
    }
    
    @IBAction private func getCashButtonTouchUpInside(_ sender: UIButton) {
        performSegue(withIdentifier: "toPerformOperationSegue", sender: sender)
    }
    
    @IBAction private func topUpDepositButtonTouchUpInside(_ sender: UIButton) {
        performSegue(withIdentifier: "toPerformOperationSegue", sender: sender)
    }
    
    @IBAction private func topUpPhoneBalanceTouchUpInside(_ sender: UIButton) {
        performSegue(withIdentifier: "toPerformOperationSegue", sender: sender)
    }
}

