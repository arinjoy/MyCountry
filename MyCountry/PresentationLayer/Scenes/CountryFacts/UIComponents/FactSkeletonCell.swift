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
    
    private lazy var label4: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.isSkeletonable = true
        label.linesCornerRadius = 10
        return label
    }()
    
    private lazy var label5: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.isSkeletonable = true
        label.linesCornerRadius = 10
        return label
    }()
    
    // MARK: - Constants
    
    private enum Constants {
        static let imageWidth: CGFloat = UIScreen.main.bounds.width / 3
        static let imageHeight: CGFloat = Constants.imageWidth * 3/4
    }
    
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
        label1.text = "some title or name"
        label2.text = "The body of the facts to show"
        label3.text = "The body of the facts to show"
        label4.text = "The body of the facts to show"
        label5.text = "The body"
        
        thumbImageView.snp.makeConstraints { make in
            // Maybe increase for iPad sizes / orientation changes via size class
            make.width.equalTo(Constants.imageWidth)
            make.height.equalTo(Constants.imageHeight)
        }
        
        let leftStackView = UIStackView()
        leftStackView.axis = .vertical
        leftStackView.alignment = .leading
        leftStackView.spacing = 14
        leftStackView.isSkeletonable = true
        leftStackView.addArrangedSubview(label1)
        leftStackView.addArrangedSubview(thumbImageView)
        
        label1.snp.makeConstraints { make in
            make.width.equalTo(thumbImageView.snp.width)
        }
        
        let rightStackView = UIStackView()
        rightStackView.axis = .vertical
        rightStackView.alignment = .leading
        rightStackView.spacing = 10
        rightStackView.isSkeletonable = true
        rightStackView.addArrangedSubview(label2)
        rightStackView.addArrangedSubview(label3)
        rightStackView.addArrangedSubview(label4)
        rightStackView.addArrangedSubview(label5)
        
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .top
        stackView.distribution = .fillProportionally
        stackView.spacing = 20
        stackView.isSkeletonable = true
        
        stackView.addArrangedSubview(leftStackView)
        stackView.addArrangedSubview(rightStackView)
        
        contentView.addSubview(stackView)
        
        stackView.snp.makeConstraints { make in
            make.leading.equalTo(contentView.snp.leading).offset(16)
            make.trailing.equalTo(contentView.snp.trailing).offset(-16)
            make.centerY.equalTo(contentView.snp.centerY)
        }
        
        contentView.snp.makeConstraints { make in
            make.height.equalTo(24 + 12 + Constants.imageHeight + 8 + 8)
        }
    }
}
