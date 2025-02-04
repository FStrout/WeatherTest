//
//  SearchResponse.swift
//  WeatherTest
//
//  Created by Fred Strout on 2/3/25.
//

import Foundation

struct SearchResult: Decodable {
  let country: String
  let name: String
  let region: String
}
