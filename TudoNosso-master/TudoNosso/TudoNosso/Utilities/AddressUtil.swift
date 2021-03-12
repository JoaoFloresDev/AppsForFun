//
//  AddressWorker.swift
//  TudoNosso
//
//  Created by Bruno Cardoso Ambrosio on 13/11/19.
//  Copyright © 2019 Joao Flores. All rights reserved.
//

import Foundation
import CoreLocation

class AddressUtil{
    static func recoveryAddress(fromLocation locationCoordinate:CLLocationCoordinate2D, completion: @escaping (String?, Error?) -> Void) {
        let location:CLLocation = CLLocation(latitude: locationCoordinate.latitude, longitude: locationCoordinate.longitude)
        var address = ""
        CLGeocoder().reverseGeocodeLocation(location, completionHandler: {(locationDetais, error) in
            if error == nil{
                if let locationData = locationDetais?.first {
                    
                    var thoroughfare = ""// rua
                    if let thoroughfareValue = locationData.thoroughfare{
                        thoroughfare = thoroughfareValue
                    }
                    
                    var subThoroughfare = "" //numero
                    if let subThoroughfareValue = locationData.subThoroughfare{
                        subThoroughfare = subThoroughfareValue
                    }
                    
                    var locality = "" //cidade
                    if let localityValue = locationData.locality{
                        locality = localityValue
                    }
                    
                    var subLocality = ""// bairro
                    if let subLocalityValue = locationData.subLocality{
                        subLocality = subLocalityValue
                    }
                    
                    //                    var country = ""
                    //                    if let countryValue = locationData.country{
                    //                        country = countryValue
                    //                    }
                    //
                    //                    var administrativeArea = "" //(UF)
                    //                    if let administrativeAreaValue = locationData.administrativeArea{
                    //                        administrativeArea = administrativeAreaValue
                    //                    }
                    
                    address = thoroughfare + ", "
                        + subThoroughfare + " - "
                        + subLocality + " - "
                        + locality
                    //                        + " - "
                    //                        + administrativeArea + " - "
                    //                        + country
                    
                    completion(address,nil)
                }else{
                    print("\(error?.localizedDescription)")
                    completion(nil,error)
                }
            }
        })
    }
    
    static func recoveryShortAddress(fromLocation locationCoordinate:CLLocationCoordinate2D, completion: @escaping (String?, Error?) -> Void) {
        let location:CLLocation = CLLocation(latitude: locationCoordinate.latitude, longitude: locationCoordinate.longitude)
        var address = ""
        CLGeocoder().reverseGeocodeLocation(location, completionHandler: {(locationDetais, error) in
            if error == nil{
                if let locationData = locationDetais?.first {
                    
                    var locality = "" //cidade
                    if let localityValue = locationData.locality{
                        locality = localityValue
                    }
                    
                    var subLocality = ""// bairro
                    if let subLocalityValue = locationData.subLocality{
                        subLocality = subLocalityValue
                    }
                    
                    var administrativeArea = "" //(UF)
                    if let administrativeAreaValue = locationData.administrativeArea{
                        administrativeArea = administrativeAreaValue
                    }
                    
                    address = "\(subLocality), \(locality) (\(administrativeArea))"
                    
                    completion(address,nil)
                }else{
                    print("\(error?.localizedDescription)")
                    completion(nil,error)
                }
            }
        })
    }
    
    static func getCoordinatesFromAddress(address: String, completion: @escaping (_ location: CLLocationCoordinate2D?) -> Void) {
        let geocoder = CLGeocoder()
        
        geocoder.geocodeAddressString(address) { (placemarks, error) in
            if error == nil {
                guard let placemarks = placemarks, let location = placemarks.first?.location?.coordinate else {
                    return
                }
                completion(location)
            }
        }
    }
}
