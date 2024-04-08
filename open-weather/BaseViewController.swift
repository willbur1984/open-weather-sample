//
//  BaseViewController.swift
//  open-weather
//
//  Created by William Towe on 4/7/24.
//

import Combine
import Feige
import Foundation
import UIKit

/**
 Base view controller class that provides common behavior.
 */
open class BaseViewController: UIViewController {
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
     Called before the receiver's view is loaded.
     */
    open func setup() {
        
    }
    
    // MARK: - Override Functions
    open override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
    }
    
    // MARK: - Initializers
    public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        setup()
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        setup()
    }
}
