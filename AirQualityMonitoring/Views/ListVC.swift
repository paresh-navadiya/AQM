//
//  ListVC.swift
//  AirQualityMonitoring
//
//  Created by Paresh Navadiya on 03/12/21.
//

//** ListVC view class does is :**
//1. This is first screen or home page after launch screen
//2. City wise air quality index data is mapped in CityDataModel which is displayed in UITableView
//3. User can view city's history data in chart representation by tapping on UITableViewCell
//4. There is a button on right of navigation bar to go info screen where user can see color respresentation based on air quality index data

import UIKit
import RxSwift
import RxCocoa

class ListVC: UIViewController {
    
    //Model instance
    private var viewModel: ListViewModel?
    
    //Thread safe bag that disposes added disposables on `deinit`.
    private var bag = DisposeBag()
    
    //UITableView instance
    @IBOutlet var tableView: UITableView!
    
    //Life cycle method
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Bar button item for info screen
        let infoBarButtonItem = UIBarButtonItem(image: UIImage(named: "info"), style: .done, target: self, action: #selector(infoTapped))
        //Use in UITest for button action
        //infoBarButtonItem.accessibilityLabel = "infoNavBarRightItem"
        infoBarButtonItem.accessibilityIdentifier = "infoNavBarRightItem"
        infoBarButtonItem.isAccessibilityElement = true
        //Set right bar button item
        self.navigationItem.rightBarButtonItem = infoBarButtonItem    
        
        //Use in UITest for table view
        tableView.accessibilityIdentifier = "table--cityTableView"
        
        //Model provided for table
        viewModel = ListViewModel(dataProvider: DataProvider())
        
        //Bind data to table
        bindTableData()
    }

    //Bind ListViewModel's items to get updated CityDataModel data. Also tapping on cell is handled here
    func bindTableData() {
        
        // bind items to table
        viewModel?.items.bind(to: tableView.rx.items(cellIdentifier: "CityDataCell", cellType: CityDataCell.self)) {row, model, cell in
            
            cell.cityData = model
            
        }.disposed(by: bag)
        
        // bind a model selected handler
        tableView.rx.modelSelected(CityDataModel.self).bind { item in
            
            let cityDetail: AQIGraphVC = self.storyboard?.instantiateViewController(identifier: "AQIGraphVC") as! AQIGraphVC
            cityDetail.cityModel = item
            self.navigationController?.pushViewController(cityDetail, animated: true)            
            
        }.disposed(by: bag)
        
        
        // set delegate
        tableView
            .rx.setDelegate(self)
            .disposed(by: bag)
    }
    
    //Life cycle method
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // subscribe to AQIs Socket Connection
        viewModel?.subscribe()
    }
    
    //Life cycle method
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // unsubscribe
        viewModel?.unsubscribe()
    }
    
    //IBAction for right navigation bar item for info screen
    @objc func infoTapped(_ barButtonItem: UIBarButtonItem) {
        let infoDetail: AQIInfoVC = self.storyboard?.instantiateViewController(identifier: "AQIInfoVC") as! AQIInfoVC
        self.navigationController?.pushViewController(infoDetail, animated: true)
    }
    
    //Life cycle method
    deinit {
        // unsubscribe
        viewModel?.unsubscribe()
    }
    
}

//Delegate methods for UI changes in table view
extension ListVC: UITableViewDelegate {
    //Cell height is defined by this delegate method
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90.0
    }
}

