//
//  WeatherViewController.swift
//  open-weather
//
//  Created by William Towe on 4/7/24.
//

import CombineCocoa
import CombineExt
import Ditko
import Feige
import Foundation
import os.log
import Romita
import UIKit

final class WeatherViewController: BaseViewController, UITextFieldDelegate {
    // MARK: - Private Properties
    private let stackView = UIStackView()
        .setTranslatesAutoresizingMaskIntoConstraints()
        .also {
            $0.axis = .vertical
            $0.spacing = 16
        }
    private let textField = UITextField().also {
        $0.borderStyle = .roundedRect
        $0.placeholder = String(localized: "Enter city name or zip code")
    }
    private let button = KDIButton(type: .system)
        .setTranslatesAutoresizingMaskIntoConstraints()
        .also {
            $0.setTitle(String(localized: "Request Forecast"), for: .normal)
        }
    
    private let viewModel = WeatherViewModel()
    
    // MARK: - Override Functions
    override func setup() {
        super.setup()
        
        title = String(localized: "Open Weather", comment: "WeatherViewController title")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(stackView.also {
            $0.addArrangedSubviews([
                textField.also {
                    $0.delegate = self
                    $0.textPublisher
                        .sink { [weak self] in
                            guard let self else {
                                return
                            }
                            viewModel.setQuery(value: $0)
                        }
                        .store(in: &cancellables)
                },
                button.also {
                    $0.addBlock { [weak self] _, _ in
                        guard let self else {
                            return
                        }
                        requestForecast()
                    }
                }
            ])
        })
        stackView.pinToSuperviewEdges([], safeAreaLayoutGuideEdges: [.top, .leading, .trailing])
        
        viewModel.$isEnabled
            .receive(on: DispatchQueue.main)
            .assign(to: \UIButton.isEnabled, on: button, ownership: .weak)
            .store(in: &cancellables)
        
        viewModel.$isExecuting
            .receive(on: DispatchQueue.main)
            .assign(to: \KDIButton.isLoading, on: button, ownership: .weak)
            .store(in: &cancellables)
    }
    
    // MARK: - UITextFieldDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        requestForecast()
        return false
    }
    
    // MARK: - Private Functions
    private func requestForecast() {
        viewModel.weather()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                guard let self else {
                    return
                }
                switch $0 {
                case .finished:
                    break
                case .failure(let error):
                    self.present(UIAlertController(error: error), animated: true)
                }
            } receiveValue: { [weak self] in
                guard let self else {
                    return
                }
                guard let response = $0 else {
                    self.present(UIAlertController(error: nil), animated: true)
                    return
                }
                self.navigationController?.pushViewController(WeatherDetailViewController(response: response), animated: true)
            }
            .store(in: &cancellables)
    }
}
