//
//  Content.swift
//  DenTV
//
//  Created by Dmitriy Roytman on 12.10.15.
//  Copyright © 2015 Dmitriy Roytman. All rights reserved.
//

import Foundation

enum State {
    case NotInitialized
    case Error(errorMessage: String)
    case Searching
    case NotFound
    case Result(result: [AnyObject])
    
    var entityValue: String {
        switch self {
        case .NotInitialized: return "Not Initialized"
        case .Error(let errorMessage): return errorMessage
        case .Searching: return "Searching"
        case NotFound: return "Not Found"
        case Result(let list): return "Result: recieved \(list.count) object(s)."
        }
    }
}

protocol ContentDelegate {
    func contentDownloaderDidReceiveError(content: Content, status: State, error: NSError?)
    func contentDownloaderDidReceiveResponse(content: Content, response: NSHTTPURLResponse)
    func contentDownloaderWillStart(content: Content, status: State)
    func contentDownloaderDidFinishWithNotFound(content: Content, status: State)
    func contentDownloaderDidFinishWithResult(content: Content, status: State, result: NSData)
}

protocol Downloadable {
    func getURL() -> NSURL?
    var dataTask: NSURLSessionDataTask? {get set}
}

class Content {
    var delegate: ContentDelegate?
    var object: Downloadable
    private var status: State
    init(object: Downloadable) {
        self.object = object
        status = State.NotInitialized
    }
    
    convenience init(object: Downloadable, delegate: ContentDelegate) {
        self.init(object: object)
        self.delegate = delegate
        
        download()
    }
    
    func download() {
        status = .Searching
        dispatch_async(dispatch_get_main_queue()) {
            delegate?.contentDownloaderWillStart(self, status: status)
        }
        if let url = object.getURL() {
            let session = NSURLSession.sharedSession()
            object.dataTask = session.dataTaskWithURL(url, completionHandler: {
                (data: NSData?, response: NSURLResponse?, error: NSError?) -> Void in
                if let error = error {
                    self.status = .Error(errorMessage: response?.description ?? "")
                    dispatch_async(dispatch_get_main_queue()) {
                        self.delegate?.contentDownloaderDidReceiveError(self, status: self.status, error: error)
                    }
                }
                
                if let response = response as? NSHTTPURLResponse {
                    dispatch_async(dispatch_get_main_queue()) {
                        self.delegate?.contentDownloaderDidReceiveResponse(self, response: response)
                    }
                    if response.statusCode != 200 {
                        let message = "response code is \(response.statusCode)"
                        self.status = .Error(errorMessage: message)
                        dispatch_async(dispatch_get_main_queue()) {
                            self.delegate?.contentDownloaderDidReceiveError(self, status: self.status, error: nil)
                        }
                    }
                }
                
                if let data = data {
                    self.status = .Result(result: [data])
                    dispatch_async(dispatch_get_main_queue()) {
                        self.delegate?.contentDownloaderDidFinishWithResult(
                            self, status: self.status, result: data)
                    }
                } else {
                    self.status = .NotFound
                    dispatch_async(dispatch_get_main_queue()) {
                        self.delegate?.contentDownloaderDidFinishWithNotFound(self, status: self.status)
                    }
                }
            })
            object.dataTask?.resume()
        } else {
            let message = "class: Content; function \(__FUNCTION__); object.getURL() return nil"
            status = State.Error(errorMessage: message)
            dispatch_async(dispatch_get_main_queue()) {
                delegate?.contentDownloaderDidReceiveError(self, status: status, error: nil)
            }
        }
    }
}