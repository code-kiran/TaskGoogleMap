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

class InfoModal: NSObject {
    var temp: String?
    var location: String?
    init(temp: String, location: String) {
        self.temp = temp
        self.location = location
    }
}

class ViewController: UIViewController, GMSMapViewDelegate {
    @IBOutlet weak var myTableView: UITableView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var mapView: GMSMapView!
    
    var infoDict = ["temp": "", "place": ""]
    var infoArray:[InfoModal]  = []
    let baseUrl: String = "https://api.darksky.net/forecast"
    let apiKey: String = "/1d6d475e106d8a7d3a9cc31068ce46a2/"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        myTableView.delegate = self
        myTableView.dataSource = self
        // Create a GMSCameraPosition that tells the map to display the
        let camera = GMSCameraPosition.camera(withLatitude: 27.7172, longitude: 85.3240, zoom: 15.0)
        let mapView = GMSMapView.map(withFrame: self.containerView.frame , camera: camera)
        mapView.mapType = .satellite
        self.view.addSubview(mapView)
        //        view = mapView
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
        marker.map = mapView
        self.infoArray.append(InfoModal(temp: (infoDict["temp"])!, location: (infoDict["place"])!))
        myTableView.reloadData()
    }
    
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return infoArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = myTableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as? TblCell
        cell?.locationLable.text = self.infoArray[indexPath.row].location
        cell?.tempLable.text = self.infoArray[indexPath.row].temp
        return cell!
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
}



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

