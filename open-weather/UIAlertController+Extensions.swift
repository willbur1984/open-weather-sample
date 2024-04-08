//
//  UIAlertController+Extensions.swift
//  open-weather
//
//  Created by William Towe on 4/7/24.
//

import Foundation
import UIKit

extension UIAlertController {
    // MARK: - Initializers
    convenience init(error: Error) {
        self.init(title: error.localizedDescription, message: error.localizedFailureReason, preferredStyle: .alert)
        
        addAction(.init(title: String(localized: "Okay"), style: .default))
    }
}
