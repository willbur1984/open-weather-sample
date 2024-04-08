//
//  open_weatherTests.swift
//  open-weatherTests
//
//  Created by William Towe on 4/7/24.
//

import Nimble
import Quick
import SwiftyJSON
import XCTest
@testable import open_weather

final class open_weatherTests: QuickSpec {
    override func spec() {
        describe("DirectGeocodeResponse") {
            it("should be nil") {
                let jsonString = """
                            {
                              "lo" : -87.6244212,
                              "lat" : 41.875561599999997
                            }
                            """
                
                expect(DirectGeocodeResponse(json: JSON(parseJSON: jsonString))).to(beNil())
            }
            it("should not be nil") {
                let jsonString = """
                                {
                                  "lon" : -87.6244212,
                                  "lat" : 41.875561599999997
                                }
                                """
                
                expect(DirectGeocodeResponse(json: JSON(parseJSON: jsonString))).toNot(beNil())
            }
        }
        describe("WeatherResponse") {
            it("should not be nil") {
                let jsonString = """
                                {
                                  "wind" : {
                                    "speed" : 11.01,
                                    "deg" : 165,
                                    "gust" : 14
                                  },
                                  "timezone" : -18000,
                                  "sys" : {
                                    "sunset" : 1712622208,
                                    "country" : "US",
                                    "sunrise" : 1712575229,
                                    "id" : 2010190,
                                    "type" : 2
                                  },
                                  "coord" : {
                                    "lat" : 41.875599999999999,
                                    "lon" : -87.624399999999994
                                  },
                                  "cod" : 200,
                                  "base" : "stations",
                                  "main" : {
                                    "feels_like" : 44.350000000000001,
                                    "pressure" : 1010,
                                    "temp_max" : 51.840000000000003,
                                    "temp" : 48.899999999999999,
                                    "temp_min" : 44.149999999999999,
                                    "humidity" : 75
                                  },
                                  "visibility" : 10000,
                                  "dt" : 1712557654,
                                  "weather" : [
                                    {
                                      "icon" : "01n",
                                      "main" : "Clear",
                                      "id" : 800,
                                      "description" : "clear sky"
                                    }
                                  ],
                                  "name" : "Chicago",
                                  "id" : 4887398,
                                  "clouds" : {
                                    "all" : 0
                                  }
                                }
                                """
                
                expect(WeatherResponse(json: JSON(parseJSON: jsonString))).toNot(beNil())
            }
            it("should be nil") {
                let jsonString = """
                                {
                                  "wind" : {
                                    "speed" : 11.01,
                                    "deg" : 165,
                                    "gust" : 14
                                  },
                                  "timezone" : -18000,
                                  "sys" : {
                                    "sunset" : 1712622208,
                                    "country" : "US",
                                    "sunrise" : 1712575229,
                                    "id" : 2010190,
                                    "type" : 2
                                  },
                                  "coord" : {
                                    "lat" : 41.875599999999999,
                                    "lon" : -87.624399999999994
                                  },
                                  "cod" : 200,
                                  "base" : "stations",
                                  "main" : {
                                    "feels_like" : 44.350000000000001,
                                    "pressure" : 1010,
                                    "temp_max" : 51.840000000000003,
                                    "temp" : 48.899999999999999,
                                    "temp_min" : 44.149999999999999,
                                    "humidity" : 75
                                  },
                                  "visibility" : 10000,
                                  "dt" : 1712557654,
                                  "weather" : [
                                    {
                                      "icon" : "01n",
                                      "main" : "Clear",
                                      "id" : 800,
                                      "description" : "clear sky"
                                    }
                                  ],
                                  "id" : 4887398,
                                  "clouds" : {
                                    "all" : 0
                                  }
                                }
                                """
                
                expect(WeatherResponse(json: JSON(parseJSON: jsonString))).to(beNil())
            }
        }
    }
}
