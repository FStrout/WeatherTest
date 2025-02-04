//
//  ContentView.swift
//  WeatherTest
//
//  Created by Fred Strout on 2/3/25.
//

import SwiftUI

struct CurrentWeatherView: View {
  
  @ObservedObject var viewModel = CurrentWeatherViewModel()
  @State var searchText: String = .empty
  
  var body: some View {
    VStack {
      HStack {
        TextField("Search Location", text: $searchText)
          .padding()
        Spacer()
        Button {
          viewModel.searchButtonTapped(searchText)
        } label: {
          Image.magnifyingGlass
            .foregroundColor(.gray.opacity(0.5))
            .padding(.trailing, 16)
        }
      }
      .background {
        RoundedRectangle(cornerRadius: 8)
          .fill(Color.gray.opacity(0.1))
      }
      .padding()
      
      switch viewModel.viewType {
      case .empty:
        emptyView
      case .error:
        emptyView
      case .list:
        searchList
      case .location:
        if let location = viewModel.selectedWeatherInfo {
          locationView(location)
        } else {
          emptyView
        }
      case .noCitySelected:
        noCitySelectedView
      case .loading:
        loadingView
      }
    }
    .alert(
      "Something went wrong.",
      isPresented:Binding<Bool>(
        get: {
          self.viewModel.viewType == .error
        },
        set: { _ in
          self.viewModel.viewType = .empty
        }
      )
    ) {}
    message: {
      Text("Please try again later.")
    }
  }
  
  var emptyView: some View {
    VStack(spacing: .zero) {
      Spacer()
      EmptyView()
      Spacer()
    }
  }
  
  func locationView(_ item: WeatherInfo) -> some View {
    VStack(spacing: 24) {
      AnyView(item.conditionImage)
        .frame(height: 124)
      HStack {
        Text(item.city)
          .font(.system(size: 30, weight: .bold))
        Image.location
          .font(.system(size: 24, weight: .bold))
      }
      HStack(alignment: .top) {
        Text(item.temp)
          .font(.system(size: 68, weight: .bold))
        Image.circle
          .resizable()
          .aspectRatio(contentMode: .fit)
          .frame(width: 6, height: 6)
          .padding(.top, 12)
          .fontWeight(.bold)
      }
      
      HStack(spacing: 48) {
        otherDetail(label: "Humidity", value: "\(item.humidity)%")
        otherDetail(label: "UV", value: item.uv)
        otherDetail(label: "Feels Like", value: "\(item.feelsLike)°")
      }
      .padding(20)
      .background {
        RoundedRectangle(cornerRadius: 16)
          .fill(Color.gray.opacity(0.1))
      }
      Spacer()
    }
    .padding(.top, 56)
  }
  
  func otherDetail(label: String, value: String) -> some View {
    VStack(alignment: .center) {
      Text(label)
        .font(.system(size: 14, weight: .medium))
        .foregroundStyle(Color.gray.opacity(0.6))
        .padding(.bottom, 4)
      Text(value)
        .font(.system(size: 16, weight: .bold))
        .foregroundStyle(Color.gray)
    }
  }
  
  var noCitySelectedView: some View {
    VStack {
      Spacer()
      Text("No City Selected")
        .font(.system(size: 30, weight: .bold))
      Text("Please Serach For A City")
        .padding(.bottom, 120)
      Spacer()
    }
  }
  
  var loadingView: some View {
    VStack(spacing: .zero) {
      Spacer()
      ProgressView()
      Spacer()
    }
  }
  
  var searchList: some View {
    ScrollView {
      ForEach(viewModel.weatherInfo) { searchTile(item: $0) }
    }
  }
  
  func searchTile(item: WeatherInfo) -> some View {
    HStack(alignment: .center, spacing: .zero) {
      VStack(alignment: .center, spacing: 6) {
        Text(item.city)
          .font(.system(size: 20, weight: .bold))
        HStack(alignment: .top) {
          Text(item.temp)
            .font(.system(size: 60, weight: .bold))
          Image.circle
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 6, height: 6)
            .padding(.top, 12)
            .fontWeight(.bold)
        }
      }
      .padding(.vertical, 16)
      Spacer()
      AnyView(item.conditionImage)
        .padding(.vertical, 24)
    }
    .padding(.horizontal, 32)
    .background {
      RoundedRectangle(cornerRadius: 16)
        .fill(Color.gray.opacity(0.1))
    }
    .frame(height: 136)
    .padding(.horizontal, 16)
    .padding(.vertical, 8)
    .onTapGesture {
      viewModel.selectLocation(item)
      searchText = .empty
    }
  }
}

#Preview {
  CurrentWeatherView()
}
