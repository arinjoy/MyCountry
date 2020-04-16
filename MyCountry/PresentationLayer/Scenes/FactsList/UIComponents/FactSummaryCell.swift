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

private enum ConstraintsMode {
    
    /// Used for narrow width layout (eg. All iPhones execept Plus, Xs Max sizes)
    case compact
    
    /// Used for wide width layout (eg. iPhones with Plus, Xs Max sizes and all iPads sizes)
    case regular
}

/**
 A table view cell that supports two types of cell layouts (compact and regular) based on size classes and orientation updates.
 
 ConstraintsMode: -> Compact (narrow)
 -----------
 |  title  |
 -----------
 |  image  |
 -----------
 |  body   |
 -----------
 
 ConstraintsMode: -> Regular (wide)
 -------------------
 |  image  | title |
 -------------------
           |  body |
 -------------------
 */
final class FactSummaryCell: UITableViewCell {
    
    static let cellReuseIdentifier = "FactSummaryCell"
    static let approximateRowHeight: CGFloat = 120
    
    var imageLoaded: Bool = false
    
    // MARK: - UI Element Properties
    
    private lazy var containerView: UIView = {
        let view = UIView()
        return view
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = Theme.titleFont
        label.textAlignment = .left
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var bodyLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = true
        label.font = Theme.bodyFont
        label.textAlignment = .left
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var thumbImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = true
        imageView.contentMode = .scaleAspectFit
        imageView.isSkeletonable = true
        return imageView
    }()
    
    private lazy var firstStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 20
        stackView.distribution = .fill
        stackView.alignment = .center
        return stackView
    }()
    
    private lazy var secondStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 20
        stackView.distribution = .fill
        stackView.alignment = .center
        return stackView
    }()
    
    /// The full stack contains `first` and `second` stacks. The those stacks may contain different
    /// elements based on device size detection and orientation updates handled dynamically
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
        
        static let imageWidth: CGFloat = UIDevice.current.isIPhone ? Constants.screenWidth / 3 : Constants.screenWidth / 4
        static let imageHeight: CGFloat = Constants.imageWidth * 3/4
        
        static let cellMargin: CGFloat = UIDevice.current.isIPhone ? 16 : 32
    }
    
    /// A local helper variable that keeps the status of the currently active constraints mode
    private var currentlyActiveConstraintMode: ConstraintsMode = .compact
    
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

        thumbImageView.image = nil
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
                
        if UIDevice.current.isIPhone {
            
            clearElementsFromStacks()
            
            if traitCollection.horizontalSizeClass == .regular && traitCollection.verticalSizeClass == .compact {
                activateRegularConstraints()
            } else {
                activateCompactConstraints()
            }
        }
        
        fullStackView.layoutIfNeeded()
    }
    
    // MARK: - Private Helpers
        
    /// Activates/layout constraints for horizontally compact (i.e. narrow width) environments (such as iPhone in portait mode)
    private func activateRegularConstraints() {
        currentlyActiveConstraintMode = .regular
        
        firstStackView.addArrangedSubview(thumbImageView)
        firstStackView.alignment = .fill
        
        secondStackView.addArrangedSubview(titleLabel)
        secondStackView.addArrangedSubview(bodyLabel)
        secondStackView.axis = .vertical
        secondStackView.alignment = .center
        
        fullStackView.axis = .horizontal
        
        shrinkHiddenImageAreaIfNeeded()
    }
    
    /// Activates/layouts constraints for horizontally regular (i.e wider width) environments (such as iPhone landscape or all iPad modes)
    private func activateCompactConstraints() {
        currentlyActiveConstraintMode = .compact
        
        firstStackView.addArrangedSubview(titleLabel)
        firstStackView.addArrangedSubview(thumbImageView)
        firstStackView.axis = .vertical
        firstStackView.alignment = .center
        
        secondStackView.addArrangedSubview(bodyLabel)
        secondStackView.alignment = .fill
        
        fullStackView.axis = .vertical
        
        shrinkHiddenImageAreaIfNeeded()
    }
    
    /// Clears each lowest level elements from their relevant enclosing stack views
    private func clearElementsFromStacks() {
        for view in [titleLabel, thumbImageView, bodyLabel] {
            firstStackView.removeArrangedSubview(view)
            secondStackView.removeArrangedSubview(view)
            view.removeFromSuperview()
        }
    }
    
    private func buildUIAndApplyConstraints() {
        
        thumbImageView.snp.makeConstraints { make in
            make.width.equalTo(Constants.imageWidth).priority(999)
            make.height.equalTo(Constants.imageHeight)
        }
        
        if UIDevice.current.isIPhone {
            if traitCollection.horizontalSizeClass == .regular && traitCollection.verticalSizeClass == .compact {
                activateRegularConstraints()
            } else {
                activateCompactConstraints()
            }
        } else {
            activateRegularConstraints()
        }
                
        // First and Second stack views are constructed from the above method call
        fullStackView.addArrangedSubview(firstStackView)
        fullStackView.addArrangedSubview(secondStackView)
        
        containerView.addSubview(fullStackView)
        
        fullStackView.snp.makeConstraints { make in
            make.leading.equalTo(containerView.snp.leading).offset(Constants.cellMargin)
            make.trailing.equalTo(containerView.snp.trailing).offset(-Constants.cellMargin)
            make.top.equalTo(containerView.snp.top).offset(Constants.cellMargin)
            make.bottom.equalTo(containerView.snp.bottom).offset(-Constants.cellMargin).priority(999)
        }
        
        contentView.addSubview(containerView)
        
        containerView.snp.makeConstraints { make in
            make.leading.equalTo(contentView.snp.leading).offset(Constants.cellMargin)
            make.trailing.equalTo(contentView.snp.trailing).offset(-Constants.cellMargin)
            make.top.equalTo(contentView.snp.top).offset(Constants.cellMargin / 2)
            make.bottom.equalTo(contentView.snp.bottom).offset(-Constants.cellMargin / 2)
        }
    }
    
    private func shrinkHiddenImageAreaIfNeeded() {
        if currentlyActiveConstraintMode == .regular && thumbImageView.isHidden && !titleLabel.isHidden && !bodyLabel.isHidden {
            firstStackView.isHidden = true
        } else {
            firstStackView.isHidden =  false
        }
    }
    
    private func showImageLoadingShimmer() {
        // Image would be loaded later on, but may be `nil` image due to
        // some loading error due to incorrect URLs, 404 not found etc.
        
        thumbImageView.showAnimatedGradientSkeleton(usingGradient: skeletonGradient,
                                                    animation: skeletonAnimation,
                                                    transition: .crossDissolve(0.25))
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
        
        // Also shrinks the image area to hide it in wider (i.e. regular) mode
        shrinkHiddenImageAreaIfNeeded()

        // Start the shimmer on it and make image loading flag to be false as this will
        // be set to true once the loading is finished via update image method asynchronously.
        showImageLoadingShimmer()
        imageLoaded = false
             
        fullStackView.layoutIfNeeded()

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
        
        guard !imageLoaded else { return }
        
        self.imageLoaded = true
        
        DispatchQueue.main.async {
            
            self.hideImageLoadingShimmer()
            
            let targetImage = image ?? UIImage(named: "placeholder")
            
            UIView.transition(with: self.thumbImageView,
                              duration: 0.25,
                              options: .transitionCrossDissolve,
                              animations: {
                                  self.thumbImageView.image = targetImage
                              },
                              completion: nil)
        }
    }
}
