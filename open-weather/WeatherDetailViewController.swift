//
//  WeatherDetailViewController.swift
//  open-weather
//
//  Created by William Towe on 4/7/24.
//

import Foundation
import UIKit

final class WeatherDetailViewController: BaseViewController {
    // MARK: - Override Functions
    override func setup() {
        super.setup()
        
        self.title = String(localized: "Detail", comment: "WeatherDetailViewController title")
    }
}
