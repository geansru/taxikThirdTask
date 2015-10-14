//
//  City.swift
//  Third
//
//  Created by Dmitriy Roytman on 14.10.15.
//  Copyright © 2015 Dmitriy Roytman. All rights reserved.
//

import Foundation
import CoreLocation
import MapKit

class City: NSObject, MKAnnotation  {
    var city_id: Int = 0
    var city_name = "" //": "Нахабино (московская область)",
    var parent_city: Int = 0 //": 1,
    var city_api_url: String = "" //": "http://beta.taxistock.ru/taxik/api/client/",
    var city_domain = "" //": "beta.taxistock.ru",
    var city_mobile_server = "" //": "protobuf.taxistock.ru:7777",
    var city_doc_url = "" //": "http://beta.taxistock.ru/taxik/api/doc/",
    var city_latitude: Double = 0 //": 55.846204,
    var city_longitude: Double = 0 //": 37.168567,
    var city_spn_latitude: Double = 0 //": 0.037595,
    var city_spn_longitude: Double = 0 //": 0.043736,
    var last_app_android_version: Int = 0 //": 7045,
    var android_driver_apk_link = "" //": "http://www.taxik.ru/a/taxik.apk"
    
    // MARK: - MKAnnotation
    var coordinate: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: self.city_latitude, longitude: self.city_longitude)
    }
    
    var title:String? { return self.city_name }
}