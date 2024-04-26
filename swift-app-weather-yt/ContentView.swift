//
//  ContentView.swift
//  swift-app-weather-yt
//
//  Created by Mansour Mahamat-Salle on 2024-04-26.
//

import SwiftUI
import CoreLocation

struct ContentView: View {
    
    @StateObject private var locationManager = LocationDataManager()
    @State private var weatherData: WeatherData?
    
    
    var body: some View {
        VStack {
            if let weatherData = weatherData {
                Text("\(Int(weatherData.temperature)) °C")
                    .font(.custom("", size: 70))
                    .padding()
                
                VStack {
                    Text("\(weatherData.locationName) °C")
                        .font(.title)
                        .padding()
                    
                    Text("\(weatherData.condition)")
                        .font(.title3)
                        .padding()
                    
                }
                
            } else {
                ProgressView()
            }
        }
        .frame(width: 300 ,height: 300 )
        .background(.ultraThinMaterial)
        .cornerRadius(23)
        .padding()
        .onAppear {
            locationManager.requestLocation()
        }
        .onReceive(locationManager.$location) { location in
                   
                   guard let location = location else { return }
            fetchWeather(for: location)
               }
           
    }
    
    private func fetchWeather(for location : CLLocation) {
        let urlString = "https://api.openweathermap.org/data/2.5/weather?lat=\(location.coordinate.latitude)&lon=\(location.coordinate.longitude)&units=metric&appid="
        
        guard let url = URL(string: urlString) else {return}
        
        
        //CALL API
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data else {return}
            
            do {
                let decoder = JSONDecoder()
                let weatherResponse = try decoder.decode(WeatherResponse.self , from: data)
               print(weatherResponse)
                DispatchQueue.main.async {
                    weatherData = WeatherData(locationName: weatherResponse.name, temperature: weatherResponse.main.temp, condition: weatherResponse.weather.first?.description ?? "")
                }
                
                
            } catch {
                print(error.localizedDescription)
            }
        }.resume()
        
        
    }
    
}

#Preview {
    ContentView()
}
