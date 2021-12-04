//
//  AQIResponseData.swift
//  AirQualityMonitoring
//
//  Created by Paresh Navadiya on 02/12/21.
//

//** AQIResponseData model class does is :**
//1. Used when websocket response is provided

import Foundation

struct AQIResponseData: Codable {
    //City name
    var city: String
    //Air quality index value
    var aqi: Float
    //Intialize method
    init(city: String, aqi: Float) {
        self.city = city
        self.aqi = aqi
    }
}
