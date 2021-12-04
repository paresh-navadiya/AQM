//
//  CityDataCell.swift
//  AirQualityMonitoring
//
//  Created by Paresh Navadiya on 03/12/21.
//

//** CityDataCell view class does is :**
//1. In ListVC screen, UITableView use this cell.
//2. City's data is represented here.
//3. CityDataModel has changes then it reflected in UI

import UIKit

class CityDataCell: UITableViewCell {
    //City value label
    @IBOutlet var lblCity: UILabel?
    //AQI value label
    @IBOutlet var lblAQI: UILabel?
    //Date value label
    @IBOutlet var lblLastUpdated: UILabel?
    
    //First life cycle method to be called
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        //Label UI changes
        //lblAQI?.layer.cornerRadius = 5
        //lblAQI?.layer.masksToBounds = true
        
        //Cell seperator inset by default is 15px so set zero
        self.separatorInset = UIEdgeInsets.zero

    }

    //CityDataModel use didSet() for cell's UI representation
    var cityData: CityDataModel? {
        didSet {
            //Has city data model
            guard let cityData = cityData else { return }
            //Set city
            lblCity?.text = cityData.city
            //Set background color to clear until new color is calculated based on AQI value or if not found than due to previous colour it's reset.
            self.contentView.backgroundColor = UIColor.clear
            //Has city's history  last data
            if let aqi = cityData.history.last?.value {
                //Set city's air quality index
                lblAQI?.text = String(format: "%.2f", aqi)
                //Set backgroundColor based on AQI value
                let index = AirQualityIndexClassifier.classifyAirQualityIndex(aqi: aqi)
                if let backgroundColor = AirQualityIndexColorClassifier.color(index: index) {
                    //lblAQI?.backgroundColor = backgroundColor
                    self.contentView.backgroundColor = backgroundColor
                }
            }
            //Has city's history last data
            if let date = cityData.history.last?.date {
                //Set date value
                if date.timeAgo() == "0 seconds" {
                    lblLastUpdated?.text = "just now"
                } else {
                    lblLastUpdated?.text = date.timeAgo() + " ago"
                }                
            }
            //Use in UITest for table view cell
            self.accessibilityLabel = cityData.city
            self.accessibilityIdentifier = cityData.city
            self.accessibilityTraits = [.button]
        }
    }
}

//Extension of Date
extension Date {
    //Get string representation value based on date
    func timeAgo() -> String {
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .full
        formatter.allowedUnits = [.year, .month, .day, .hour, .minute, .second]
        formatter.zeroFormattingBehavior = .dropAll
        formatter.maximumUnitCount = 1
        return String(format: formatter.string(from: self, to: Date()) ?? "", locale: .current)
    }
}
