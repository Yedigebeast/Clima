//
//  ViewController.swift
//  Clima
//
//  Created by Yedige Ashirbek on 29.05.2022.
//

import UIKit
import CoreLocation

class WeatherViewController: UIViewController {

    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var searchTextFeild: UITextField!
    
    var weatherManager = WeatherManager()
    var locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        weatherManager.delegate = self
        searchTextFeild.delegate = self
        
    }

}

//MARK: - CLLocationManagerDelegate

extension WeatherViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
    
        print("error:: \(error.localizedDescription)")
    
    }

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            locationManager.requestLocation()
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {

        if let location = locations.last {
            
            locationManager.stopUpdatingLocation()
            let lat = location.coordinate.latitude
            let lon = location.coordinate.longitude
            weatherManager.fetchWeather(latitude: lat, longitude: lon)
            
        }
        
    }
    
    @IBAction func currentLocationButtonPressed(_ sender: UIButton) {
    
        locationManager.requestLocation()
        
    }

}

//MARK: - UITextFieldDelegate

extension WeatherViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        searchTextFeild.endEditing(true)
        return true
        
    }
    
    @IBAction func searchButton(_ sender: UIButton) {
    
        searchTextFeild.endEditing(true)
        
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        
        if textField.text != "" {
            textField.placeholder = "Search"
            return true
        } else {
            textField.placeholder = "Type Something"
            return false
        }
        
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        
        if let city = searchTextFeild.text {
            weatherManager.fetchWeather(cityName: city)
        }
        searchTextFeild.text = ""
        
    }
    
}

//MARK: - WeatherManagerDelegate

extension WeatherViewController: WeatherManagerDelegate {
    
    func didUpdateWeather(_ weatherManager:WeatherManager, weather: WeatherModel) {
        
        DispatchQueue.main.async {

            self.temperatureLabel.text = weather.temperatureString
            self.cityLabel.text = weather.cityName
            self.conditionImageView.image = UIImage(systemName: weather.conditionName)
            
        }
        
    }
    
    func didFailWithError(error: Error) {
        
        print(error)
        
    }
    
}
