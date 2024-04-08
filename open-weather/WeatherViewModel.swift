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

final class WeatherViewModel: BaseViewModel {
    // MARK: - Public Properties
    @Published
    private(set) var isEnabled = false
    @Published
    private(set) var isExecuting = false
    
    // MARK: - Private Properties
    private let networkManager: NetworkManager
    @Published
    private var query: String?
    
    // MARK: - Public Functions
    func setQuery(value: String?) {
        query = value
    }
    
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
    init(networkManager: NetworkManager = .shared) {
        self.networkManager = networkManager
        
        super.init()
    }
}
