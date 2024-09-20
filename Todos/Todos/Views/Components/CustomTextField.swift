//
//  CustomTextField.swift
//  Todos
//
//  Created by Ruslan Shigapov on 20.09.2024.
//

import UIKit

enum CustomTextFieldType: String {
    case title, description
}

final class CustomTextField: UITextField {
    
    private let type: CustomTextFieldType
    
    init(type: CustomTextFieldType, tag: Int) {
        self.type = type
        super.init(frame: .zero)
        self.tag = tag
        delegate = self
        setupUI()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        attributedPlaceholder = NSAttributedString(
            string: type.rawValue.capitalized,
            attributes: [
                .font: UIFont.systemFont(ofSize: 15, weight: .medium),
                .foregroundColor: UIColor.lightGray
            ])
        textColor = .black.withAlphaComponent(0.7)
        heightAnchor.constraint(equalToConstant: 30).isActive = true
    }
}

// MARK: - UITextFieldDelegate
extension CustomTextField: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let nextTag = textField.tag + 1
        if let nextTextField = textField.superview?.viewWithTag(nextTag) {
            nextTextField.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        return true
    }
}
