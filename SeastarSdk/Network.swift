//
//  Network.swift
//  sdk
//
//  Created by osx on 16/9/23.
//  Copyright © 2016年 osx. All rights reserved.
//

import Foundation
import XCGLogger

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
    static let log = XCGLogger.default
    
    private static var TIME_OUT: TimeInterval = 8.0
    
    private static var defaultSession: URLSession {
        return URLSession(configuration: URLSessionConfiguration.default)
    }
    
    public static func get(url: String, params: Dictionary<String, Any> = Dictionary<String, Any>(), success: @escaping (String) -> Void, failure: @escaping () -> Void) {
        let address: String = assembleGetAddress(url: url, params: params)
        
        if let newAddress = address.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) {
            if let newURL = URL(string: newAddress) {
                var request: URLRequest = URLRequest(url: newURL, cachePolicy: URLRequest.CachePolicy.reloadIgnoringLocalCacheData, timeoutInterval: TIME_OUT)
                request.httpMethod = "GET"
                
                let task:URLSessionDataTask = defaultSession.dataTask(with: request, completionHandler: {
                    (data: Data?, response: URLResponse?, error: Error?) -> Void in
                    
                    if let rawData = data {
                        if let rawResult = String(data: rawData, encoding: String.Encoding.utf8) {
                            success(rawResult)
                        } else {
                            log.debug("Http response is not String. please check url: \(url)")
                            failure()
                        }
                    } else {
                        log.debug("Open url failed: \(error!), please check url: \(url)")
                        failure()
                    }
                })
                task.resume()
            } else {
                log.debug("Create URL failed, please check url: \(url)")
                failure()
            }
        } else {
            log.debug("UrlEncode failed, please check url: \(url)")
            failure()
        }
    }
    
    static func post(url: String, body: String, success: @escaping (String) -> Void, failure: @escaping () -> Void) {
        if let newURL = URL(string: url) {
            var request: URLRequest = URLRequest(url: newURL, cachePolicy: URLRequest.CachePolicy.reloadIgnoringLocalCacheData, timeoutInterval: TIME_OUT)
            request.httpMethod = "POST"
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = body.data(using: String.Encoding.utf8)
            
            let task: URLSessionDataTask = defaultSession.dataTask(with: request, completionHandler: {
                (data: Data?, response: URLResponse?, error: Error?) -> Void in
                
                if let rawData = data {
                    if let result = String(data: rawData, encoding: String.Encoding.utf8) {
                        success(result)
                    } else {
                        log.debug("Http response is not String. please check url: \(url)")
                        failure()
                    }
                } else {
                    log.debug("Open url failed: \(error!), please check url: \(url)")
                    failure()
                }
            })
            
            task.resume()
        } else {
            log.debug("Create URL failed, please check url: \(url)")
            failure()
        }
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
