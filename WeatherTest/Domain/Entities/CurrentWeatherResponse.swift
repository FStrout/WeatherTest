//
//  CurrentResponse.swift
//  WeatherTest
//
//  Created by Fred Strout on 2/3/25.
//

import SwiftUI

struct CurrentWeatherResponse: Decodable {
  let location: Location
  let current: Current
  
  struct Current: Decodable {
    let tempF: Double
    let feelslikeF: Double
    let humidity: Int
    let uv: Double
    let condition: Condition
    
    struct Condition: Decodable {
      let text: String
      let icon: String
    }
  }
  
  struct Location: Decodable {
    let country: String
    let name: String
    let region: String
  }
  
  var weatherInfo: WeatherInfo {
    return WeatherInfo(
      id: "\(location.name), \(location.region), \(location.country)",
      city: location.name,
      temp: current.tempF.truncatedString,
      conditionImage: AsyncImage(
        url: URL(string: "https:\(current.condition.icon)"),
        content: { image in
          image
            .resizable()
            .aspectRatio(contentMode: .fit)
        },
        placeholder: {
          Image.photoFill
        }),
      feelsLike: current.feelslikeF.truncatedString,
      humidity: current.humidity.description,
      uv: current.uv.truncatedString
    )
  }
}
