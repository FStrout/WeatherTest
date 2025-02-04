//
//  String+Extensions.swift
//  WeatherTest
//
//  Created by Fred Strout on 2/3/25.
//

import Foundation

extension Double {
  var truncatedString: String {
    String(format: "%.0f", self)
  }
}
