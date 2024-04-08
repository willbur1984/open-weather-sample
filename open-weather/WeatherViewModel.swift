//
//  WeatherViewModel.swift
//  open-weather
//
//  Created by William Towe on 4/7/24.
//

import Combine
import CombineExt
import Feige
import Foundation
import Moya
import SwiftyJSON

/**
 Manages the state required for the `WeatherViewController`.
 */
final class WeatherViewModel: BaseViewModel {
    // MARK: - Public Properties
    /**
     Returns whether the `weather(query:)` publisher should be called.
     
     - Note: This should be bound to the relevant UI control that allows the user to perform the search
     */
    @Published
    private(set) var isEnabled = false
    /**
     Returns a request is being performed.
     
     - Note: This should be bound to the relevant loading indicator in the UI
     */
    @Published
    private(set) var isExecuting = false
    
    // MARK: - Private Properties
    private let networkManager: NetworkManagerInterface
    @Published
    private var query: String?
    
    // MARK: - Public Functions
    /**
     Updates the query value.
     
     - Parameter value: The new query value
     */
    func setQuery(value: String?) {
        query = value
    }
    
    /**
     Returns a publisher that requests weather information for the current query value, then either sends a decoded `WeatherResponse` or fails with an error.
     */
    func weather() -> AnyPublisher<WeatherResponse?, MoyaError> {
        guard let query = query?.nilIfEmpty else {
            return Just(nil)
                .setFailureType(to: MoyaError.self)
                .eraseToAnyPublisher()
        }
        self.isEnabled = false
        self.isExecuting = true
        
        return networkManager.weather(query: query)
            .handleEvents(receiveCompletion: { [weak self] _ in
                guard let self else {
                    return
                }
                self.isEnabled = true
                self.isExecuting = false
            })
            .eraseToAnyPublisher()
    }
    
    // MARK: - Override Functions
    override func setup() {
        super.setup()
        
        $query.map {
            $0.isNotEmptyOrNil
        }
        .assign(to: \WeatherViewModel.isEnabled, on: self, ownership: .weak)
        .store(in: &cancellables)
    }
    
    // MARK: - Initializers
    /**
     Creates an instance.
     
     - Parameter networkManager: The object conforming to the `NetworkManagerInterface` to use when making network requests
     - Returns: The instance
     */
    init(networkManager: NetworkManagerInterface = NetworkManager.shared) {
        self.networkManager = networkManager
        
        super.init()
    }
}
