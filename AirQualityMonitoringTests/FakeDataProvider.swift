//
//  FakeDataProvider.swift
//  AirQualityMonitoringTests
//
//  Created by Paresh Navadiya on 04/12/21.
//

import UIKit
import RxSwift

@testable import AirQualityMonitoring

typealias DataProviderResponse = Result<[AQIResponseData], Error>

class FakeDataProvider: DataProvider {

    private var fakeResponse: DataProviderResponse
    
    var item = PublishSubject<CityDataModel>()
    
    init(fakeResponse: DataProviderResponse) {
        self.fakeResponse = fakeResponse
    }
    
    override func subscribe() {
        notifyFakeResponse()
    }
    
    private func notifyFakeResponse() {
        switch self.fakeResponse {
        case .success(let res):
            self.delegate?.didReceive(response: .success(res))
        case .failure(let error):
            self.delegate?.didReceive(response: .failure(error))
        }
    }
}
