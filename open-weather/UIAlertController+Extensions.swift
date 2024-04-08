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
    convenience init(error: Error?) {
        self.init(title: error?.localizedDescription ?? String(localized: "Something went wrong", comment: "Default error localized description"), message: error?.localizedFailureReason ?? String(localized: "Please try again later", comment: "Default error localized failure reason"), preferredStyle: .alert)
        
        addAction(.init(title: String(localized: "Okay"), style: .default))
    }
}
