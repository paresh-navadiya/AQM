//
//  CityDataModel.swift
//  AirQualityMonitoring
//
//  Created by Paresh Navadiya on 02/12/21.
//

//** AQIResponseData model class does is :**
//1. Used when AQIResponseData model  data is coverted into CityDataModel data

import Foundation

class AQIModel {
    //Air quality index value
    var value: Float = 0.0
    //Data on which date recieved
    var date: Date = Date()
    //Intialize method
    init(value: Float, date: Date) {
        //2 decimal point representation
        if let twoPointValue: Float = Float(String(format: "%.2f", value)) {
            self.value = twoPointValue
        }
        self.date = date
    }
}

protocol CityDataModelProtocol {
    //City name
    var city: String { get set }
    //All city's history data
    var history: [AQIModel] { get set }
}

class CityDataModel: CityDataModelProtocol {
    //City name
    var city: String
    //All city's history data
    var history: [AQIModel] = [AQIModel]()
    //Intialize method
    init(city: String) {
        self.city = city
    }
}
