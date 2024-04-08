//
//  WeatherViewController.swift
//  open-weather
//
//  Created by William Towe on 4/7/24.
//

import Foundation
import UIKit

final class WeatherViewController: BaseViewController {
    // MARK: - Override Functions
    override func setup() {
        super.setup()
        
        self.title = String(localized: "Open Weather", comment: "WeatherViewController title")
    }
}
