//
//  BaseViewModel.swift
//  open-weather
//
//  Created by William Towe on 4/7/24.
//

import Combine
import Feige
import Foundation

/**
 Base view model class that provides common behavior.
 */
open class BaseViewModel {
    // MARK: - Public Properties
    /**
     A lazily created set of `AnyCancellable` objects that can be used to store `Combine` subscriptions.
     
     ```swift
     publisher
     .sink {
        // do something on finish or failure
     } receiveValue {
        // do something with the value
     }
     .store(in: &cancellables)
     ```
     */
    open lazy var cancellables = Set<AnyCancellable>()
    
    // MARK: - Public Functions
    /**
     Override to perform setup code.
     */
    open func setup() {
        
    }
    
    // MARK: - Initializers
    init() {
        setup()
    }
}
