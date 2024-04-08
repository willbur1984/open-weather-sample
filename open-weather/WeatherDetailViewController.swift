//
//  WeatherDetailViewController.swift
//  open-weather
//
//  Created by William Towe on 4/7/24.
//

import CombineExt
import Feige
import Foundation
import Kingfisher
import Romita
import UIKit

private final class WeatherDetailCell: UITableViewCell {
    // MARK: - Private Properties
    private let stackView = UIStackView()
        .setTranslatesAutoresizingMaskIntoConstraints()
        .also {
            $0.axis = .horizontal
            $0.spacing = 8
        }
    private let iconImageView = UIImageView()
        .setTranslatesAutoresizingMaskIntoConstraints()
        .also {
            NSLayoutConstraint.activate([
                $0.widthAnchor.constraint(equalToConstant: 50),
                $0.heightAnchor.constraint(equalTo: $0.widthAnchor)
            ])
        }
    private let titleLabel = UILabel()
        .setTranslatesAutoresizingMaskIntoConstraints()
    
    // MARK: - Public Functions
    func setItem(_ item: WeatherDetailViewModel.Item) {
        switch item {
        case let .default(imageURL, title):
            if let imageURL = imageURL {
                iconImageView.isHidden = false
                iconImageView.kf.setImage(with: imageURL, placeholder: UIImage(systemName: "home"))
            }
            else {
                iconImageView.isHidden = true
                iconImageView.image = nil
            }
            titleLabel.text = title
        }
    }
    
    // MARK: - Initializers
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(stackView.also {
            $0.addArrangedSubviews([
                iconImageView,
                titleLabel
            ])
        })
        stackView.pinToSuperviewEdges()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init?(coder:) is unavailable")
    }
}

final class WeatherDetailViewController: BaseViewController {
    // MARK: - Private Types
    private typealias DiffableDataSource = UITableViewDiffableDataSource<WeatherDetailViewModel.Section, WeatherDetailViewModel.Item>
    
    // MARK: - Private Properties
    private let tableView = UITableView()
        .setTranslatesAutoresizingMaskIntoConstraints()
        .also {
            $0.registerCellClass(WeatherDetailCell.self)
        }
    private let refreshControl = UIRefreshControl()
    private lazy var diffableDataSource: DiffableDataSource = { [unowned self] in
        DiffableDataSource(tableView: self.tableView) { tableView, indexPath, item in
            tableView.dequeueReusableCellClass(WeatherDetailCell.self, for: indexPath).also {
                $0.setItem(item)
            }
        }.also {
            $0.defaultRowAnimation = .fade
        }
    }()
    
    private let viewModel: WeatherDetailViewModel
    
    // MARK: - Override Functions
    override func setup() {
        super.setup()
        
        viewModel.title
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                guard let self else {
                    return
                }
                self.title = $0
            }
            .store(in: &cancellables)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(tableView.also {
            $0.dataSource = diffableDataSource
            $0.addSubview(refreshControl.also {
                $0.addBlock(forControlEvents: .valueChanged) { [weak self] _, _ in
                    guard let self else {
                        return
                    }
                    self.viewModel.refresh()
                        .receive(on: DispatchQueue.main)
                        .sink { [weak self] in
                            guard let self else {
                                return
                            }
                            self.refreshControl.endRefreshing()
                            
                            switch $0 {
                            case .finished:
                                break
                            case .failure(let error):
                                self.present(UIAlertController(error: error), animated: true)
                            }
                        } receiveValue: { _ in
                        }
                        .store(in: &self.cancellables)
                }
            })
        })
        tableView.pinToSuperviewEdges()
        
        viewModel.$snapshot
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                guard let self else {
                    return
                }
                self.diffableDataSource.apply($0)
            }
            .store(in: &cancellables)
    }
    
    // MARK: - Initializers
    init(response: WeatherResponse) {
        viewModel = WeatherDetailViewModel(response: response)
        
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init?(coder:) is unavailable")
    }
}
