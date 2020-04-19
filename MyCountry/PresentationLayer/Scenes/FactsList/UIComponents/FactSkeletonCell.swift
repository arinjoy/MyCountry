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
        static let screenWidth: CGFloat = UIScreen.main.bounds.width
        
        static let imageWidth: CGFloat = UIDevice.current.isIPhone ? Constants.screenWidth / 3 : Constants.screenWidth / 4
        static let imageHeight: CGFloat = Constants.imageWidth * 3/4
        
        static let cellMargin: CGFloat = UIDevice.current.isIPhone ? 16 : 32
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
        
        thumbImageView.snp.makeConstraints { make in
            make.width.equalTo(Constants.imageWidth)
            make.height.equalTo(Constants.imageHeight)
        }
        
        let leftStackView = UIStackView()
        leftStackView.axis = .vertical
        leftStackView.alignment = .fill
        leftStackView.spacing = 16
        leftStackView.isSkeletonable = true
        leftStackView.addArrangedSubview(label1)
        leftStackView.addArrangedSubview(thumbImageView)
        
        label1.snp.makeConstraints { make in
            make.width.equalTo(thumbImageView.snp.width)
        }
        label1.text = String(repeating: " ", count: 150)
        
        let rightStackView = UIStackView()
        rightStackView.axis = .vertical
        rightStackView.alignment = .leading
        rightStackView.spacing = 16
        rightStackView.isSkeletonable = true
        rightStackView.addArrangedSubview(label2)
        rightStackView.addArrangedSubview(label3)
        rightStackView.addArrangedSubview(label4)
        rightStackView.addArrangedSubview(label5)
        
        label2.text = String(repeating: " ", count: 300)
        label3.text = String(repeating: " ", count: 300)
        label4.text = String(repeating: " ", count: 300)
        label5.text = String(repeating: " ", count: 150)
        
        label5.snp.makeConstraints { make in
            make.width.equalTo(rightStackView.snp.width).dividedBy(2)
        }

        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .top
        stackView.distribution = .fillProportionally
        stackView.spacing = 16
        stackView.isSkeletonable = true
        
        stackView.addArrangedSubview(leftStackView)
        stackView.addArrangedSubview(rightStackView)
        
        rightStackView.snp.makeConstraints { make in
            make.width.equalTo(stackView.snp.width).offset(-(Constants.imageWidth + 16))
        }
        
        contentView.addSubview(stackView)
        
        stackView.snp.makeConstraints { make in
            make.leading.equalTo(contentView.snp.leading).offset(Constants.cellMargin)
            make.trailing.equalTo(contentView.snp.trailing).offset(-Constants.cellMargin).priority(999)
            make.top.equalTo(contentView.snp.top).offset(Constants.cellMargin)
            make.bottom.equalTo(contentView.snp.bottom).offset(-Constants.cellMargin).priority(999)
        }
    }
}
