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
    static let approximateRowHeight: CGFloat = 100
    
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
    
    private lazy var thumbImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .clear
        imageView.image = UIImage(named: "placeholder")
        return imageView
    }()
    
    private let bodyLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.textAlignment = .left
        label.numberOfLines = 0
        return label
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
            make.width.equalTo(100)
            make.height.equalTo(80)
        }
                
        let titleAndImageStackView = UIStackView()
        titleAndImageStackView.axis = .vertical
        titleAndImageStackView.spacing = 20
        titleAndImageStackView.distribution = .fill
        titleAndImageStackView.alignment = .leading
        
        titleAndImageStackView.addArrangedSubview(titleLabel)
        titleAndImageStackView.addArrangedSubview(thumbImageView)
        
        let fullStackView = UIStackView()
        fullStackView.axis = .horizontal
        fullStackView.distribution = .fill
        fullStackView.alignment = .top
        fullStackView.spacing = 8
        
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

// MARK: - Configuration via Presentation item

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
        
        
        if let webImageUrl = item.webImageUrl {
            
            // TODO: load the image async and attach
            
            thumbImageView.isHidden = false
        } else {
            thumbImageView.isHidden = true
        }
    }
}
