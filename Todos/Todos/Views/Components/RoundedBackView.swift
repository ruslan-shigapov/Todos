//
//  RoundedBackView.swift
//  Todos
//
//  Created by Ruslan Shigapov on 20.09.2024.
//

import UIKit

final class RoundedBackView: UIView {
    
    private let subview: UIView

    init(subview: UIView) {
        self.subview = subview
        super.init(frame: .zero)
        setupUI()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        backgroundColor = .white
        layer.cornerRadius = 16
        addSubview(subview)
        setupShadow()
        prepareForAutoLayout()
        setConstraints()
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            subview.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            subview.leadingAnchor.constraint(
                equalTo: leadingAnchor,
                constant: 24),
            subview.bottomAnchor.constraint(
                equalTo: bottomAnchor,
                constant: -8),
            subview.trailingAnchor.constraint(
                equalTo: trailingAnchor,
                constant: -24)
        ])
    }
}
