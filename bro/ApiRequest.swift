//
//  ApiRequest.swift
//  bro
//
//  Created by m2sar on 24/05/2018.
//  Copyright © 2018 com.bro. All rights reserved.
//

import Foundation

class ApiRequest {

    func registration(firstName: String, lastName: String, username: String, email: String, password: String) -> Bool {
        var res = true
        let json: [String: Any] = [
            "firstName": firstName,
            "lastName": lastName,
            "email": email,
            "password": password
        ]
        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        
        let url = URL(string: "https://7d77a452.ngrok.io/user/create")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData
        print("test: before sending")
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print(error?.localizedDescription ?? "No data")
                res = false
                return
            }
            let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
            if let responseJSON = responseJSON as? [String: Any] {
                print(responseJSON)
            }
        }
        task.resume()
        return res
    }
    
    func connection(email: String, password: String) -> Bool{
        var res = true
        let json: [String: Any] = [
            "email": email,
            "password": password,
        ]
        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        
        let url = URL(string: "https://7d77a452.ngrok.io/user/auth")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print(error?.localizedDescription ?? "No data")
                res = false
                return
            }
            let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
            if let responseJSON = responseJSON as? [String: Any] {
                print(responseJSON)
                res = true
            }
        }
        task.resume()
        return res
    }
}
