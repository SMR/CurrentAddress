//
//  MapInteractor.swift
//  CurrentAddress
//
//  Created by Raymond Law on 7/20/17.
//  Copyright (c) 2017 ___ORGANIZATIONNAME___. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit
import MapKit

protocol MapBusinessLogic
{
  func doSomething(request: Map.Something.Request)
  func requestForCurrentLocation(request: Map.RequestForCurrentLocation.Request)
  func getCurrentLocation(request: Map.GetCurrentLocation.Request)
  func centerMap(request: Map.CenterMap.Request)
  func getCurrentAddress(request: Map.GetCurrentAddress.Request)
}

protocol MapDataStore
{
  //var name: String { get set }
  var placemark: MKPlacemark! { get set }
}

class MapInteractor: NSObject, MapBusinessLogic, MapDataStore, CLLocationManagerDelegate, MKMapViewDelegate
{
  var presenter: MapPresentationLogic?
  var worker: MapWorker?
  //var name: String = ""
  let locationManager = CLLocationManager()
  let geocoder = CLGeocoder()
  var centerMapFirstTime = false
  var currentLocation: MKUserLocation?
  var placemark: MKPlacemark!
  
  // MARK: Do something
  
  func doSomething(request: Map.Something.Request)
  {
    worker = MapWorker()
    worker?.doSomeWork()
    
    let response = Map.Something.Response()
    presenter?.presentSomething(response: response)
  }
  
  // MARK: Request for current location
  
  func requestForCurrentLocation(request: Map.RequestForCurrentLocation.Request)
  {
    locationManager.delegate = self
    locationManager.requestWhenInUseAuthorization()
  }
  
  func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus)
  {
    var response: Map.RequestForCurrentLocation.Response
    switch status {
    case .authorizedWhenInUse:
      response = Map.RequestForCurrentLocation.Response(success: true)
    case .restricted, .denied:
      response = Map.RequestForCurrentLocation.Response(success: false)
    default:
      return
    }
    presenter?.presentRequestForCurrentLocation(response: response)
  }
  
  // MARK: Get current location
  
  func getCurrentLocation(request: Map.GetCurrentLocation.Request)
  {
    request.mapView.delegate = self
  }
  
  func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation)
  {
    currentLocation = userLocation
    let response = Map.GetCurrentLocation.Response(success: true, error: nil)
    presenter?.presentGetCurrentLocation(response: response)
  }
  
  func mapView(_ mapView: MKMapView, didFailToLocateUserWithError error: Error)
  {
    currentLocation = nil
    let response = Map.GetCurrentLocation.Response(success: false, error: error as NSError)
    presenter?.presentGetCurrentLocation(response: response)
  }
  
  // MARK: Center map
  
  func centerMap(request: Map.CenterMap.Request)
  {
    if !centerMapFirstTime, let currentLocation = currentLocation {
      let response = Map.CenterMap.Response(coordinate: currentLocation.coordinate)
      presenter?.presentCenterMap(response: response)
      centerMapFirstTime = true
    }
  }
  
  // MARK: Get current address
  
  func getCurrentAddress(request: Map.GetCurrentAddress.Request)
  {
    if let location = currentLocation?.location {
      geocoder.reverseGeocodeLocation(location, completionHandler: { (placemarks, error) in
        var response: Map.GetCurrentAddress.Response
        if let placemark = placemarks?.first {
          if let addressDictionary = placemark.addressDictionary as? [String : Any], let coordinate = placemark.location?.coordinate {
            self.placemark = MKPlacemark(coordinate: coordinate, addressDictionary: addressDictionary)
          }
        }
        if placemarks?.first != nil {
          response = Map.GetCurrentAddress.Response(success: true)
        } else {
          response = Map.GetCurrentAddress.Response(success: false)
        }
        self.presenter?.presentGetCurrentAddress(response: response)
      })
    }
  }
}
