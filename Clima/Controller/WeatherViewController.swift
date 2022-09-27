
//  ViewController.swift
//  Clima
//  Created by Angela Yu on 01/09/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
import UIKit
import CoreLocation
class WeatherViewController: UIViewController {
    
    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var searchTextField: UITextField!
    var weatherManager = WeatherManager()
    let locaionManager = CLLocationManager()
    override func viewDidLoad() {
        super.viewDidLoad()
       
        locaionManager.delegate = self
        locaionManager.requestWhenInUseAuthorization()
        locaionManager.requestLocation()
        
        searchTextField.delegate = self
        weatherManager.delegate = self
      
 
    
        // Do any additional setup after loading the view.
    }
    
    @IBAction func LocationPressed(_ sender: UIButton) {
        locaionManager.requestLocation()
    }
}
//MARK: - UITextFeildDelegate
extension WeatherViewController:UITextFieldDelegate{
    @IBAction func searchPressed(_ sender: UIButton) {
        searchTextField.endEditing(true)
        print(searchTextField.text!)
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchTextField.endEditing(true)
        print(searchTextField.text!)
        return true
    }
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if (textField.text != "") {
            return true
        }
        else{
            textField.placeholder = "Enter the city name"
            return false
        }
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let city = searchTextField.text {
            weatherManager.fetchWeather(cityName: city)
        }
        searchTextField.text=""
    }
}
//MARK: - WeatherManagerDelegate
extension WeatherViewController:WeatherManagerDelegate{
     func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel ) {
         DispatchQueue.main.async {
             self.temperatureLabel.text = weather.tempratureString
             self.conditionImageView.image = UIImage(systemName: weather.conditonName)
             self.cityLabel.text = weather.cityName
         }
     }
     func didFailWithError(error: Error) {
         print(error)
     }
}
//MARK: - LocationManagerDelegate
extension WeatherViewController:CLLocationManagerDelegate{
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last{
            locaionManager.stopUpdatingLocation()
            let lat = location.coordinate.latitude
            let lon = location.coordinate.longitude
            weatherManager.fetchWeather(latitude:lat,longitude:lon)

        }
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}
