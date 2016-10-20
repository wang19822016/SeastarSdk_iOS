//
//  Network.swift
//  sdk
//
//  Created by osx on 16/9/23.
//  Copyright © 2016年 osx. All rights reserved.
//

import Foundation

/**
 URLSession不进行请求，通过创建Task进行网络请求。同一个URLSession创建的Task可以共享cache和cookie。
 URLSessionDataTask: 读取服务器的简单数据。
 URLSessionDownloadTask: 下载文件。
 URLSessionUploadTask: 上传文件。
 
 NSURLSessionConfiguration:
 defaultSessionConfiguration: 使用全局的缓冲等配置，默认配置。
 ephemeralSessionConfiguration: 不会对缓冲等信息存储，相当于浏览器的隐私模式。
 backgroundSessionConfiguration: 可以让网络操作在应用切换到后台时还能执行。
 
 详细的事件可以通过设置代理来获得。
 
 */

class Network {
    private static var TIME_OUT: TimeInterval = 8.0
    
    static func get(url: String, params: Dictionary<String, Any> = Dictionary<String, Any>(), success: @escaping (String) -> Void, failure: @escaping () -> Void) {
        var address: String = assembleGetAddress(url: url, params: params)
        address = address.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        var request: URLRequest = URLRequest(url: URL(string: address)!, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: TIME_OUT)
        request.httpMethod = "GET"
        
        
        let task:URLSessionDataTask = URLSession.shared.dataTask(with: request) {
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
    
    static func post(url: String, json:[String : Any], success: @escaping ([String: Any])->Void, failure:@escaping ()->Void) {
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
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if error != nil {
                // 错误情况处理
                failure()
            } else {
                if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                    // 接收数据正常
                    do {
                        let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers)
                        success(json as? [String: Any] ?? [:])
                        return
                    } catch {
                        // 收到的数据不是json
                    }
                }
                
                failure()
            }
        }
        task.resume()
    }
    
    private static func assembleGetAddress(url: String, params:Dictionary<String, Any>) -> String {
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
