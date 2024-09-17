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

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.textColor = .gray
        return label
    }()
    
    init(placement: TitleStackViewPlacement) {
        super.init(frame: .zero)
        setupUI()
        setupFonts(for: placement)
    }
    
    @available(*, unavailable)
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        addArrangedSubview(titleLabel)
        addArrangedSubview(descriptionLabel)
        axis = .vertical
        spacing = 4
    }
    
    private func setupFonts(for placement: TitleStackViewPlacement) {
        titleLabel.font = .systemFont(
            ofSize: placement == .main ? 26 : 21,
            weight: placement == .main ? .semibold : .medium)
        descriptionLabel.font = .systemFont(
            ofSize: placement == .main ? 17 : 15,
            weight: .medium)
    }
    
    func configure(withTitle title: String, description: String) {
        titleLabel.text = title
        descriptionLabel.text = description
    }
}
