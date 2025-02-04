//
//  MockWeatherUseCase.swift
//  WeatherTestTests
//
//  Created by Fred Strout on 2/4/25.
//

import SwiftUI
@testable import WeatherTest

class MockWeatherUseCase: WeatherUseCaseProtocol {
  static let shared = MockWeatherUseCase()
  
  func fetchWeather(for city: String) async throws -> WeatherInfo {
    
    let response = Bundle.main.decode(
      CurrentWeatherResponse.self,
      from: "CurrentWeather.json",
      keyDecodingStrategy: .convertFromSnakeCase
    )
    
    return response.weatherInfo
  }
  
  func searchCities(matching query: String) async throws -> [SearchResult] {
    
    let response = Bundle.main.decode(
      [SearchResult].self,
      from: "SearchResults.json",
      keyDecodingStrategy: .convertFromSnakeCase
    )
    
    return response
  }
}
