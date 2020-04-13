//
//  FactsListViewController.swift
//  MyCountry
//
//  Created by Arinjoy Biswas on 10/4/20.
//  Copyright © 2020 Arinjoy Biswas. All rights reserved.
//

import UIKit
import SnapKit
import SkeletonView

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
    
    // MARK: - Helper private properties
    
    private lazy var skeletonGradient: SkeletonGradient = {
        return SkeletonGradient(baseColor: Theme.shimmerBaseColor,
                                secondaryColor: Theme.shimmerGradientColor)
    }()
    
    private lazy var skeletonAnimation: SkeletonLayerAnimation = {
        return SkeletonAnimationBuilder().makeSlidingAnimation(withDirection: .leftRight)
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
                factsFindingService: FactsFindingServiceClient(dataSource: HTTPClient())
            )
        )
        presenter.display = self
        return presenter
    }()
    
    // MARK: - Lifecyle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        buildUIAndApplyConstraints()
        configureTableView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        presenter.loadFacts(isRereshingNeeded: true)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        tableView.layoutSkeletonIfNeeded()
    }
    
    // MARK: - Private Helpers
    
    private func configureTableView() {
        tableView.backgroundColor = Theme.backgroundColor
        tableView.register(FactSummaryCell.self, forCellReuseIdentifier: FactSummaryCell.cellReuseIdentifier)
        tableView.estimatedRowHeight = FactSummaryCell.approximateRowHeight
        tableView.separatorStyle = .none
        
        tableView.dataSource = self
        tableView.prefetchDataSource = self
        tableView.delegate = self
        
        tableView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(refreshCountryData), for: .valueChanged)
        
        tableView.register(FactSkeletonCell.self, forCellReuseIdentifier: FactSkeletonCell.cellReuseIdentifier)
        tableView.isSkeletonable = true
    }
    
    private func buildUIAndApplyConstraints() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.topMargin).offset(10)
            make.leading.equalTo(view.snp.leading)
            make.trailing.equalTo(view.snp.trailing)
            make.bottom.equalTo(view.snp.bottom).offset(-16)
        }
    }
    
    @objc
    private func refreshCountryData() {
        presenter.loadFacts(isRereshingNeeded: true)
    }
    
    private func showLoadingShimmers() {
        tableView.showAnimatedGradientSkeleton(usingGradient: skeletonGradient,
                                               animation: skeletonAnimation,
                                               transition: .crossDissolve(0.25))
    }
    
    private func hideLoadingShimmers() {
        tableView.hideSkeleton()
    }
}

// MARK: - FactsListDisplay

extension FactsListViewController {
    
    func setTitle(_ title: String) {
       navigationItem.title = title
    }
    
    func updateList() {
        tableView.reloadData()
    }
    
    func showLoadingIndicator() {
        refreshControl.beginRefreshing()
        showLoadingShimmers()
    }
    
    func hideLoadingIndicator() {
        if refreshControl.isRefreshing {
            refreshControl.endRefreshing()
        }

        hideLoadingShimmers()
    }
    
    func showError(title: String, message: String, dismissTitle: String) {
        let alertController = UIAlertController(
            title: title,
            message: message,
            preferredStyle: UIAlertController.Style.alert)
        
        alertController.addAction(
            UIAlertAction(title: dismissTitle, style: .cancel))
        
        present(alertController, animated: true, completion: nil)
    }
}

// MARK: - UITableViewDataSource

extension FactsListViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return presenter.factsListDataSource.numberOfSections()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.factsListDataSource.numberOfItems(inSection: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard
            let item = presenter.factsListDataSource.item(atIndexPath: indexPath),
            let cell = tableView.dequeueReusableCell(withIdentifier: FactSummaryCell.cellReuseIdentifier) as? FactSummaryCell
        else {
            return UITableViewCell()
        }
        cell.configure(withPresentationItem: item)        
        return cell
    }
}

// MARK: - UITableViewDataSourcePrefetching

extension FactsListViewController: UITableViewDataSourcePrefetching {

    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        for indexPath in indexPaths {
            presenter.addImageLoadOperation(atIndexPath: indexPath, updateCellClosure: nil)
        }
    }

    func tableView(_ tableView: UITableView, cancelPrefetchingForRowsAt indexPaths: [IndexPath]) {
        for indexPath in indexPaths {
            presenter.removeImageLoadOperation(atIndexPath: indexPath)
        }
    }
}

extension FactsListViewController: SkeletonTableViewDataSource {

    func numSections(in collectionSkeletonView: UITableView) -> Int {
        return 1
    }

    func collectionSkeletonView(_ skeletonView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 8
    }

    func collectionSkeletonView(_ skeletonView: UITableView, cellIdentifierForRowAt indexPath: IndexPath) -> ReusableCellIdentifier {
        return FactSkeletonCell.cellReuseIdentifier
    }
}

// MARK: - UITableViewDelegate

extension FactsListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let cell = cell as? FactSummaryCell else { return }
        
        let updateCellClosure: (UIImage?) -> Void = { [unowned self] image in
            cell.update(withImage: image)
            self.presenter.removeImageLoadOperation(atIndexPath: indexPath)
        }
        
        if let loadedImage = presenter.handleImageLoadOperation(forIndexPath: indexPath, updateCellClosure: updateCellClosure) {
            cell.update(withImage: loadedImage)
        }
    }
    
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        presenter.removeImageLoadOperation(atIndexPath: indexPath)
    }
}
