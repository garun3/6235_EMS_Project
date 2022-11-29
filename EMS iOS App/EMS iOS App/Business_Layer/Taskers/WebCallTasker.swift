//
//  WebCallTasker.swift
//  EMS iOS App
//

import UIKit

class WebCallTasker: NSObject {
    
    override init() {
        super.init()
    }
    
    //Post Requests
    func makePostRequest(forURL: String, withJson: [String: Any], failure: @escaping () -> Void, success: @escaping (_ data: Data) -> Void) {
        guard let json = try? JSONSerialization.data(withJSONObject: withJson) else {
            failure()
            return
        }
        self.makeUrlRequest(urlString: forURL, httpMethod: "POST", httpBody: json, failure: failure, success: success)
    }
    
    //Get Requests
    func makeGetRequest(forBaseURL: String, withParams: String, failure: @escaping () -> Void, success: @escaping (_ data: Data) -> Void) {
        let urlString = forBaseURL + withParams
        self.makeUrlRequest(urlString: urlString, httpMethod: "GET", httpBody: nil, failure: failure, success: success)
    }
    
    //Overall URL Request
    private func makeUrlRequest(urlString: String, httpMethod: String, httpBody: Data?, failure: @escaping () -> Void, success: @escaping (_ data: Data) -> Void) {
        guard let url = URL(string: urlString) else {
            failure()
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = httpMethod
        if let body = httpBody {
            request.httpBody = body
        }
        if httpMethod == "POST" {
            request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        }
        let task = URLSession.shared.dataTask(with: request) {data, _, error in
            guard let data = data, error == nil else {
                failure()
                return
            }
            success(data)
        }
        task.resume()
    }

}
