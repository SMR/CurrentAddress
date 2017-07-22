//
//  MapModels.swift
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

enum Map
{
  // MARK: Use cases
  
  enum Something
  {
    struct Request
    {
    }
    struct Response
    {
    }
    struct ViewModel
    {
    }
  }
  
  enum RequestForCurrentLocation
  {
    struct Request
    {
    }
    struct Response
    {
      var success: Bool
    }
    struct ViewModel
    {
      var success: Bool
      var errorTitle: String?
      var errorMessage: String?
    }
  }
  
  enum GetCurrentLocation
  {
    struct Request
    {
      var mapView: MKMapView
    }
    struct Response
    {
      var success: Bool
      var error: NSError?
    }
    struct ViewModel
    {
      var success: Bool
      var errorTitle: String?
      var errorMessage: String?
    }
  }
  
  enum CenterMap
  {
    struct Request
    {
    }
    struct Response
    {
      var coordinate: CLLocationCoordinate2D
    }
    struct ViewModel
    {
      var coordinate: CLLocationCoordinate2D
    }
  }
  
  enum GetCurrentAddress
  {
    struct Request
    {
    }
    struct Response
    {
      var success: Bool
    }
    struct ViewModel
    {
      var success: Bool
    }
  }
}