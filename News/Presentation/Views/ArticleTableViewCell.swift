//
//  ArticleTableViewCell.swift
//  News
//
//  Created by Md Zahidul Islam  on 12/12/25.
//

import UIKit

final class ArticleTableViewCell: UITableViewCell {
    
    static let reuseIdentifier = "ArticleTableViewCell"
    
    private let thumbnailImageView = UIImageView()
    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()
    private let dateLabel = UILabel()
    
    private var currentImageURL: URL?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("Use init(style:reuseIdentifier:)")
    }
    
    private func setupUI() {
        accessoryType = .disclosureIndicator
        
        thumbnailImageView.contentMode = .scaleAspectFill
        thumbnailImageView.clipsToBounds = true
        thumbnailImageView.layer.cornerRadius = 8
        
        titleLabel.font = UIFont.preferredFont(forTextStyle: .headline)
        titleLabel.numberOfLines = 2
        
        subtitleLabel.font = UIFont.preferredFont(forTextStyle: .subheadline)
        subtitleLabel.textColor = .secondaryLabel
        
        dateLabel.font = UIFont.preferredFont(forTextStyle: .caption1)
        dateLabel.textColor = .tertiaryLabel
        
        let textStack = UIStackView(arrangedSubviews: [titleLabel, subtitleLabel, dateLabel])
        textStack.axis = .vertical
        textStack.spacing = 4
        
        let containerStack = UIStackView(arrangedSubviews: [thumbnailImageView, textStack])
        containerStack.axis = .horizontal
        containerStack.spacing = 12
        containerStack.alignment = .top
        
        contentView.addSubview(containerStack)
        containerStack.translatesAutoresizingMaskIntoConstraints = false
        thumbnailImageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            thumbnailImageView.widthAnchor.constraint(equalToConstant: 80),
            thumbnailImageView.heightAnchor.constraint(equalToConstant: 80),
            
            containerStack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            containerStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            containerStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            containerStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16)
        ])
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        thumbnailImageView.image = nil
        currentImageURL = nil
    }
    
    func configure(with viewModel: ArticleCellViewModel) {
        titleLabel.text = viewModel.title
        subtitleLabel.text = viewModel.subtitle
        dateLabel.text = viewModel.dateText
        
        guard let url = viewModel.imageURL else {
            thumbnailImageView.image = UIImage(systemName: "photo")
            return
        }
        
        currentImageURL = url
        thumbnailImageView.image = UIImage(systemName: "photo")
        
        ImageCache.shared.image(for: url) { [weak self] image in
            guard let self = self,
                  self.currentImageURL == url else { return }
            self.thumbnailImageView.image = image ?? UIImage(systemName: "photo")
        }
    }
}
