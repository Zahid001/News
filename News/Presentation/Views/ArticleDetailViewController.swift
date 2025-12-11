// Presentation/Views/ArticleDetailViewController.swift
import UIKit

final class ArticleDetailViewController: UIViewController {
    
    private let article: Article
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    private let imageView = UIImageView()
    private let titleLabel = UILabel()
    private let sourceLabel = UILabel()
    private let dateLabel = UILabel()
    private let contentLabel = UILabel()
    
    init(article: Article) {
        self.article = article
        super.init(nibName: nil, bundle: nil)
        self.title = article.source?.name ?? "Article"
    }
    
    required init?(coder: NSCoder) {
        fatalError("Use init(article:) instead")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        configureData()
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        
        // Scroll view
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leftAnchor.constraint(equalTo: view.leftAnchor),
            scrollView.rightAnchor.constraint(equalTo: view.rightAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
        ])
        
        // Image
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        
        // Labels
        titleLabel.font = .boldSystemFont(ofSize: 24)
        titleLabel.numberOfLines = 0
        
        sourceLabel.font = .systemFont(ofSize: 16)
        sourceLabel.textColor = .secondaryLabel
        
        dateLabel.font = .systemFont(ofSize: 14)
        dateLabel.textColor = .tertiaryLabel
        
        contentLabel.font = .systemFont(ofSize: 18)
        contentLabel.numberOfLines = 0
        
        // StackView layout
        let stack = UIStackView(arrangedSubviews: [
            imageView,
            titleLabel,
            sourceLabel,
            dateLabel,
            contentLabel
        ])
        stack.axis = .vertical
        stack.spacing = 16
        
        contentView.addSubview(stack)
        stack.translatesAutoresizingMaskIntoConstraints = false
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            stack.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 16),
            stack.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -16),
            stack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),
            
            // Image height
            imageView.heightAnchor.constraint(equalToConstant: 220)
        ])
    }
    
    private func configureData() {
        titleLabel.text = article.title
        sourceLabel.text = "Source: \(article.source?.name ?? "Unknown")"
        
        // Format date
        if let date = article.publishedAt {
            let formatter = DateFormatter()
            formatter.dateStyle = .medium
            formatter.timeStyle = .short
            dateLabel.text = formatter.string(from: date)
        }
        
        contentLabel.text = article.content ?? article.description ?? "No content available."
        
        // Image loading
        if let imageURL = article.urlToImage.flatMap(URL.init(string:)) {
            ImageCache.shared.image(for: imageURL) { [weak self] img in
                self?.imageView.image = img ?? UIImage(systemName: "photo")
            }
        } else {
            imageView.image = UIImage(systemName: "photo")
        }
    }
}