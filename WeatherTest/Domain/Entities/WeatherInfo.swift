//
//  Search.swift
//  WeatherTest
//
//  Created by Fred Strout on 2/3/25.
//

import SwiftUI

struct WeatherInfo: Identifiable {
  let id: String
  let city: String
  let temp: String
  let conditionImage: any View
  let feelsLike: String
  let humidity: String
  let uv: String
}
