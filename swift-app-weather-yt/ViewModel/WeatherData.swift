//
//  WeatherData.swift
//  swift-app-weather-yt
//
//  Created by Mansour Mahamat-Salle on 2024-04-26.
//

import Foundation
import CoreLocation


struct WeatherData {
    let locationName: String
    let temperature: Double
    let condition: String
}


struct WeatherResponse : Codable {
    let name: String
    let main : MainWeather
    let weather : [Weather]
}

struct MainWeather: Codable  {
    let temp: Double
}

struct Weather:  Codable {
    let description: String
}



class LocationDataManager: NSObject, ObservableObject, CLLocationManagerDelegate {

    
    // Create a location manager.
    private let locationManager = CLLocationManager()
    @Published var location : CLLocation?
    
    
    override init() {
        super.init()
        
        // Configure the location manager.
        locationManager.delegate = self
    }
    
    //Ask user location
    
    func requestLocation() {
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        guard let location = locations.last else {return}
        
        self.location = location
        
        locationManager.stopUpdatingLocation()
    }
    
    
    
    // if error
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
    
        print(error.localizedDescription)
    }
    
    
    
    
    // Location-related properties and methods.
}


