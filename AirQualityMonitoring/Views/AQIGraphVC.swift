//
//  AQIGraphVC.swift
//  AirQualityMonitoring
//
//  Created by Paresh Navadiya on 05/12/21.
//

//** AQIGraphVC view class does is :**
//1. In ListVC screen, when user taps on UITableViewCell then this screen is shown.
//2. Selected city's history data is shown in chart representation.

import UIKit
import RxSwift
import RxCocoa
import Charts

class AQIGraphVC: UIViewController {
    //CityDataModel instance
    var cityModel: CityDataModel = CityDataModel(city: "")
    
    //DetailViewModel instance
    private var viewModel: DetailViewModel?
    
    //Thread safe bag that disposes added disposables on `deinit`.
    private var bag = DisposeBag()
    
    //LineChartView instance
    private let chartView = LineChartView()
    
    //All data entries for LineChartView
    var dataEntries = [ChartDataEntry]()

    // Determine how many dataEntries show up in the chartView
    var xValue: Double = 20
    
    //Life cycle method
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel = DetailViewModel(dataProvider: DataProvider())
        
        self.title = cityModel.city
        
        view.addSubview(chartView)
        chartView.xAxis.axisMinimum = 1
        chartView.noDataText = "No data available"
        
        chartView.translatesAutoresizingMaskIntoConstraints = false
        chartView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        chartView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        chartView.widthAnchor.constraint(equalToConstant: view.frame.width - 32).isActive = true
        chartView.heightAnchor.constraint(equalToConstant: 300).isActive = true
        
        setupInitialDataEntries()
        
        setupChartData()
        
        bindData()
    }
    
    //Bind CityDataModel's item to get updated data
    func bindData() {
     
        viewModel?.item.bind { model in
        
            if let v = model.history.last?.value {
                let roundingValue: Double = Double(round(v * 100) / 100.0)
                
                let newDataEntry = ChartDataEntry(x: self.xValue,
                                                  y: Double(roundingValue))
                self.updateChartView(with: newDataEntry, dataEntries: &self.dataEntries)
                self.xValue += 1
            }
                
        }.disposed(by: bag)
    }
    
    //Life cycle method
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // subscribe
        viewModel?.subscribe(forCity: cityModel.city)
        
    }
    
    //Life cycle method
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // unsubscribe
        viewModel?.unsubscribe()
    }
    
    //Life cycle method
    deinit {
    }
}

// Graph UI
extension AQIGraphVC {
    
    //Set intial entries so blank chart is loaded
    func setupInitialDataEntries() {
        let totaValues = 0..<Int(xValue)
        for _ in totaValues {
            //print(Double(value))
            let dataEntry = ChartDataEntry(x: 0, y: 0)
            dataEntries.append(dataEntry)
        }
    }
    
    //Set LineChartDataSet according to requirement
    func setupChartData() {
        // 1
        let chartDataSet = LineChartDataSet(entries: dataEntries, label: "AQI for " + self.cityModel.city)
        chartDataSet.drawCirclesEnabled = true
        chartDataSet.drawFilledEnabled = true
        chartDataSet.drawIconsEnabled = true
        chartDataSet.setColor(.systemBlue)
        chartDataSet.mode = .linear
        chartDataSet.setCircleColor(.systemBlue)
        if let font = UIFont(name: "Helvetica Neue", size: 10) {
            chartDataSet.valueFont = font
        }
            
        // 2
        let chartData = LineChartData(dataSet: chartDataSet)
        chartView.data = chartData
        chartView.xAxis.labelPosition = .bottom
    }
    
    //Helper method to bindData() for updating new city's history data
    func updateChartView(with newDataEntry: ChartDataEntry, dataEntries: inout [ChartDataEntry]) {
        // 1
        if let oldEntry = dataEntries.first {
            dataEntries.removeFirst()
            chartView.data?.removeEntry(oldEntry, dataSetIndex: 0)
        }
        
        // 2
        dataEntries.append(newDataEntry)
        chartView.data?.addEntry(newDataEntry, dataSetIndex: 0)
            
        // 3
        chartView.notifyDataSetChanged()
        chartView.moveViewToX(newDataEntry.x)
    }
    
}
