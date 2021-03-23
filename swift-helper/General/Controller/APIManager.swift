//
//  APIManager.swift
//  kyc
//
//  Created by Trieu Dinh Quy on 8/29/19.
//  Copyright © 2019 Trieu Dinh Quy. All rights reserved.
//

import UIKit
import Foundation

enum RequestType {
    case post
    case get
    
    func getName() -> String {
        switch self {
        case .post:
            return "POST"
        case .get:
            return "GET"
        }
    }
}

class APIManager {
    
	static func postJsonRequest(sUrl: String, params: [String: Any], sAuthorization: String? = nil, completion: ((_ data: [String : Any]?, _ error: Error?) -> Void)? = nil) {
		APIManager.sendRequest(sUrl: sUrl, params: params, requestType: .post, sContentType: "json", sAuthorization: sAuthorization, completion: completion)
	}
    
	static func sendRequest(sUrl: String, params: [String: Any]? = nil, requestType: RequestType = .post, sContentType: String? = "json", sAuthorization: String? = nil, completion: ((_ data: [String : Any]?, _ error: Error?) -> Void)? = nil) {
        print("Send request to \(sUrl)...")
        var sParams = ""
        if let params = params {
            if let sContentType = sContentType {
                if sContentType == "json" {
                    sParams = getJSONParamsFromDictParams(dictParams: params)
                }
            } else {
                sParams = getParamsFromDictParams(dictParams: params)
            }
        }
		
		var sFullUrl = sUrl
		let urlSessionConfig = URLSessionConfiguration.default
		let session = URLSession(configuration: urlSessionConfig)
		let url = URL(string: sFullUrl)
		var request = URLRequest(url: url!, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 60.0)
        
        if requestType == .get {
            sFullUrl = "\(sUrl)?\(sParams)"
			request.httpMethod = "GET"
        }
        else {
            if let sContentType = sContentType {
                if sContentType == "json" {
                    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                }
                if let sAuthorization = sAuthorization {
                    request.setValue(sAuthorization, forHTTPHeaderField: "Authorization")
                }
            }
            request.httpMethod = "POST"
            let postData: Data = sParams.data(using: .utf8)!
            request.httpBody = postData
            
            Log.d("POST Length: \(postData.count)")
        }
		
        // them header ngon ngu
		let sLanguage = Global.appLanguage
		request.setValue(sLanguage, forHTTPHeaderField: "client-language")
        
        let requestDataTask = session.dataTask(with: request) { (data, response, error) in
            if let error = error {
                Log.d("\(error)")
				if let c = completion {
					c(nil, error)
				}
                return
            }
            
            do {
                let jsonResult = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableLeaves) as! [String: Any]
                
				if let c = completion {
					c(jsonResult, nil)
				}
                
            } catch let err {
                Log.d("\n- \(err)\n, Error Code: \(err._code), Error Messsage: \(err.localizedDescription)")
                Log.d("\n\n===========Error===========")
                if let data = data, let str = String(data: data, encoding: String.Encoding.utf8){
                    Log.d("Print Server data:- " + str)
                }
                Log.d("===========================\n\n")
				if let c = completion {
					c(nil, error)
				}
            }
        }
        requestDataTask.resume()
    }
    
    // Mark: - Private functions
    private static func getParamsFromDictParams(dictParams: [String: Any]) -> String {
        let keys = dictParams.keys
        let sParams: NSMutableString = NSMutableString(string: "")
        for key in keys {
            let value = dictParams[key] ?? ""
            sParams.append("\(key)=\(value)")
            sParams.append("&")
        }
		
        let sRet = sParams.substring(to: sParams.length - 1)
        return sRet
    }
    
    private static func getJSONParamsFromDictParams(dictParams: [String: Any]) -> String {
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: dictParams, options: [])
            let jsonText = String(data: jsonData, encoding: .utf8) ?? ""
            return jsonText
        } catch {
            return ""
        }
    }
    
}
