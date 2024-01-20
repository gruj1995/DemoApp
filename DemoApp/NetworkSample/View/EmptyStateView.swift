//
//  EmptyStateView.swift
//  DemoApp
//
//  Created by 李品毅 on 2024/1/16.
//

import UIKit

class EmptyStateView: UIView {
    // MARK: Lifecycle

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Internal

    func configure(title: String, message: String) {
        titleLabel.text = title
        messageLabel.text = message
    }

    // MARK: Private

    private lazy var contentStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [titleLabel, messageLabel])
        stackView.axis = .vertical
        stackView.spacing = 5
        stackView.alignment = .center
        stackView.distribution = .equalSpacing
        return stackView
    }()

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        label.textAlignment = .center
        label.textColor = .appColor(.gray4)
        label.numberOfLines = 0
        return label
    }()

    private lazy var messageLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.textAlignment = .center
        label.textColor = .appColor(.gray3)
        label.numberOfLines = 0
        return label
    }()

    private func setupUI() {
        backgroundColor = .clear
        addSubview(contentStackView)

        setupLayout()
    }

    private func setupLayout() {
        contentStackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}
