
import Foundation
import CoreLocation

protocol WeatherDelegate {
    func weatherDidUpdate(weather : WeatherModel)
}

struct WeatherManager {
    let weatherURL = "https://api.openweathermap.org/data/2.5/weather?appid=134e468f9c72359b5c30300bd9aa8196&units=metric"
    
    var delegate: WeatherDelegate?
    
    func fetchWeather(cityName: String) {
        let urlString = "\(weatherURL)&q=\(cityName)"
        performRequest(with: urlString)
    }
    
    func fetchWeather(lat:  CLLocationDegrees, lon: CLLocationDegrees){
        let urlString = "\(weatherURL)&lat=\(lat)&lon=\(lon)"
        performRequest(with: urlString)
    }
    
    func performRequest(with urlString: String) {
        if let url = URL(string: urlString) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    print(error!)
                    return
                }
                if let safeData = data {
                    if let weather = self.parseJSON(safeData){
                        self.delegate?.weatherDidUpdate(weather: weather)
                    }
                }
            }
            task.resume()
        }
    }
    
    func parseJSON(_ weatherData: Data) -> WeatherModel?{
        let decoder = JSONDecoder()
        do{
        let decodedData = try decoder.decode(WeatherData.self, from: weatherData)
           let id = decodedData.weather[0].id
           let name = decodedData.name
           let temp = decodedData.main.temp
           let weathermodel = WeatherModel(name: name, temp: temp, id: id)
            return weathermodel
        }
        catch {
            print(error)
            return nil
        }
    }
    }
    
    
    
    



