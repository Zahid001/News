//
//  ArticlesListViewController.swift
//  News
//
//  Created by Md Zahidul Islam  on 12/12/25.
//


// Presentation/Views/ArticlesListViewController.swift
import UIKit
import RxSwift
import RxCocoa

final class ArticlesListViewController: UIViewController {
    
    private let tableView = UITableView()
    private let activityIndicator = UIActivityIndicatorView(style: .large)
    private let refreshControl = UIRefreshControl()
    
    private let viewModel: ArticlesListViewModel
    private let disposeBag = DisposeBag()
    
    init(viewModel: ArticlesListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        self.title = "News"
    }
    
    required init?(coder: NSCoder) {
        fatalError("Use init(viewModel:) instead")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        bindViewModel()
        
        // initial load
        viewModel.reloadTrigger.accept(())
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        
        tableView.register(ArticleTableViewCell.self,
                           forCellReuseIdentifier: ArticleTableViewCell.reuseIdentifier)
        tableView.refreshControl = refreshControl
        
        view.addSubview(tableView)
        view.addSubview(activityIndicator)
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leftAnchor.constraint(equalTo: view.leftAnchor),
            tableView.rightAnchor.constraint(equalTo: view.rightAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    private func bindViewModel() {
        // Table data
        viewModel.articles
            .drive(tableView.rx.items(
                cellIdentifier: ArticleTableViewCell.reuseIdentifier,
                cellType: ArticleTableViewCell.self
            )) { _, cellVM, cell in
                cell.configure(with: cellVM)
            }
            .disposed(by: disposeBag)
        
        // Loading state
        viewModel.isLoading
            .drive(activityIndicator.rx.isAnimating)
            .disposed(by: disposeBag)
        
        viewModel.isLoading
            .drive(refreshControl.rx.isRefreshing)
            .disposed(by: disposeBag)
        
        // Errors
        viewModel.errorMessage
            .drive(onNext: { [weak self] message in
                guard let message = message else { return }
                let alert = UIAlertController(title: "Error",
                                              message: message,
                                              preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default))
                self?.present(alert, animated: true)
            })
            .disposed(by: disposeBag)
        
        // Pull to refresh
        refreshControl.rx.controlEvent(.valueChanged)
            .bind(to: viewModel.reloadTrigger)
            .disposed(by: disposeBag)
        
        // Selection
        tableView.rx.itemSelected
            .do(onNext: { [weak self] indexPath in
                self?.tableView.deselectRow(at: indexPath, animated: true)
            })
            .bind(to: viewModel.selection)
            .disposed(by: disposeBag)
    }
}