//
//  ApiRequest.swift
//  bro
//
//  Created by m2sar on 24/05/2018.
//  Copyright © 2018 com.bro. All rights reserved.
//

import Foundation
import MapKit

class ApiRequest {
    
    let urlAPI = "https://c98a5819.ngrok.io"
    
    func getBrosOf(tokenOfUser : String, completion : @escaping (([Bro]?) -> (Void))){
        let url = URL(string: "\(urlAPI)/brotherhood/\(tokenOfUser)/bros")
        if let url = url {
            var request = URLRequest(url : url)
            request.httpMethod = "GET"
            request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            URLSession.shared.dataTask(with: request) { data, response, error in
                guard let data = data, error == nil else {
                    print(error?.localizedDescription ?? "No data")
                    DispatchQueue.main.async {
                        completion(nil)
                    }
                    return
                }
                do {
                    let jsonResponse = try JSONSerialization.jsonObject(with: data, options : [])
                    var broList = [Bro].init()
                    if let bros = jsonResponse as? [[String: Any]] {
                        for bro in bros {
                            print(" ---- Bro : \(bro)")
//                            let position = bro["position"]
//                            let lat = position["lat"]
//                            let lng = position["lng"]
                            if let username = bro["username"], let isLocation = bro["isLocation"] {
                                broList += [Bro.init(username: username as! String, isGeolocalised:  isLocation as! Bool, position: Position.init(title: username as! String, coordinate: CLLocationCoordinate2D.init()))]
                            }
                        }
                        completion(broList)
                    }
                } catch {
                    print(error)
                    DispatchQueue.main.async {
                        completion(nil)
                    }
                }
                }.resume()
        }
    }
    
    func registration(firstName: String, lastName: String, username: String, email: String, password: String, completion: @escaping ((Bool)->(Void))) {
        let json: [String: Any] = [
            "firstName": firstName,
            "lastName": lastName,
            "email": email,
            "password": password,
            "username": username
        ]
        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        
        let url = URL(string: "\(urlAPI)/user/create")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData
        print("test: before sending")
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print(error?.localizedDescription ?? "No data")
                DispatchQueue.main.async {
                    completion(false)
                }
                return
            }
            DispatchQueue.main.async {
                completion(true)
            }
        }
        task.resume()
    }
    
    func connection(email: String, password: String, completion: @escaping ((String?)->(Void))) {
        let json: [String: Any] = [
            "email": email,
            "password": password,
            ]
        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        let url = URL(string: "\(urlAPI)/user/auth")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData
        
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print(error?.localizedDescription ?? "No data")
                DispatchQueue.main.async {
                    completion(nil)
                }
                return
            }
            do {
                let jsonResponse = try JSONSerialization.jsonObject(with: data, options: [])
                if let dictionnary = jsonResponse as? [String: Any] {
                    if let token = dictionnary["token"] as? String {
                        DispatchQueue.main.async {
                            completion(token)
                        }
                    }
                }
            } catch {
                print(error)
                DispatchQueue.main.async {
                    completion(nil)
                }
            }
            }.resume()
    }
    
    func logout(token: String, completion: @escaping ((Bool)->(Void))){
        let url = URL(string: "\(urlAPI)/user/\(token)/logout")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print(error?.localizedDescription ?? "No data")
                DispatchQueue.main.async {
                    completion(false)
                }
                return
            }
            DispatchQueue.main.async {
                completion(true)
            }
        }
        task.resume()
    }
    
}
