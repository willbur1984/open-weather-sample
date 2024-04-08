//
//  Error+Extensions.swift
//  open-weather
//
//  Created by William Towe on 4/7/24.
//

import Foundation
import UIKit

extension Error {
    // MARK: - Public Properties
    /**
     Returns the localized failure reason or nil.
     */
    var localizedFailureReason: String? {
        (self as? LocalizedError)?.failureReason
    }
}
