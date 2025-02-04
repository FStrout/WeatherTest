//
//  WeatherUseCase.swift
//  WeatherTest
//
//  Created by Fred Strout on 2/4/25.
//

import Foundation

protocol WeatherUseCaseProtocol {
  func fetchWeather(for city: String) async throws -> WeatherInfo
  func searchCities(matching query: String) async throws -> [SearchResult]
}

class WeatherUseCase {
  private let weatherRepository: WeatherRepositoryProtocol
  
  init(weatherRepository: WeatherRepositoryProtocol = WeatherRepository()) {
    self.weatherRepository = weatherRepository
  }
}

extension WeatherUseCase: WeatherUseCaseProtocol {
  func fetchWeather(for city: String) async throws -> WeatherInfo {
    do {
      return try await weatherRepository.fetchWeather(for: city)
    } catch {
      print(error.localizedDescription)
      throw URLError(.badServerResponse)
    }
  }
  
  func searchCities(matching query: String) async throws -> [SearchResult] {
    do {
      return try await weatherRepository.searchCities(matching: query)
    } catch {
      print(error.localizedDescription)
      throw URLError(.badServerResponse)
    }
  }
}
