//
//  BaseViewController.swift
//  open-weather
//
//  Created by William Towe on 4/7/24.
//

import Feige
import Foundation
import UIKit

open class BaseViewController: UIViewController {
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
