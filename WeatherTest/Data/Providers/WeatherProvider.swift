//
//  WeatherProvider.swift
//  WeatherTest
//
//  Created by Fred Strout on 2/3/25.
//

import Foundation

protocol WeatherProviderProtocol {
  func getCurrent(_ location: String) async throws -> WeatherInfo
  func search(_ searchString: String) async throws -> [SearchResult]
}

class WeatherProvider {
  let session: URLSession
  let decoder: JSONDecoder
  
  let baseUrl = "https://api.weatherapi.com/v1"
  
  init(session: URLSession = .shared, decoder: JSONDecoder = JSONDecoder()) {
    self.session = session
    self.decoder = decoder
    decoder.keyDecodingStrategy = .convertFromSnakeCase
  }
}

extension WeatherProvider: WeatherProviderProtocol {
  
  func getCurrent(_ location: String) async throws -> WeatherInfo {
    let url = URL(string: "\(baseUrl)/current.json?key=0234565d86f6411a813234329252701&q=\(location)")!
    
    let request = URLRequest(url: url)
    
    let (data, response) = try await session.data(for: request)
    
    guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
      throw URLError(.badServerResponse)
    }
    
    do {
      let decodedResponse = try decoder.decode(CurrentWeatherResponse.self, from: data)
      return decodedResponse.weatherInfo
    } catch {
      print(error)
      throw URLError(.resourceUnavailable)
    }
  }
  
  func search(_ searchString: String) async throws -> [SearchResult] {
    let url = URL(string: "\(baseUrl)/search.json?key=0234565d86f6411a813234329252701&q=\(searchString)")!
    
    let request = URLRequest(url: url)
    
    let (data, response) = try await session.data(for: request)
    
    guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
      throw URLError(.badServerResponse)
    }
    
    do {
      let decodedResponse = try decoder.decode([SearchResult].self, from: data)
      return decodedResponse
    } catch {
      print(error)
      throw URLError(.resourceUnavailable)
    }
  }
}
