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
    private let titleText: String
    
    private var shouldTitleBeCrossedOut: Bool {
        didSet {
            if shouldTitleBeCrossedOut {
                let strikethroughText = NSAttributedString(
                    string: titleLabel.text ?? "",
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
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = titleText
        label.textColor = .black
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.textColor = .lightGray
        return label
    }()
    
    // MARK: Initialize
    init(
        placement: TitleStackViewPlacement,
        titleText: String,
        descriptionText: String,
        shouldTitleBeCrossedOut: Bool = false
    ) {
        self.titleText = titleText
        self.shouldTitleBeCrossedOut = shouldTitleBeCrossedOut
        super.init(frame: .zero)
        setupUI()
        descriptionLabel.text = descriptionText
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
    func toggleTitleStrikethrough() {
        shouldTitleBeCrossedOut.toggle()
    }
}
