//
//  open_weatherUITests.swift
//  open-weatherUITests
//
//  Created by William Towe on 4/7/24.
//

import Feige
import XCTest

final class open_weatherUITests: XCTestCase {
    // MARK: - Override Functions
    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    func testExample() throws {
        XCUIApplication().also {
            $0.launch()
            
            // TODO: Add UI test
        }
    }
}
