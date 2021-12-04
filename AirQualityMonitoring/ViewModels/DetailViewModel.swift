//
//  DetailViewModel.swift
//  AirQualityMonitoring
//
//  Created by Paresh Navadiya on 02/12/21.
//

import Foundation
import RxSwift
import RxCocoa
import Starscream

//** DetailViewModel class does is :**
//1. DataProvider provides response data
//2. Parse response data
//3. Inform item binding implementer for data updation


class DetailViewModel {
    //City name
    private var city: String = ""
    //Current city selected
    var prevItem: CityDataModel? = nil
    //Binding publish subject for recieving updates
    var item = PublishSubject<CityDataModel>()
    //DataProvider instance
    var provider: DataProvider?
    //Intialize method
    init(dataProvider: DataProvider) {
        provider = dataProvider
        provider?.delegate = self
    }
    //Subscribe to recieve city's updated history data
    func subscribe(forCity: String) {
        self.city = forCity
        provider?.subscribe()
    }
    //Unsubscribe to stop recieving city's updated history data
    func unsubscribe() {
        provider?.unsubscribe()
    }
}

extension DetailViewModel: DataProviderDelegate {
    
    //Recieved response from DataProvider
    func didReceive(response: Result<[AQIResponseData], Error>) {
        switch response {
        
        case .success(let response):
            parseAndNotify(resArray: response)
        
        case .failure(let error):
            handleError(error: error)
        }
    }
    
    //Helper to didReceive() method for parsing data
    func parseAndNotify(resArray: [AQIResponseData]) {
        
        let cityData = resArray.filter { $0.city == city }
        if let data = cityData.first {
            if let prev = prevItem {
                prev.history.append(AQIModel(value: data.aqi, date: Date()))
            } else {
                prevItem = CityDataModel(city: self.city)
                prevItem?.history.append(AQIModel(value: data.aqi, date: Date()))
            }
        } else {
            if let prev = prevItem, let last = prev.history.last {
                prev.history.append(last)
            }
        }
    
        if let p = prevItem {
            item.onNext(p)
        }
    }
    
    //Helper to didReceive() method for error handling
    func handleError(error: Error?) {
        if let e = error {
            item.onError(e)
        }
    }
}
