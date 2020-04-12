//
//  FactSummaryCell.swift
//  MyCountry
//
//  Created by Arinjoy Biswas on 11/4/20.
//  Copyright © 2020 Arinjoy Biswas. All rights reserved.
//

import UIKit
import SnapKit

final class FactSummaryCell: UITableViewCell {
    
    static let cellReuseIdentifier = "FactSummaryCell"
    static let approximateRowHeight: CGFloat = 120
    
    // MARK: - UI Element Properties
    
    private lazy var containerView: UIView = {
        let view = UIView()
        return view
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        label.textAlignment = .left
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var bodyLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.textAlignment = .left
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var thumbImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var titleAndImageStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.distribution = .fill
        stackView.alignment = .leading
        return stackView
    }()
    
    private lazy var fullStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.alignment = .top
        stackView.spacing = 8
        return stackView
    }()
    
    // MARK: - Lifecycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier ?? FactSummaryCell.cellReuseIdentifier)
        
        self.selectionStyle = UITableViewCell.SelectionStyle.none
        buildUIAndApplyConstraints()
        
        contentView.isAccessibilityElement = true
        
        containerView.backgroundColor = .clear
        contentView.backgroundColor = Theme.backgroundColor
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private Helpers
    
    private func buildUIAndApplyConstraints() {
        
        thumbImageView.snp.makeConstraints { make in
            // Maybe increase for iPad sizes / orientation changes via size class
            make.width.equalTo(UIScreen.main.bounds.width / 3)
            make.height.equalTo(UIScreen.main.bounds.width / 3 * 0.75)
        }
                
        titleAndImageStackView.addArrangedSubview(titleLabel)
        titleAndImageStackView.addArrangedSubview(thumbImageView)
                
        fullStackView.addArrangedSubview(titleAndImageStackView)
        fullStackView.addArrangedSubview(bodyLabel)
        
        containerView.addSubview(fullStackView)
        
        fullStackView.snp.makeConstraints { make in
            make.leading.equalTo(containerView.snp.leading).offset(16)
            make.trailing.equalTo(containerView.snp.trailing).offset(-16)
            make.top.equalTo(containerView.snp.top).offset(16)
            make.bottom.equalTo(containerView.snp.bottom).offset(-16)
        }
        
        contentView.addSubview(containerView)
        
        containerView.snp.makeConstraints { make in
            make.leading.equalTo(contentView.snp.leading).offset(8)
            make.trailing.equalTo(contentView.snp.trailing).offset(-8)
            make.top.equalTo(contentView.snp.top).offset(8)
            make.bottom.equalTo(contentView.snp.bottom).offset(-8)
        }
    }
}

// MARK: - Configurations

extension FactSummaryCell {
    
    func configure(withPresentationItem item: FactPresentationItem) {
        
        if let title = item.title {
            titleLabel.attributedText = title
            titleLabel.isHidden = false
        } else {
            titleLabel.isHidden = true
        }
        
        if let body = item.body {
            bodyLabel.attributedText = body
            bodyLabel.isHidden = false
        } else {
            bodyLabel.isHidden = true
        }
        
        // If image URL exists, then only show the image, else hide it.
        thumbImageView.isHidden = item.webImageUrl == nil
        
        // Image would be loaded later on, but may be `nil` image due to
        // some loading error due to incorrect URLs, 404 not found etc.
        // In those cases placeholder image will be shown.
        thumbImageView.image = UIImage(named: "placeholder")
        
        titleAndImageStackView.isHidden = titleLabel.isHidden && thumbImageView.isHidden
        
        if bodyLabel.isHidden {
            titleAndImageStackView.axis = .horizontal
            titleAndImageStackView.alignment = .center
        } else {
            titleAndImageStackView.axis = .vertical
            titleAndImageStackView.alignment = .leading
        }
    }
    
    func update(withImage image: UIImage?) {
        if let image = image {
            DispatchQueue.main.async {
                self.thumbImageView.image = image
            }
        }
    }
}
