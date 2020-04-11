//
//  FactsListViewController.swift
//  MyCountry
//
//  Created by Arinjoy Biswas on 10/4/20.
//  Copyright © 2020 Arinjoy Biswas. All rights reserved.
//

import UIKit
import SnapKit

final class FactsListViewController: UIViewController, FactsListDisplay {

    // MARK: - View Properties
    
    private lazy var tableView: UITableView = {
       let tableView = UITableView(frame: self.view.bounds, style: .grouped)
        return tableView
    }()
    
    private lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.tintColor = Theme.tintColor
        return refreshControl
    }()
    
    // MARK: - Presenter
    
    /// The presenter conforming to the `FactsListPresenting`
    private lazy var presenter: FactsListPresenting = {
        
        /**
         Tech note:
         A chain of depdendency injection layer by layer, and each layer is individually unit tested
         Ideally this depdendency injection can be done via 3rd party library like `Swinject`
         */
        
        let presenter = FactsListPresenter(interactor:
            FactsInteractor(
                factsFindingService: FactsFindingServiceClient(
                    dataSource: HTTPClient()
                )
            )
        )
        presenter.display = self
        return presenter
    }()
    
    private lazy var listDataSource: FactsListDataSource = {
        return FactsListDataSource()
    }()
    
    // MARK: - Lifecyle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        buildUIAndApplyConstraints()
        configureTableView()
        
        presenter.loadFacts(isRereshingNeeded: true)
    }
    
    // MARK: - Private Helpers
    
    private func configureTableView() {
        tableView.backgroundColor = Theme.backgroundColor
        tableView.register(FactSummaryCell.self, forCellReuseIdentifier: FactSummaryCell.cellReuseIdentifier)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 120
        tableView.separatorStyle = .singleLine
        tableView.separatorColor = Theme.tintColor
        
        tableView.dataSource = self
        
        tableView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(refreshCountryData), for: .valueChanged)
    }
    
    private func buildUIAndApplyConstraints() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.topMargin).offset(10)
            make.leading.equalTo(view.snp.leading).offset(16)
            make.trailing.equalTo(view.snp.trailing).offset(-16)
            make.bottom.equalTo(view.snp.bottom).offset(-16)
        }
    }
    
    @objc
    private func refreshCountryData() {
        presenter.loadFacts(isRereshingNeeded: true)
    }
}

// MARK: - UITableViewDataSource

extension FactsListViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return listDataSource.numberOfSections()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listDataSource.numberOfItems(inSection: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard
            let item = listDataSource.item(atIndexPath: indexPath),
            let cell = tableView.dequeueReusableCell(withIdentifier: FactSummaryCell.cellReuseIdentifier) as? FactSummaryCell
        else {
            return UITableViewCell()
        }
        cell.configure(withPresentationItem: item)
        return cell
    }
}

// MARK: - FactsListDisplay

extension FactsListViewController {
    
    func setTitle(_ title: String) {
       navigationItem.title = title
    }
    
    func setFactsListDataSource(_ dataSource: FactsListDataSource) {
        listDataSource = dataSource
        tableView.reloadData()
    }
    
    func showLoadingIndicator() {
        refreshControl.beginRefreshing()
        // TODO: show full screen loader
    }
    
    func hideLoadingIndicator() {
        refreshControl.endRefreshing()
        // TODO: hide full screen loader
    }
    
    func showError(title: String, message: String, dismissTitle: String) {
        // TODO: handle with alert or better UIs
    }
}
