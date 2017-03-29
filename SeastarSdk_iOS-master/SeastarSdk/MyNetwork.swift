//
//  MyNetwork.swift
//  SeastarSdk_iOS
//
//  Created by seastar on 2016/12/14.
//
//

import UIKit

class MyNetwork: NSObject {
    
    static let current = MyNetwork()
    private var TIME_OUT: TimeInterval = 8.0
    
    func get(_ url: String, _ headers: [String : String], _ success: @escaping (Int, [String : Any]) -> Void, _ failure: @escaping() -> Void) {
        var request = URLRequest(url: URL(string: url)!, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: TIME_OUT)
        request.httpMethod = "GET"
        
        for (key, value) in headers {
            request.addValue(value, forHTTPHeaderField: key);
        }
        request.addValue("application/json;charset=UTF-8", forHTTPHeaderField: "content-type");
        
        Log("GET: \(url)  headers:\(headers)")
        
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue:OperationQueue.main)
        let task = session.dataTask(with: request) {
            (data, response, error) -> Void in
            
            if error != nil {
                // TODO
                Log(error!.localizedDescription)
                failure()
            } else {
                if let response = response as? HTTPURLResponse {
                    if let data = data {
                        let json = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers)
                        if let json = json as? [String : Any] {
                            Log("GET: \(url) resposneCode: \(response.statusCode) responseBody: \(json)")
                            success(response.statusCode, json)
                            return
                        }
                    }
                    
                    Log("GET: \(url) resposneCode: \(response.statusCode) responseBody: [:]")
                    success(response.statusCode, [:])
                } else {
                    failure()
                }
            }
        }
        task.resume()
    }
    
    
    func post(_ url: String , _ headers: [String : String], _ body: [String : Any], _ success: @escaping (Int, [String : Any]) -> Void, _ failure: @escaping() -> Void) {
        var request = URLRequest(url: URL(string: url)!, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: TIME_OUT)
        request.httpMethod = "POST"
        request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: .prettyPrinted)
        
        for (key, value) in headers {
            request.addValue(value, forHTTPHeaderField: key);
        }
        request.addValue("application/json;charset=UTF-8", forHTTPHeaderField: "content-type");
        
        Log("POST: \(url)  headers:\(headers) body:\(body)")
        
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue:OperationQueue.main)
        let task = session.dataTask(with: request) {
            (data, response, error) -> Void in
            
            if error != nil {
                // TODO
                Log(error!.localizedDescription)
                failure()
            } else {
                if let response = response as? HTTPURLResponse {
                    if let data = data {
                        let json = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers)
                        if let json = json as? [String : Any] {
                            Log("POST: \(url) resposneCode: \(response.statusCode) responseBody: \(json)")
                            success(response.statusCode, json)
                            return
                        }
                    }
                    
                    Log("POST: \(url) resposneCode: \(response.statusCode) responseBody: [:]")
                    success(response.statusCode, [:])
                } else {
                    failure()
                }
            }
        }
        task.resume()
    }
    
    func put(_ url: String , _ headers: [String : String], _ body: [String : Any], _ success: @escaping (Int, [String : Any]) -> Void, _ failure: @escaping() -> Void) {
        var request = URLRequest(url: URL(string: url)!, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: TIME_OUT)
        request.httpMethod = "PUT"
        request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: .prettyPrinted)
        
        for (key, value) in headers {
            request.addValue(value, forHTTPHeaderField: key);
        }
        request.addValue("application/json;charset=UTF-8", forHTTPHeaderField: "content-type");
        
        Log("PUT: \(url)  headers:\(headers) body:\(body)")
        
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue:OperationQueue.main)
        let task = session.dataTask(with: request) {
            (data, response, error) -> Void in
            
            if error != nil {
                // TODO
                Log(error!.localizedDescription)
                failure()
            } else {
                if let response = response as? HTTPURLResponse {
                    if let data = data {
                        let json = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers)
                        if let json = json as? [String : Any] {
                            Log("PUT: \(url) resposneCode: \(response.statusCode) responseBody: \(json)")
                            success(response.statusCode, json)
                            return
                        }
                    }
                    Log("PUT: \(url) resposneCode: \(response.statusCode) responseBody: [:]")
                    success(response.statusCode, [:])
                } else {
                    failure()
                }
            }
        }
        task.resume()
    }
    
    func get(url: String, success: @escaping (String) -> Void, failure: @escaping () -> Void) {
        var request: URLRequest = URLRequest(url: URL(string: url)!, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: TIME_OUT)
        request.httpMethod = "GET"
        
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue:OperationQueue.main);
        
        let task:URLSessionDataTask = session.dataTask(with: request) {
            (data: Data?, response: URLResponse?, error: Error?) -> Void in
            
            if let rawData = data {
                if let rawResult = String(data: rawData, encoding: String.Encoding.utf8) {
                    success(rawResult)
                } else {
                    Log("Http response is not String. please check url: \(url)")
                    failure()
                }
            } else {
                Log("Open url failed: \(error!), please check url: \(url)")
                failure()
            }
        }
        task.resume()
    }
}


