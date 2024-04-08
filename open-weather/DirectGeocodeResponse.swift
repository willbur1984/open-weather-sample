//
//  DirectGeocodeResponse.swift
//  open-weather
//
//  Created by William Towe on 4/7/24.
//

import Feige
import Foundation
import os.log
import SwiftyJSON

struct DirectGeocodeResponse: ScopeFunctions {
    // MARK: - Public Properties
    let latitude: Double
    let longitude: Double
}

extension DirectGeocodeResponse {
    // MARK: - Initializers
    init?(json: JSON) {
        guard let latitude = json["lat"].double, let longitude = json["lon"].double else {
            return nil
        }
        self.latitude = latitude
        self.longitude = longitude
    }
}
