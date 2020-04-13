//
//  FactSummaryCell.swift
//  MyCountry
//
//  Created by Arinjoy Biswas on 11/4/20.
//  Copyright © 2020 Arinjoy Biswas. All rights reserved.
//

import UIKit
import SnapKit
import SkeletonView

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
        label.font = Theme.titleFont
        label.textAlignment = .left
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var bodyLabel: UILabel = {
        let label = UILabel()
        label.font = Theme.bodyFont
        label.textAlignment = .left
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var thumbImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.isSkeletonable = true
        return imageView
    }()
    
    private lazy var titleAndImageStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 20
        stackView.distribution = .fill
        stackView.alignment = .center
        return stackView
    }()
    
    private lazy var fullStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.alignment = .center
        stackView.spacing = 20
        return stackView
    }()
    
    // MARK: - Constants
    
    private enum Constants {
        static let screenWidth: CGFloat = UIScreen.main.bounds.width
        
        static let imageWidth: CGFloat = UIDevice.current.isIPhone ? Constants.screenWidth / 4 : Constants.screenWidth / 3
        static let imageHeight: CGFloat = Constants.imageWidth * 3/4
        
        static let cellMargin: CGFloat = UIDevice.current.isIPhone ? 16 : 32
    }
    
    // MARK: - Helper private properties
    
    private func applyContainerStyle() {
        Shadow(color: Theme.primaryTextColor,
               opacity: 0.3,
               blur: 4,
               offset: CGSize(width: 0, height: 2))
            .apply(toView: containerView)
        containerView.layer.cornerRadius = 8.0
    }
    
    private lazy var skeletonGradient: SkeletonGradient = {
        return SkeletonGradient(baseColor: Theme.shimmerBaseColor,
                                secondaryColor: Theme.shimmerGradientColor)
    }()
    
    private lazy var skeletonAnimation: SkeletonLayerAnimation = {
        return SkeletonAnimationBuilder().makeSlidingAnimation(withDirection: .leftRight)
    }()
    
    // MARK: - Lifecycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier ?? FactSummaryCell.cellReuseIdentifier)
        
        self.selectionStyle = UITableViewCell.SelectionStyle.none
        
        contentView.backgroundColor = Theme.darkerBackgroundColor
        containerView.backgroundColor = Theme.backgroundColor
        
        buildUIAndApplyConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        showImageLoadingShimmer()
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        
        if traitCollection.horizontalSizeClass == .regular && traitCollection.verticalSizeClass == .regular {
            titleAndImageStackView.axis = .horizontal
        } else {
            titleAndImageStackView.axis = .vertical
        }
    }
    
    // MARK: - Private Helpers
    
    private func buildUIAndApplyConstraints() {
        
        thumbImageView.snp.makeConstraints { make in
            make.width.equalTo(Constants.imageWidth)
            make.height.equalTo(Constants.imageHeight)
        }
                
        titleAndImageStackView.addArrangedSubview(titleLabel)
        titleAndImageStackView.addArrangedSubview(thumbImageView)
                
        fullStackView.addArrangedSubview(titleAndImageStackView)
        fullStackView.addArrangedSubview(bodyLabel)
        
        containerView.addSubview(fullStackView)
        
        fullStackView.snp.makeConstraints { make in
            make.leading.equalTo(containerView.snp.leading).offset(Constants.cellMargin)
            make.trailing.equalTo(containerView.snp.trailing).offset(-Constants.cellMargin)
            make.top.equalTo(containerView.snp.top).offset(Constants.cellMargin)
            make.bottom.equalTo(containerView.snp.bottom).offset(-Constants.cellMargin)
        }
        
        contentView.addSubview(containerView)
        
        containerView.snp.makeConstraints { make in
            make.leading.equalTo(contentView.snp.leading).offset(Constants.cellMargin)
            make.trailing.equalTo(contentView.snp.trailing).offset(-Constants.cellMargin)
            make.top.equalTo(contentView.snp.top).offset(Constants.cellMargin / 2)
            make.bottom.equalTo(contentView.snp.bottom).offset(-Constants.cellMargin / 2)
        }
    }
    
    private func showImageLoadingShimmer() {
        // Image would be loaded later on, but may be `nil` image due to
        // some loading error due to incorrect URLs, 404 not found etc.
        // In those cases placeholder image will be shown.
        
        thumbImageView.showAnimatedGradientSkeleton(usingGradient: skeletonGradient,
                                                    animation: skeletonAnimation,
                                                    transition: .crossDissolve(0.25))
        thumbImageView.image = UIImage(named: "placeholder")
    }
    
    private func hideImageLoadingShimmer() {
        thumbImageView.hideSkeleton()
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
        showImageLoadingShimmer()
        
        titleAndImageStackView.isHidden = titleLabel.isHidden && thumbImageView.isHidden
        
        if bodyLabel.isHidden {
            titleAndImageStackView.axis = .horizontal
        } else {
            titleAndImageStackView.axis = .vertical
        }

        /**
         Note: Although each elements are individually configured for accessibility, Table view cell would apply automatic combining
         of these all and make the whole cell accessible as Apple way. However, the entrire VoiceOver text sounds a bit nicer this way.
         If needed custom container accessbility logic can be applied for more customisation
         */

        item.accessibility?.titleAccessibility?.apply(to: titleLabel)
        item.accessibility?.bodyAccessibility?.apply(to: bodyLabel)
        item.accessibility?.imageAccessibility?.apply(to: thumbImageView)
        
        applyContainerStyle()
    }
    
    func update(withImage image: UIImage?) {
        if let image = image {
            DispatchQueue.main.async {
                self.thumbImageView.image = image
                self.hideImageLoadingShimmer()
            }
        } else {
            hideImageLoadingShimmer()
        }
    }
}
