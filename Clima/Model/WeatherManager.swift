//
//  WeatherManager.swift
//  Clima
//
//  Created by Emmanuel George on 19/08/22.
//  Copyright © 2022 App Brewery. All rights reserved.
//

import Foundation
import CoreLocation
protocol WeatherManagerDelegate{
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel )
    func didFailWithError(error:Error)
}
struct WeatherManager {
    let weatherURL =  "https://api.openweathermap.org/data/2.5/weather?&appid=97f7c13f51b0dfb4ac924c8aeafaefa8&units=metric"
    var delegate:WeatherManagerDelegate?
    func fetchWeather (cityName:String) {
        let urlString = ("\(weatherURL)&q=\(cityName)")
        //let urlString = "https://api.openweathermap.org/data/2.5/weather?&appid=myKey&units=metric&q=London"

        performRequest(with: urlString)
    }
    func fetchWeather(latitude:CLLocationDegrees,longitude:CLLocationDegrees){
        let urlString = ("\(weatherURL)&lat=\(latitude)&lon=\(longitude)")
        performRequest(with: urlString)
    }
    func performRequest(with urlString: String) {
        
        //1.  create the URL? (optional)
        
        if let url = URL(string: urlString){
            
            // 2.  create URL Session- the thing that performs like a browser (default)
            
            let session = URLSession(configuration: .default)
            
            // 3.  give session a task;  task waits for data, so uses completion handler
            
            //     as a function()
            
            let task = session.dataTask(with: url) { data, response, error in
                //check for errors here
                
                if error != nil{
                    self.delegate?.didFailWithError(error: error!)
                    print(error!)
                    
                    return  //exit failed
                }
                //optional binding of data
                if let safeData = data {
                    //look at data in web data format utc8
                    
                    if let weather = self.parseJSON( safeData){
                        self.delegate?.didUpdateWeather(self, weather: weather)
                    }
                }
            }
            // 4.  start the task; "resume" because task is initialized as "suspended"
            task.resume()
        }
    }
    func parseJSON(_ weatherData:Data )->WeatherModel?{
     let decoder = JSONDecoder()
        do{
        let decodedData = try decoder.decode(WeatherData.self, from: weatherData)
            let name = decodedData.name
          let temprature = decodedData.main.temp
            let id = decodedData.weather[0].id
     let weather = WeatherModel(cityName: name, temprature: temprature, id: id)
            return weather
        }catch{
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
}
