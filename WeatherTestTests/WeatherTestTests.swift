//
//  WeatherTestTests.swift
//  WeatherTestTests
//
//  Created by Fred Strout on 2/4/25.
//

import Foundation
import Testing

@testable import WeatherTest

struct WeatherTestTests {

  let userDefaults = UserDefaults.standard
  
    @Test func getSavedLocationUserDefaultSet() async throws {
      
      // Setup
      let vm = CurrentWeatherViewModel(
        weatherUseCase: MockWeatherUseCase.shared
      )
      
      let defaultKey = "Location"
      let defaultSetting = "Washington, Pennsylvania, Unites States of America"
      
      userDefaults.set(defaultSetting, forKey: defaultKey)
      
      while userDefaults.string(forKey: defaultKey) != defaultSetting {}
      
      #expect(userDefaults.string(forKey: defaultKey) == defaultSetting)

      // Execute
      vm.getSavedLocation()
      while vm.viewType == .noCitySelected {}
      while vm.viewType == .loading {}
      
      // Evaluate
      #expect(vm.viewType == .location)
      
      // Reset
      userDefaults.removeObject(forKey: defaultKey)
      #expect(userDefaults.string(forKey: defaultKey) == nil)
    }
  
  @Test func getSavedLocationUserDefaultNotSet() async throws {
    
    // Setup
    let vm = CurrentWeatherViewModel(
      weatherUseCase: MockWeatherUseCase.shared
    )
    
    let defaultKey = "Location"
    
    userDefaults.removeObject(forKey: defaultKey)
    while userDefaults.string(forKey: defaultKey) != nil {}
    
    #expect(userDefaults.string(forKey: defaultKey) == nil)

    // Execute
    vm.getSavedLocation()
    
    // Evaluate
    #expect(vm.viewType == .noCitySelected)
  }
  
  @Test func getCompleteSearchResults() async throws {
    
    // Setup
    let vm = CurrentWeatherViewModel(
      weatherUseCase: MockWeatherUseCase.shared
    )
    
    let searchTerm = "Washington"
    
    // Execute
    vm.searchButtonTapped(searchTerm)
    
    while vm.viewType != .list {}
    
    // Evaluate
    #expect(vm.weatherInfo.count == 5)
  }
  
  @Test func selectLocation() async throws {
    
    // Setup
    let vm = CurrentWeatherViewModel(
      weatherUseCase: MockWeatherUseCase.shared
    )
    
    let expectedResponse = Bundle.main.decode(
      CurrentWeatherResponse.self,
      from: "CurrentWeather.json",
      keyDecodingStrategy: .convertFromSnakeCase
    )
    
    // Execute
    vm.selectLocation(expectedResponse.weatherInfo)
    
    while vm.viewType != .location {}
    
    // Evaluate
    if let location = vm.selectedWeatherInfo {
      #expect(location.id == expectedResponse.weatherInfo.id)
    }
  }
}
