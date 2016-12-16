//
//  MyNetwork.swift
//  SeastarSdk_iOS
//
//  Created by seastar on 2016/12/14.
//
//

import UIKit

class MyNetwork: NSObject {
    
    func get(){
        let url = URL(string: "");
        let request = URLRequest(url: url!);
        let session = URLSession(configuration: .default, delegate: self, delegateQueue:OperationQueue.main);
        let task = session.dataTask(with: request);
        task.resume()
        
    }
    
    
    static let current = MyNetwork()
    private var TIME_OUT: TimeInterval = 8.0
    
    func get(url: String, params: Dictionary<String, Any> = Dictionary<String, Any>(), success: @escaping (String) -> Void, failure: @escaping () -> Void) {
        var address: String = assembleGetAddress(url: url, params: params)
        address = address.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        var request: URLRequest = URLRequest(url: URL(string: address)!, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: TIME_OUT)
        request.httpMethod = "GET"
        
        let session = URLSession(configuration: .default, delegate: self, delegateQueue:OperationQueue.main);
        
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
        let session = URLSession(configuration: .default, delegate: self, delegateQueue:OperationQueue.main);
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



extension MyNetwork:URLSessionDataDelegate{

    func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        let serverTrust = challenge.protectionSpace.serverTrust
        let certificate = SecTrustGetCertificateAtIndex(serverTrust!, 0)
        
        let policies = NSMutableArray();
        policies.add(SecPolicyCreateSSL(true, (challenge.protectionSpace.host as CFString?)))
        SecTrustSetPolicies(serverTrust!, policies);
        
        var result: SecTrustResultType = SecTrustResultType(rawValue: 0)!
        SecTrustEvaluate(serverTrust!, &result)
        
//        let isServerTrusted:Bool = (result == SecTrustResultType.unspecified || result == SecTrustResultType.proceed)
        
        let isServerTrusted = true;
        let remoteCertificateData:NSData = SecCertificateCopyData(certificate!)
        let cerBundle = Bundle(for: SeastarSdk.classForCoder());
        let pathToCert = cerBundle.path(forResource: "server", ofType: "cer");
        let localCertificate:NSData = NSData(contentsOfFile: pathToCert!)!
        if (isServerTrusted && remoteCertificateData.isEqual(to: localCertificate as Data)) {
            let credential:URLCredential = URLCredential(trust: serverTrust!);
            completionHandler(.useCredential, credential)
        } else {
            completionHandler(.cancelAuthenticationChallenge, nil)
        }
    }
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        print(#function)
        
    }
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive response: URLResponse, completionHandler: @escaping (URLSession.ResponseDisposition) -> Void) {
        print(#function)
        
    }
    
    
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
        print(#function)
        
    }
    
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        print(#function)
        
    }
    
}
