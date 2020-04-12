//
//  FactSkeletonCell.swift
//  MyCountry
//
//  Created by Arinjoy Biswas on 12/4/20.
//  Copyright © 2020 Arinjoy Biswas. All rights reserved.
//

import Foundation
import UIKit
import SkeletonView

final class FactSkeletonCell: UITableViewCell {
    
    static let cellReuseIdentifier = "FactSkeletonCell"
    
    // MARK: - UI Element Properties
    
    private lazy var thumbImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "placeholder")
        imageView.isSkeletonable = true
        return imageView
    }()
    
    private lazy var label1: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.isSkeletonable = true
        label.linesCornerRadius = 10
        return label
    }()
        
    private lazy var label2: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.isSkeletonable = true
        label.linesCornerRadius = 10
        return label
    }()
    
    private lazy var label3: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.isSkeletonable = true
        label.linesCornerRadius = 10
        return label
    }()
    
    // MARK: - Lifecycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier ?? FactSkeletonCell.cellReuseIdentifier)
        
        isSkeletonable = true
        contentView.isSkeletonable = true
        
        buildUIAndApplyConstraints()
        
        contentView.backgroundColor = Theme.backgroundColor
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private Helpers
    
    private func buildUIAndApplyConstraints() {
        label1.text = "some title or name of a fact"
        label2.text = "The body of the facts to show"
        label3.text = "The body of the facts to show"
        
        thumbImageView.snp.makeConstraints { make in
            // Maybe increase for iPad sizes / orientation changes via size class
            make.width.equalTo(UIScreen.main.bounds.width / 3)
            make.height.equalTo(UIScreen.main.bounds.width / 3 * 0.75)
        }
        
        let innerStackView = UIStackView()
        innerStackView.axis = .vertical
        innerStackView.spacing = 12
        innerStackView.isSkeletonable = true
        innerStackView.addArrangedSubview(label1)
        innerStackView.addArrangedSubview(label2)
        innerStackView.addArrangedSubview(label3)
        
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .fill
        stackView.spacing = 20
        stackView.isSkeletonable = true
        
        stackView.addArrangedSubview(thumbImageView)
        stackView.addArrangedSubview(innerStackView)
        
        contentView.addSubview(stackView)
        
        stackView.snp.makeConstraints { make in
            make.leading.equalTo(contentView.snp.leading).offset(16)
            make.top.equalTo(contentView.snp.top).offset(8)
            make.trailing.equalTo(contentView.snp.trailing).offset(-16)
            make.bottom.equalTo(contentView.snp.bottom).offset(8)
        }
        
        contentView.snp.makeConstraints { make in
            make.height.equalTo(UIScreen.main.bounds.width / 3 * 0.75 + 8 + 8)
        }
    }
}
