//
//  TrackCell.swift
//  DemoApp
//
//  Created by 李品毅 on 2024/1/16.
//

import Kingfisher
import UIKit

class TrackCell: UITableViewCell {
    // MARK: Lifecycle

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Internal

    class var reuseIdentifier: String {
        return String(describing: self)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        coverImageView.layoutIfNeeded()
    }

    func configure(artworkUrl: String, collectionName: String, artistName: String, trackName: String, showsHighlight: Bool = false) {
        let url = URL(string: artworkUrl)
        coverImageView.kf.setImage(with: url)
        trackNameLabel.text = trackName
        albumInfoLabel.text = "\(artistName) · \(collectionName)"
        albumInfoLabel.isHidden = artistName.isEmpty && collectionName.isEmpty
    }

    // MARK: Private

    private lazy var coverImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .clear
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = 5
        imageView.clipsToBounds = true
        return imageView
    }()

    private lazy var trackNameLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 15)
        label.textColor = .appColor(.text1)
        return label
    }()

    private lazy var albumInfoLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 13)
        label.textColor = .appColor(.gray3)
        return label
    }()

    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [trackNameLabel, albumInfoLabel])
        stackView.axis = .vertical
        stackView.spacing = 3
        stackView.distribution = .equalSpacing
        return stackView
    }()

    private func setupUI() {
        selectionStyle = .none
        contentView.backgroundColor = .appColor(.background1)
        contentView.addSubview(coverImageView)
        contentView.addSubview(stackView)
        setupLayout()
    }

    private func setupLayout() {
        coverImageView.snp.makeConstraints {
            $0.leading.equalTo(contentView.snp.leadingMargin)
            $0.top.bottom.equalToSuperview().inset(5)
            $0.width.equalTo(coverImageView.snp.height)
        }
        stackView.snp.makeConstraints {
            $0.leading.equalTo(coverImageView.snp.trailing).offset(15)
            $0.trailing.equalTo(contentView.snp.trailingMargin)
            $0.centerY.equalToSuperview()
        }
    }
}
