//
//  MyCountryViewController.swift
//  MyCountry
//
//  Created by Arinjoy Biswas on 10/4/20.
//  Copyright © 2020 Arinjoy Biswas. All rights reserved.
//

import UIKit
import SnapKit

final class MyCountryViewController: UIViewController {
    
    // MARK: - View Properties
    
    private var tableView: UITableView!
    private let refreshControl = UIRefreshControl()

    // MARK: - Lifecyle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        buildUIAndApplyConstraints()
        configureTableView()
    }
    
    // MARK: - Private Helpers
    
    private func configureTableView() {
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 90
        tableView.separatorStyle = .singleLine
        
        tableView.dataSource = self
        
        tableView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(refreshCountryData), for: .valueChanged)
    }
    
    private func buildUIAndApplyConstraints() {
        tableView = UITableView(frame: self.view.bounds, style: .plain)
        view.addSubview(tableView)
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.topMargin).offset(40)
            make.leading.equalTo(view.snp.leading).offset(16)
            make.trailing.equalTo(view.snp.trailing).offset(-16)
            make.bottom.equalTo(view.snp.bottom).offset(-16)
        }
    }
    
    @objc
    private func refreshCountryData() {
        // TODO: Refresh data via presenter
    }
}

// MARK: - UITableViewDataSource

extension MyCountryViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // TODO: Make custom cell, deque and configure with dynamic data received
        // Pass in presentation item to cell to configure
        
        let cell = UITableViewCell()
        cell.textLabel?.text = "title"
        cell.detailTextLabel?.text = "description"
        return cell
    }
}
