//
//  WeatherRepository.swift
//  WeatherTest
//
//  Created by Fred Strout on 2/4/25.
//

import Foundation

protocol WeatherRepositoryProtocol {
  func fetchWeather(for city: String) async throws -> WeatherInfo
  func searchCities(matching query: String) async throws -> [SearchResult]
}

class WeatherRepository {
  private let weatherProvider: WeatherProviderProtocol
  
  init(weatherProvider: WeatherProviderProtocol = WeatherProvider()) {
    self.weatherProvider = weatherProvider
  }
}

extension WeatherRepository: WeatherRepositoryProtocol {
  func fetchWeather(for city: String) async throws -> WeatherInfo {
    do {
      return try await weatherProvider.getCurrent(city)
    } catch {
      print(error.localizedDescription)
      throw URLError(.badServerResponse)
    }
  }
  
  func searchCities(matching query: String) async throws -> [SearchResult] {
    do {
      return try await weatherProvider.search(query)
    } catch {
      print(error.localizedDescription)
      throw URLError(.badServerResponse)
    }
  }
}
