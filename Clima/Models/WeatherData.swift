//
//  WeatherData.swift
//  Clima
//
//  Created by Yedige Ashirbek on 02.06.2022.
//

import Foundation

struct WeatherData: Decodable {
    
    let name: String
    let main: Main
    let weather: [Weather]
    
}

struct Main: Decodable {
    
    let temp: Double
    
}

struct Weather: Decodable {
    
    let id: Int
    
}
