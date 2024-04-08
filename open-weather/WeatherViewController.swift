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

/**
 Manages the UI for the initial screen in the app where the user can enter a city/zip code to search for weather conditions.
 */
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
        $0.placeholder = String(localized: "Enter city name or zip code", comment: "TextField placeholder")
    }
    private let button = KDIButton(type: .system)
        .setTranslatesAutoresizingMaskIntoConstraints()
        .also {
            $0.setTitle(String(localized: "Request Forecast", comment: "Button title"), for: .normal)
        }
    
    private let viewModel = WeatherViewModel()
    
    // MARK: - Override Functions
    override func setup() {
        super.setup()
        
        title = String(localized: "Open Weather", comment: "WeatherViewController title")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // add the stack view and our subviews
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
        
        // bind viewModel.isEnabled -> button.isEnabled
        viewModel.$isEnabled
            .receive(on: DispatchQueue.main)
            .assign(to: \UIButton.isEnabled, on: button, ownership: .weak)
            .store(in: &cancellables)
        
        // bind viewModel.isExecuting -> button.isLoading
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
