//
//  TitleStackView.swift
//  Todos
//
//  Created by Ruslan Shigapov on 16.09.2024.
//

import UIKit

enum TitleStackViewPlacement {
    case main, cell
}

final class TitleStackView: UIStackView {
    
    // MARK: Private Properties
    private var titleText = ""
    
    private var shouldTitleBeCrossedOut: Bool = false {
        didSet {
            if shouldTitleBeCrossedOut {
                let strikethroughText = NSAttributedString(
                    string: titleText,
                    attributes: [
                        .strikethroughStyle : NSUnderlineStyle.single.rawValue,
                        .strikethroughColor : UIColor.gray
                    ])
                titleLabel.attributedText = strikethroughText
            } else {
                titleLabel.attributedText = nil
                titleLabel.text = titleText
            }
        }
    }

    // MARK: Views
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.textColor = .lightGray
        return label
    }()
    
    // MARK: Initialize
    init(placement: TitleStackViewPlacement) {
        super.init(frame: .zero)
        setupUI()
        setupFonts(for: placement)
    }
    
    @available(*, unavailable)
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Private Methods
    private func setupUI() {
        addArrangedSubview(titleLabel)
        addArrangedSubview(descriptionLabel)
        axis = .vertical
        spacing = 4
    }
    
    private func setupFonts(for placement: TitleStackViewPlacement) {
        switch placement {
        case .main:
            titleLabel.font = .systemFont(ofSize: 24, weight: .semibold)
            descriptionLabel.font = .systemFont(ofSize: 16, weight: .medium)
        case .cell:
            titleLabel.font = .systemFont(ofSize: 18, weight: .medium)
            descriptionLabel.font = .systemFont(ofSize: 15, weight: .semibold)
        }
    }
    
    // MARK: Public Methods
    func configure(
        withTitle title: String,
        description: String,
        shouldTitleBeCrossedOut: Bool = false
    ) {
        titleText = title
        descriptionLabel.text = description
        self.shouldTitleBeCrossedOut = shouldTitleBeCrossedOut
    }
    
    func toggleTitleStrikethrough() {
        shouldTitleBeCrossedOut.toggle()
    }
}
