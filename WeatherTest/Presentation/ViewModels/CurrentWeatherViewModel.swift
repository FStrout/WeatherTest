//
//  CurrentWeatherViewModel.swift
//  WeatherTest
//
//  Created by Fred Strout on 2/3/25.
//

import SwiftUI

final class CurrentWeatherViewModel: ObservableObject {
  
  @Published var selectedWeatherInfo: WeatherInfo? = nil {
    didSet {
      weatherInfo.removeAll()
      viewType = selectedWeatherInfo != nil ? .location : .empty
    }
  }
  
  @Published var viewType: ViewType = .noCitySelected
  @Published var weatherInfo: [WeatherInfo] = []
  
  let defaults = UserDefaults.standard
  let locationKey = "Location"
  var searchResults: [SearchResult] = []
  let weatherUseCase: WeatherUseCaseProtocol
  
  init(weatherUseCase: WeatherUseCaseProtocol = WeatherUseCase()) {
    self.weatherUseCase = weatherUseCase
    getSavedLocation()
  }
  
  func getSavedLocation() {
    if let savedLocationData = defaults.object(forKey: locationKey) as? String {
      viewType = .loading
      Task {
        do {
          let location  = try await weatherUseCase.fetchWeather(
            for: savedLocationData
          )
          await MainActor.run {
            selectedWeatherInfo = location
          }
        } catch {
          await MainActor.run {
            viewType = .error
          }
        }
      }
    }
  }
  
  func selectLocation(_ location: WeatherInfo) {
    selectedWeatherInfo = location
    defaults.set(location.id, forKey: locationKey)
  }
  
  func getCompleteSearchResults(_ searchResults: [SearchResult]) {
    searchResults.forEach { item in
      let itemId = ("\(item.name), \(item.region), \(item.country)")
      Task {
        do {
          let currentWeather = try await weatherUseCase.fetchWeather(
            for: itemId
          )
          await MainActor.run {
            weatherInfo.append(currentWeather)
            if searchResults.count == weatherInfo.count {
              viewType = .list
            }
          }
        } catch {
          await MainActor.run {
            viewType = .error
          }
        }
      }
    }
  }
  
  func searchButtonTapped(_ searchString: String) {
    viewType = .loading
    weatherInfo.removeAll()
    Task {
      do {
        let results = try await weatherUseCase.searchCities(
          matching: searchString
        )
        await MainActor.run {
          if results.count > 0 {
            searchResults = results
            getCompleteSearchResults(results)
          } else {
            self.viewType = .empty
          }
        }
      } catch {
        await MainActor.run {
          viewType = .error
        }
      }
    }
  }
}

enum ViewType {
  case empty
  case error
  case list
  case location
  case noCitySelected
  case loading
}
