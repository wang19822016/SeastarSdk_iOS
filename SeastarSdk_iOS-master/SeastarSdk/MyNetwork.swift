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
        
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue:OperationQueue.main)
        let task = session.dataTask(with: request) {
            (data, response, error) -> Void in
            
            if error != nil {
                // TODO
                failure()
            } else {
                if let data = data {
                    let json = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers)
                    if let json = json as? [String : Any] {
                        if let response = response as? HTTPURLResponse {
                            success(response.statusCode, json)
                        }
                    }
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
        
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue:OperationQueue.main)
        let task = session.dataTask(with: request) {
            (data, response, error) -> Void in
            
            if error != nil {
                // TODO
                failure()
            } else {
                if let data = data {
                    let json = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers)
                    if let json = json as? [String : Any] {
                        if let response = response as? HTTPURLResponse {
                            success(response.statusCode, json)
                        }
                    }
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
        
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue:OperationQueue.main)
        let task = session.dataTask(with: request) {
            (data, response, error) -> Void in
            
            if error != nil {
                // TODO
                failure()
            } else {
                if let data = data {
                    let json = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers)
                    if let json = json as? [String : Any] {
                        if let response = response as? HTTPURLResponse {
                            success(response.statusCode, json)
                        }
                    }
                }
            }
        }
        task.resume()
    }

    
    func get(url: String, params: Dictionary<String, Any> = Dictionary<String, Any>(), success: @escaping (String) -> Void, failure: @escaping () -> Void) {
        var address: String = assembleGetAddress(url: url, params: params)
        address = address.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        var request: URLRequest = URLRequest(url: URL(string: address)!, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: TIME_OUT)
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
    
    func post(url: String, json:[String : Any], success: @escaping ([String: Any])->Void, failure:@escaping ()->Void) {
        if !JSONSerialization.isValidJSONObject(json) {
            // 不是json格式
            failure()
            return
        }
        
        var request = URLRequest(url: URL(string: url)!, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: TIME_OUT)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.httpBody = try? JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
        
        Log("url: \(url) body: \(json)")
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue:OperationQueue.main);
        let task = session.dataTask(with: request) { data, response, error in
            if error != nil {
                // 错误情况处理
                Log("error: \(error)")
                DispatchQueue.main.async {
                    failure()
                }
            } else {
                if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                    // 接收数据正常
                    if let json = try? JSONSerialization.jsonObject(with: data!, options: .mutableContainers) {
                        Log("success: \(json)")
                        DispatchQueue.main.async {
                            success(json as? [String: Any] ?? [:])
                        }
                    } else {
                        Log("http ok, but response body format error")
                        DispatchQueue.main.async {
                            failure()
                        }
                    }
                } else {
                    Log("http fail")
                    DispatchQueue.main.async {
                        failure()
                    }
                }
            }
        }
        task.resume()
    }
    
    private func assembleGetAddress(url: String, params:Dictionary<String, Any>) -> String {
        var address: String = url
        var i: Int = 0
        for (key, value) in params {
            if i == 0 {
                address += "?\(key)=\(value)"
            } else {
                address += "&\(key)=\(value)"
            }
            i = i + 1
        }
        
        return address
    }
}


