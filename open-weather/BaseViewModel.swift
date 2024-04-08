//
//  BaseViewModel.swift
//  open-weather
//
//  Created by William Towe on 4/7/24.
//

import Combine
import Feige
import Foundation

open class BaseViewModel {
    // MARK: - Public Properties
    open lazy var cancellables = Set<AnyCancellable>()
    
    // MARK: - Public Functions
    open func setup() {
        
    }
    
    // MARK: - Initializers
    init() {
        setup()
    }
}
