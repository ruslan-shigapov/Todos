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
        case .start: Constants.startTime
        case .end: Constants.endTime
        }
        label.textColor = .gray
        label.font = .systemFont(ofSize: 15, weight: .semibold)
        return label
    }()
        
    private lazy var switchButton: UISwitch = {
        let switchButton = UISwitch()
        switchButton.onTintColor = .link
        switchButton.isOn = false
        switchButton.addTarget(
            self,
            action: #selector(switchButtonTapped),
            for: .valueChanged)
        return switchButton
    }()
    
    private lazy var titleStackView: UIStackView = {
        let stackView = UIStackView(
            arrangedSubviews: [titleLabel, switchButton])
        stackView.distribution = .equalSpacing
        return stackView
    }()
    
    private let timePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .time
        datePicker.minuteInterval = 15
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.heightAnchor.constraint(equalToConstant: 120).isActive = true
        return datePicker
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
        spacing = 8
    }
    
    @objc private func switchButtonTapped() {
        if switchButton.isOn {
            addArrangedSubview(timePicker)
        } else {
            removeArrangedSubview(timePicker)
            timePicker.removeFromSuperview()
        }
    }
}
