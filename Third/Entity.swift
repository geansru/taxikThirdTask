//
//  Entity.swift
//  DenTV
//
//  Created by Dmitriy Roytman on 13.10.15.
//  Copyright © 2015 Dmitriy Roytman. All rights reserved.
//

import Foundation

class Entity {
    // MARK: - Properties
    var dataTask: NSURLSessionDataTask? // Downloadable
    var data: NSData?
    var closure: ([AnyObject])->()
    
    init(closure: ([AnyObject])->()) {
        self.closure = closure
    }
    
}

extension Entity {
    // MARK: Helper
    func refresh() {
        let _ = Content(object: self, delegate: self)
    }
 }

extension Entity: ParserDelegate {
    // MARK: ParserDelegate
    func parserDidReceiveError(parser: Parser, error: String) {
        print(error)
    }
    func parserWillStartParse(parser: Parser) {
        print(__FUNCTION__)
    }
    func parserDidFinishParse(parser: Parser, result: [AnyObject]) {
        closure(result)
    }
}

extension Entity:  Parseable {}

extension Entity: Downloadable {
    func getURL() -> NSURL? {
        return NSURL(string: "http://beta.taxistock.ru/taxik/api/client/query_cities")
    }
}

extension Entity: ContentDelegate {
    // MARK: - ContentDelegate
    func contentDownloaderDidReceiveError(content: Content, status: State, error: NSError?) {
        print(status.entityValue)
        if let _ = error { print(error!) }
        
    }
    func contentDownloaderDidReceiveResponse(content: Content, response: NSHTTPURLResponse) {
        let mess: String = "Received status code: \(response.statusCode)"
        print(mess)
    }
    func contentDownloaderWillStart(content: Content, status: State) {
        print(status.entityValue)
    }
    func contentDownloaderDidFinishWithNotFound(content: Content, status: State) {
        print(status.entityValue)
    }
    func contentDownloaderDidFinishWithResult(content: Content, status: State, result: NSData) {
        self.data = result
        let _ = Parser(object: self, delegate: self)
        print(status.entityValue)
    }
}