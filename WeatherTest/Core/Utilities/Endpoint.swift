//
//  Endpoint.swift
//  WeatherTest
//
//  Created by Fred Strout on 2/4/25.
//

import Foundation

enum Endpoint: Equatable {
  case currentWeather(String)
  case searchCity(String)
  
  var baseURL: URL {
    return URL(string: "https://api.weatherapi.com")!
  }
  
  var apiKey: String {
    return "key=\(Keys.weatherApiKey.rawValue)"
  }
  
  var relativePath: String {
    switch self {
    case .currentWeather(let location):
      return "v1/current.json?\(apiKey)&q=\(location)"
    case .searchCity(let query):
      return "v1/search.json?\(apiKey)&q=\(query)"
    }
  }
  
  var absoluteURL: URL {
    return URL(string: relativePath, relativeTo: baseURL)!
  }
}
