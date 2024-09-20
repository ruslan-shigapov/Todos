//
//  EditorViewController.swift
//  Todos
//
//  Created by Ruslan Shigapov on 20.09.2024.
//

import UIKit

final class EditorViewController: UIViewController {
    
    private let viewModel: EditorViewModelProtocol

    init(viewModel: EditorViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        view.backgroundColor = .background
//        addSubviews()
//        setConstraints()
    }
}
