//
//  Utility.swift
//  SeastarSdk_iOS
//
//  Created by osx on 16/9/26.
//
//

import Foundation
import AdSupport
import CommonCrypto

func Log(_ message: String, fileName: String = #file, methodName: String =  #function, lineNumber: Int = #line)
{
    print("\(fileName) \(methodName) [\(lineNumber)]: \(message)")
}

func deviceId() -> String {
    return ASIdentifierManager.shared().advertisingIdentifier.uuidString
}

func deviceInfo() -> String {
    return "System: \(UIDevice.current.systemName):\(UIDevice.current.systemVersion), Model: \(UIDevice.current.model)"
}

func locale() -> String {
    return UserDefaults.standard.object(forKey: "AppleLanguages") as? String ?? ""
}

func md5(string data: String) -> String {
    let str = data.cString(using: String.Encoding.utf8)
    let strLen = CC_LONG(data.lengthOfBytes(using: String.Encoding.utf8))
    let digestLen = Int(CC_MD5_DIGEST_LENGTH)
    let result = UnsafeMutablePointer<CUnsignedChar>.allocate(capacity: digestLen)
    
    CC_MD5(str!, strLen, result)
    
    let hash = NSMutableString()
    for i in 0..<digestLen {
        hash.appendFormat("%02x", result[i])
    }
    
    result.deallocate(capacity: digestLen)
    
    return String(format: hash as String)
}
