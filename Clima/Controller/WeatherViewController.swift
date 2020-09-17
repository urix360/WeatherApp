import UIKit
import CoreLocation

class WeatherViewController: UIViewController, UITextFieldDelegate ,WeatherDelegate{
    

    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var searchTextField: UITextField!
    
    var weatherManager = WeatherManager()
    var locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        
        weatherManager.delegate = self
        searchTextField.delegate = self
    }
    @IBAction func LocationClick(_ sender: UIButton) {
        locationManager.requestLocation()
    }
    
    //MARK: - textField
    @IBAction func searchPressed(_ sender: UIButton) {
        weatherManager.fetchWeather(cityName: searchTextField.text ?? "")
        searchTextField.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        weatherManager.fetchWeather(cityName: searchTextField.text ?? "")
        searchTextField.endEditing(true)
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField.text != "" {
            return true
        } else {
            textField.placeholder = "Type something"
            return false
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        searchTextField.text = ""
        
    }
    
//MARK: - Weather
    func weatherDidUpdate(weather: WeatherModel) {
        DispatchQueue.main.async {
            self.cityLabel.text = weather.name
            self.conditionImageView.image = UIImage(systemName: weather.condition)
            self.temperatureLabel.text = weather.tempString
        }
    }
    
}

//MARK: - Location
extension WeatherViewController: CLLocationManagerDelegate{
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location :CLLocation = locations.last{
            locationManager.stopUpdatingLocation()
            let lat = location.coordinate.latitude
            let lon = location.coordinate.longitude
            weatherManager.fetchWeather(lat: lat, lon: lon)
        }
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}


