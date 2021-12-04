//
//  ListViewModel.swift
//  AirQualityMonitoring
//
//  Created by Paresh Navadiya on 02/12/21.
//

//** ListViewModel class does is :**
//1. DataProvider provides response data
//2. Parse response data
//3. Inform items binding implementer for data updation

import Foundation
import RxSwift
import RxCocoa

class ListViewModel {
    
    //All city data
    var prevItems: [CityDataModel] = [CityDataModel]()
    //Binding publish subject for recieving updates
    var items = PublishSubject<[CityDataModel]>()
    //DataProvider instance
    var provider: DataProvider?
    
    //Intialize with data provider
    init(dataProvider: DataProvider) {
        provider = dataProvider
        provider?.delegate = self
    }
    
    //Subscribe to recieve city's updated history data
    func subscribe() {
        provider?.subscribe()
    }
    
    //Unsubscribe to stop recieving city's updated history data
    func unsubscribe() {
        provider?.unsubscribe()
    }
}

extension ListViewModel: DataProviderDelegate {
    
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
        
        if prevItems.count == 0 {
            for d in resArray {
                let m = CityDataModel(city: d.city)
                m.history.append(AQIModel(value: d.aqi, date: Date()))
                prevItems.append(m)
            }
        } else {
        
            for res in resArray {
                let matchedResults = prevItems.filter { $0.city == res.city }
                if let matchedRes = matchedResults.first {
                    matchedRes.history.append(AQIModel(value: res.aqi, date: Date()))
                } else {
                    let m = CityDataModel(city: res.city)
                    m.history.append(AQIModel(value: res.aqi, date: Date()))
                    prevItems.append(m)
                }
            }
        }
                                                        
        items.onNext(prevItems)
    }
    
    //Helper to didReceive() method for error handling
    func handleError(error: Error?) {
        if let e = error {
            items.onError(e)
        }
    }
}
