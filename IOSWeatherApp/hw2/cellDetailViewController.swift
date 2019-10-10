//
//  cellDetailViewController.swift
//  hw2
//
//  Created by 邓荔文 on 9/19/19.
//  Copyright © 2019 liwen. All rights reserved.
//
import Foundation
import UIKit
import Alamofire
import SwiftyJSON
import NVActivityIndicatorView
import CoreLocation
import MapKit

class cellDetailViewController: UIViewController, CLLocationManagerDelegate {
    @IBOutlet weak var map: MKMapView!
    @IBOutlet weak var cities: UILabel!
    @IBOutlet weak var weather: UILabel!
    @IBOutlet weak var degree: UILabel!
    @IBOutlet weak var humidity: UILabel!
    @IBOutlet weak var weatherImage: UIImageView!
    @IBOutlet weak var day: UILabel!
    @IBOutlet weak var background: UIView!
    @IBOutlet weak var realHumidity: UILabel!
    @IBOutlet weak var pressure: UILabel!
    
    @IBOutlet weak var max: UILabel!
    @IBOutlet weak var min: UILabel!
    var lat: String?
    var lon: String?
    
    let gradientLayer = CAGradientLayer()
    // apikey from openweathermap.org
    let apiKey = "b49d27ea81ec880cd29cea09b5d416ed"
    // longtitude and altitude
    //durham

    //location
    var activityIndicator: NVActivityIndicatorView!
    //get user's location
    let locationManager = CLLocationManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        background.layer.addSublayer(gradientLayer)
        
        let indicatorSize: CGFloat = 70
        let indicatorFrame = CGRect(x: (view.frame.width-indicatorSize)/2, y: (view.frame.height-indicatorSize)/2, width: indicatorSize, height: indicatorSize)
        
        activityIndicator = NVActivityIndicatorView(frame: indicatorFrame, type: .lineScale, color: UIColor.white, padding: 20.0)
        activityIndicator.backgroundColor = UIColor.black
        
        view.addSubview(activityIndicator)

        locationManager.requestWhenInUseAuthorization()

        activityIndicator.startAnimating()
        if(CLLocationManager.locationServicesEnabled()){
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
        }
        var currentLon = "10"
        var currentLat = "10"
        currentLat = self.lat!
        currentLon = self.lon!
        self._initMapKit()
    Alamofire.request("http://api.openweathermap.org/data/2.5/weather?lat=\(currentLat)&lon=\(currentLon)&appid=\(apiKey)&units=metric").responseJSON {
            response in
            print("incell")
            self.activityIndicator.stopAnimating()
            if let responseStr = response.result.value {
                print("check")

                let jsonResponse = JSON(responseStr)
                let jsonWeather = jsonResponse["weather"].array![0]
                let jsonTemp = jsonResponse["main"]
                let iconName = jsonWeather["icon"].stringValue
                let visibility = jsonResponse["visibility"].stringValue
                print(jsonResponse)
                let humidity = Double(visibility)!/1000.0
                let realhu = jsonTemp["humidity"].stringValue
                let pressure = jsonTemp["pressure"].stringValue
                self.cities.text = jsonResponse["name"].stringValue
                self.weatherImage.image = UIImage(named: iconName)
                self.weather.text = jsonWeather["main"].stringValue
                self.degree.text = "\(Int(round(jsonTemp["temp"].doubleValue)))"
                self.min.text = "\(Int(round(jsonTemp["temp_min"].doubleValue)))"
                self.max.text = "\(Int(round(jsonTemp["temp_max"].doubleValue)))"
                self.humidity.text = "\(humidity) km"
                self.realHumidity.text = "\(realhu)%"
                self.pressure.text = "\(pressure) hpa"
                let date = Date()
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "EEEE"
                self.day.text = dateFormatter.string(from: date)

                let suffix = iconName.suffix(1)
                if(suffix == "n"){
                    self.setGreyGradientBackground()
                }else{
                    self.setBlueGradientBackground()
                }
            }
        }
//         Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        setBlueGradientBackground()
    }
    
    private func _initMapKit() {
        let lati = self.lat
        let lonti = self.lon
        let location = CLLocationCoordinate2D(latitude: (Double(lati!))!,
                                              longitude: (Double(lonti!)!))

        let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        let region = MKCoordinateRegion(center: location, span: span)
        map.setRegion(region, animated: true)

        let annotation = MKPointAnnotation()
        annotation.coordinate = location
        annotation.title = self.weather.text
        annotation.subtitle = "US"
        map.addAnnotation(annotation)
    }


//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//
//        self.locationManager.stopUpdatingLocation()
//    }
//
//    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
//        print(error.localizedDescription)
//    }

    func setBlueGradientBackground(){
        let topColor = UIColor(red: 95.0/255.0, green: 165.0/255.0, blue: 1.0, alpha: 1.0).cgColor
        let bottomColor = UIColor(red: 72.0/255.0, green: 114.0/255.0, blue: 184.0/255.0, alpha: 1.0).cgColor
        gradientLayer.frame = view.bounds
        gradientLayer.colors = [topColor, bottomColor]
    }

    func setGreyGradientBackground(){
        let topColor = UIColor(red: 151.0/255.0, green: 151.0/255.0, blue: 151.0/255.0, alpha: 1.0).cgColor
        let bottomColor = UIColor(red: 72.0/255.0, green: 72.0/255.0, blue: 72.0/255.0, alpha: 1.0).cgColor
        gradientLayer.frame = view.bounds
        gradientLayer.colors = [topColor, bottomColor]
    }
    /*
     MARK: - Navigation

     In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
         Get the new view controller using segue.destination.
         Pass the selected object to the new view controller.
    }
    */

}
