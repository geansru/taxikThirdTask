//
//  Parser.swift
//  DenTV
//
//  Created by Dmitriy Roytman on 12.10.15.
//  Copyright © 2015 Dmitriy Roytman. All rights reserved.
//

import Foundation
import SwiftyJSON

protocol ParserDelegate {
    func parserDidReceiveError(parser: Parser, error: String)
    func parserWillStartParse(parser: Parser)
    func parserDidFinishParse(parser: Parser, result: [AnyObject])
}

protocol Parseable {
    var data: NSData? { get set }
}

class Parser {
    private let queueName = "ru.geans.ios.Parser.bgqueue"
    let backgroundQueue: dispatch_queue_t!
    var delegate: ParserDelegate?
    var object: Parseable
 
    init(object: Parseable) {
        self.object = object
        backgroundQueue = dispatch_queue_create(queueName, nil)
    }
    
    convenience init(object: Parseable, delegate: ParserDelegate) {
        self.init(object: object)
        self.delegate = delegate
        parse()
    }
    
    // MARK: Main parse function
    func parse() {
        dispatch_async(backgroundQueue) {
            self.parseAsync()
        }
    }
    
    // MARK: Parse func body
    private func parseAsync() {
        dispatch_async(dispatch_get_main_queue()) {
            delegate?.parserWillStartParse(self)
        }
        let result = parseCities()
        
        dispatch_async(dispatch_get_main_queue()) {
            delegate?.parserDidFinishParse(self, result: result)
        }
    }
    
    // MARK: Helpers
    private func makeCity(items: JSON, i: Int)-> City {
        let city: City = City()
        let data = items[i]
        city.city_name = data["city_name"].string!

        city.city_latitude = data["city_latitude"].double!
        city.city_longitude = data["city_longitude"].double!
        city.android_driver_apk_link = data["android_driver_apk_link"].string!
        city.city_api_url = data["city_api_url"].string!
        city.city_doc_url = data["city_doc_url"].string!
        city.city_domain = data["city_domain"].string!
        city.city_id = data["city_id"].int!
        city.city_mobile_server = data["city_mobile_server"].string!
        city.parent_city = Int(data["parent_city"].doubleValue)
        city.city_spn_latitude = data["city_spn_latitude"].double!
        city.city_spn_longitude = data["city_spn_longitude"].double!
        return city
    }
    
    private func parseCities() -> [AnyObject] {
        var list: [City] = []
        let data = JSON(data: object.data!)
        let items = data["cities"]
        for i in 0..<items.count {
            list.append( makeCity(items, i: i) )
        }
        return list
    }
}