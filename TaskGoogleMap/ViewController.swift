//
//  ViewController.swift
//  TaskGoogleMap
//
//  Created by kiran on 9/10/18.
//  Copyright © 2018 kiran. All rights reserved.
//

import UIKit
import GoogleMaps
import Alamofire
//import CoreLocation

//struct Currently {
//    let time: Int?
//    let summary: Summary?
//    let icon: Icon?
//    let nearestStormDistance, nearestStormBearing: Int?
//    let precipIntensity, precipProbability, temperature, apparentTemperature: Double?
//    let dewPoint, humidity, pressure, windSpeed: Double?
//    let windGust: Double?
//    let windBearing: Int?
//    let cloudCover: Double?
//    let uvIndex, visibility: Int?
//    let ozone: Double?
//    let precipType: PrecipType?
//}

//struct PlaceDetails {
//    var placeName: String?
//    var placeSubTitle: String?
//    var PlaceTemperature: String?
//}


class ViewController: UIViewController, GMSMapViewDelegate, CLLocationManagerDelegate {
    @IBOutlet weak var mapView: GMSMapView!
    //  let location = "Kathmandu"
    var infoDict:[String: String] = ["place": "", "temp": ""]
    let baseUrl: String = "https://api.darksky.net/forecast"
    let apiKey: String = "/1d6d475e106d8a7d3a9cc31068ce46a2/"
    // let Url = "https://api.darksky.net/forecast/1d6d475e106d8a7d3a9cc31068ce46a2/37.8267,-122.4233"
    //   let locationManager = CLLocationManager()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Create a GMSCameraPosition that tells the map to display the
        // coordinate -33.86,151.20 at zoom level 6.
        let camera = GMSCameraPosition.camera(withLatitude: -33.86, longitude: 151.20, zoom: 10.0)
        let mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        mapView.mapType = .satellite
        view = mapView
        mapView.delegate = self
    }
    
    func getWeatherData(url: String) {
        Alamofire.request(url, method: .get).responseJSON { (response) in
            if   let weatherJson  = response.result.value as? NSDictionary {
                // print(weatherJson)
                let currentWeather = weatherJson["currently"] as! NSDictionary
                let temp = currentWeather["temperature"]
                print("temp: \(temp ?? 0)")
                let temperature = "Current Temperature : \(temp ?? 0) ℉"
                self.infoDict["temp"] = temperature
                print(temperature)
                
                
            } else {
                print("cant get weather data . something went wrong")
            }
            
        }
        
    }
    
    func getLocationFromCoordinaties(latitude: Double, longitude: Double) {
        let geoCoder = CLGeocoder()
        let location = CLLocation(latitude: latitude, longitude: longitude)
        geoCoder.reverseGeocodeLocation(location) { (placemarks, error) in
            if error != nil {
                print("reverse geodcode fail: \(error!.localizedDescription)")
            }
            let pm = placemarks! as [CLPlacemark]
            if pm.count > 0 {
                let pm = placemarks![0]
                //                print(pm.country)
                //                print(pm.locality)
                //                print(pm.subLocality)
                //                print(pm.thoroughfare)
                //                print(pm.postalCode)
                //                print(pm.subThoroughfare)
                var addressString : String = ""
                if pm.subLocality != nil {
                    addressString = addressString + pm.subLocality! + ", "
                }
                if pm.thoroughfare != nil {
                    addressString = addressString + pm.thoroughfare! + ", "
                }
                if pm.locality != nil {
                    addressString = addressString + pm.locality! + ", "
                }
                if pm.country != nil {
                    addressString = addressString + pm.country! + ", "
                }
                if pm.postalCode != nil {
                    addressString = addressString + pm.postalCode! + " "
                }
                print(addressString)
                self.infoDict["place"] = addressString
                
            }
            
        }
        
    }

    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        print("You tapped at \(coordinate.latitude), \(coordinate.longitude)")
        let lat = coordinate.latitude
        let long = coordinate.longitude
        let Url = ("\(baseUrl)" + "\(apiKey)" + "\(lat)" + "," + "\(long)")
        self.getLocationFromCoordinaties(latitude: lat, longitude: long)
        self.getWeatherData(url: Url)
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: lat  , longitude: long)
        marker.title = infoDict["place"]
        marker.snippet = infoDict["temp"]
//        marker.title = "TITLE"
//        marker.snippet = "SUBTITE"
        marker.map = mapView
        
    }
    
//    func showMarker(latitude: Double, longitude: Double){
//        let marker = GMSMarker()
//        marker.position = CLLocationCoordinate2DMake(latitude, longitude)
//        marker.title = "Palo Alto"
//        marker.snippet = "San Francisco"
//        marker.map = mapView
//    }
//

}


/*
 MARK:   locationUpdateFromString(placeName: location)
 
 locationManager.delegate = self
 locationManager.desiredAccuracy = kCLLocationAccuracyBest
 locationManager.requestAlwaysAuthorization()
 locationManager.startUpdatingLocation()
 */


/*
 func locationUpdateFromString(placeName: String) {
 let geoCoder = CLGeocoder()
 geoCoder.geocodeAddressString(placeName) { (placemarks, error) in
 guard let location = placemarks?.first?.location else {
 print ("something went wrong with placename , cant find any such place ")
 return
 }
 let lat = location.coordinate.latitude
 let long = location.coordinate.longitude
 let Url = ("\(baseUrl)" + "\(apiKey)" + "\(lat)" + "," + "\(long)")
 self.getWeatherData(url: Url)
 
 } */

