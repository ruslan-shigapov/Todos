//
//  TimeStackView.swift
//  Todos
//
//  Created by Ruslan Shigapov on 20.09.2024.
//

import UIKit

enum TimeStackViewType {
    case start, end
}

final class TimeStackView: UIStackView {
    
    private let type: TimeStackViewType
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = switch type {
        case .start: "Start Time"
        case .end: "End Time"
        }
        label.textColor = .black.withAlphaComponent(0.7)
        label.font = .systemFont(ofSize: 15, weight: .medium)
        return label
    }()
        
    private let switchButton: UISwitch = {
        let switchButton = UISwitch()
        switchButton.onTintColor = .link
        switchButton.isOn = false
        return switchButton
    }()
    
    private lazy var titleStackView: UIStackView = {
        let stackView = UIStackView(
            arrangedSubviews: [titleLabel, switchButton])
        stackView.distribution = .equalSpacing
        return stackView
    }()
    
    init(type: TimeStackViewType) {
        self.type = type
        super.init(frame: .zero)
        setupUI()
    }
    
    @available(*, unavailable)
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        addArrangedSubview(titleStackView)
        axis = .vertical
    }
}
