//
//  WebilePlaces.swift
//  Webile
//
//  Created by Siva on 30/07/19.
//  Copyright © 2019 Siva. All rights reserved.
//



import UIKit
import GoogleMaps
import GooglePlaces

public final class LocationHelper: NSObject {
    
    static let sharedInstance = LocationHelper()
    var googlePlacesClient : GMSPlacesClient?
    private override init() {
        googlePlacesClient = GMSPlacesClient()
    }
    
    func googlePlacesAutocomplete(address: String, token: GMSAutocompleteSessionToken, onAutocompleteCompletionHandler: @escaping (_ keys: [MyAddress]) -> Void) {
        let filter = GMSAutocompleteFilter()
        filter.type = .establishment
        filter.country = "IN"
        var bounds: GMSCoordinateBounds? = nil
        let location1Bounds = CLLocationCoordinate2DMake(Double(17.3850), Double(78.4867))
        let location2Bounds = CLLocationCoordinate2DMake(Double(17.3850), Double(80.4867))
        bounds = GMSCoordinateBounds(coordinate: location1Bounds, coordinate: location2Bounds)
        googlePlacesClient?.findAutocompletePredictions(fromQuery: address, bounds: bounds, boundsMode: .bias, filter: filter, sessionToken: token, callback: { (autocompletePredictions, error) in
            var filteredPredictions:[MyAddress] = []
            if let autocompletePredictions = autocompletePredictions {
                for prediction in autocompletePredictions {
                    let newAddress = MyAddress(name: prediction.placeID)
                    filteredPredictions.append(newAddress)
                }
            }
            onAutocompleteCompletionHandler(filteredPredictions)
        })
    }
    
    
    func getPlaceData(_ place_id : String, completion: @escaping (MyAddress?, Error?)->()){
        let placesClient = GMSPlacesClient.shared()
        // Specify the place data types to return.
        placesClient.lookUpPlaceID(place_id as String) { (place, error) in
            if error != nil {
                completion(nil, error)
                return
            }
            if let place = place {
                let newAddress = MyAddress(name: place.placeID ?? "")
                completion(newAddress,nil)
            }
            else {
                NSLog("No place details for: \(place_id) ")
            }
        }
        
    }
}


struct MyAddress {
    var name: String
    init(name: String) {
        self.name = name
    }
}
