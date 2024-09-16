//
//  TitleStackView.swift
//  Todos
//
//  Created by Ruslan Shigapov on 16.09.2024.
//

import UIKit

final class TitleStackView: UIStackView {

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 26, weight: .bold)
        label.textColor = .black
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        label.textColor = .gray
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
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
    
    func configure(withTitle title: String, description: String) {
        titleLabel.text = title
        descriptionLabel.text = description
    }
}
