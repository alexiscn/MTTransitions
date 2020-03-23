//
//  TransitionsPickerViewController.swift
//  MTTransitionsDemo
//
//  Created by xushuifeng on 2020/3/23.
//  Copyright © 2020 xu.shuifeng. All rights reserved.
//

import UIKit
import MTTransitions

class TransitionsPickerViewController: UIViewController {

    var selectionUpdated: ((MTTransition.Effect) -> Void)?
    
    private var dataSource: [MTTransition.Effect] = MTTransition.Effect.allCases
    
    private var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupSubviews()
    }
    
    private func setupSubviews() {
        tableView = UITableView(frame: .zero)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableFooterView = UIView()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: NSStringFromClass(UITableViewCell.self))
        view.addSubview(tableView)
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            tableView.topAnchor.constraint(equalTo: self.view.topAnchor),
            tableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        ])
    }
}

extension TransitionsPickerViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let effect = dataSource[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: NSStringFromClass(UITableViewCell.self), for: indexPath)
        cell.textLabel?.text = effect.description
        return cell
    }
}

extension TransitionsPickerViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        
        let effect = dataSource[indexPath.row]
        selectionUpdated?(effect)
        dismiss(animated: true, completion: nil)
    }
    
}
