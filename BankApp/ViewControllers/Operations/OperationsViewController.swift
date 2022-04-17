//
//  OperationsViewController.swift
//  BankApp
//
//  Created by Ксения Борисова on 16.04.2022.
//

import UIKit

class OperationsViewController: UIViewController {

    @IBOutlet private var tableView: UITableView?
    
    private var bankApi: BankApi = OurBankIncorporated.instance
    private var userRepository: UserRepository = RealmUserRepository.instance
    
    var operations: [Operation] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView?.dataSource = self
        tableView?.delegate = self
        tableView?.rowHeight = UITableView.automaticDimension
        tableView?.register(
            UINib(nibName: "OperationTableViewCell", bundle: nil),
            forCellReuseIdentifier: "OperationTableViewCell"
        )
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        reloadOperations()
    }
    
    func reloadOperations() {
        guard let user = userRepository.getUser(by: "123") else {
            operations = []
            tableView?.reloadData()
            return
        }
        operations = bankApi.getOperations(for: user).sorted(by: { lhs, rhs -> Bool in
            return lhs.date > rhs.date
        })
        tableView?.reloadData()
        return
    }
    
}

extension OperationsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "OperationTableViewCell") as? OperationTableViewCell else {
            return UITableViewCell()
        }
        cell.configure(with: operations[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return operations.count
    }
    
}

extension OperationsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
}
