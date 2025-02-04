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
  
  @Published var weatherInfo: [WeatherInfo] = []
  
  @Published var viewType: ViewType = .noCitySelected
  
  let weatherUseCase: WeatherUseCaseProtocol
  
  let defaults = UserDefaults.standard
  let locationKey = "Location"
  
  init(weatherUseCase: WeatherUseCaseProtocol = WeatherUseCase()) {
    self.weatherUseCase = weatherUseCase
    getSavedLocation()
  }
  
  func getSavedLocation() {
    if let savedLocationData = defaults.object(forKey: locationKey) as? String {
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
            print("Error loading saved location: \(error.localizedDescription)")
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
            if weatherInfo.count > 0 {
              viewType = .list
            } else {
              viewType = .empty
            }
          }
        } catch {
          await MainActor.run {
            print("Error searching: \(error)")
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
          getCompleteSearchResults(results)
          if results.count > 0 {
            self.viewType = .list
          } else {
            self.viewType = .empty
          }
        }
      } catch {
        await MainActor.run {
          print("Error searching: \(error)")
        }
      }
    }
  }
}

enum ViewType {
  case empty
  case list
  case location
  case noCitySelected
  case loading
}
