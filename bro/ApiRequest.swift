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
    
    let urlAPI = "https://1baec6e5.ngrok.io"  // Florent
//  let urlAPI = "https://9ea03ea0.ngrok.io"    // Nassim
    
    func getBrosOf(tokenOfUser : String, completion : @escaping (([Bro]?) -> (Void))){
        let url = URL(string: "\(urlAPI)/geolocation/get_bro_locations")
        if let url = url {
            var request = URLRequest(url : url)
            request.httpMethod = "GET"
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.addValue(tokenOfUser, forHTTPHeaderField: "token")
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
                        for map in bros {
                            let bro = map["map"] as! [String : Any]
                            let map = bro["position"] as! [String : Any]
                            let position = map["map"] as! [String : Any]
                            if let lat = position["lat"] as! Double?, let lng = position["lng"] as! Double? {
                                if let username = bro["username"], let isLocation = bro["localizable"] {
                                    broList += [Bro.init(username: username as! String, isGeolocalised:  isLocation as! Bool, position: Position.init(title: username as! String, coordinate: CLLocationCoordinate2D.init(latitude: lat, longitude: lng)))]
                                }
                            }
                        }
                        DispatchQueue.main.async {
                            completion(broList)
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
        
        let url = URL(string: "\(urlAPI)/user/create")
        if let url = url {
            
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
            request.httpBody = jsonData
            print("test: before sending")
            URLSession.shared.dataTask(with: request) { data, response, error in
                guard let _ = data, error == nil else {
                    print(error?.localizedDescription ?? "No data")
                    DispatchQueue.main.async {
                        completion(false)
                    }
                    return
                }
                DispatchQueue.main.async {
                    completion(true)
                }
            }.resume()
        }
    }
    
    func connection(email: String, password: String, completion: @escaping ((String?)->(Void))) {
        let json: [String: Any] = [
            "email": email,
            "password": password,
            ]
        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        let url = URL(string: "\(urlAPI)/user/auth")
        if let url = url {
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
    }
    
    func getUser(token : String, completion: @escaping ((User?)->(Void))){
        let url = URL(string: "\(urlAPI)/user/isconnected/")
        if let url = url {
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            
            request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
            request.addValue(token, forHTTPHeaderField: "token")
            
            var userResponse : User? = nil
            
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
                        if let user = dictionnary["value"] as? [String : Any] {
                            if let firstName = user["firstName"] as! String?, let lastName = user["lastName"] as! String?, let username = user["username"] as! String?, let email = user["email"] as! String?, let isGeolocalised = user["localizable"] as! Bool? {
                                userResponse = User.init(firstName: firstName, lastName: lastName, username: username, emailAddress: email, isGeolocalised: isGeolocalised)
                                DispatchQueue.main.async {
                                    completion(userResponse)
                                }
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
        
    }
    
    func logout(token: String, completion: @escaping ((Bool)->(Void))){
        let url = URL(string: "\(urlAPI)/user/logout")
        if let url = url{
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.addValue(token, forHTTPHeaderField: "token")
            
            request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
            URLSession.shared.dataTask(with: request) { data, response, error in
                guard let _ = data, error == nil else {
                    print(error?.localizedDescription ?? "No data")
                    DispatchQueue.main.async {
                        completion(false)
                    }
                    return
                }
                DispatchQueue.main.async {
                    completion(true)
                }
            }.resume()
        }
    }
    
    func updateSettings(token: String, localizable: Bool, firstName: String, lastName: String, username: String, email: String, password: String?, completion: @escaping ((Bool)->(Void))) {
        var json: [String: Any] = [
            "firstName": firstName,
            "lastName": lastName,
            "email": email,
            "username": username,
            "localizable": localizable
        ]
        
        if let password = password {
            if !password.isEmpty{
                json.updateValue(password, forKey: "password")
            }
        }
        
        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        
        let url = URL(string: "\(urlAPI)/user/settings")
        if let url = url {
            var request = URLRequest(url: url)
            request.httpMethod = "PUT"
            request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
            request.addValue(token, forHTTPHeaderField: "token")
            request.httpBody = jsonData
            URLSession.shared.dataTask(with: request) { data, response, error in
                guard let _ = data, error == nil else {
                    print(error?.localizedDescription ?? "No data")
                    DispatchQueue.main.async {
                        completion(false)
                    }
                    return
                }
                DispatchQueue.main.async {
                    completion(true)
                }
            }.resume()
        }
    }
    
    func accept(token: String, receiver: String, completion: @escaping ((Bool)->(Void))) {
        let json: [String: Any] = [
            "username": receiver
        ]
        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        
        let url = URL(string: "\(urlAPI)/brotherhood/accept")
        if let url = url {
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
            request.addValue(token, forHTTPHeaderField: "token")
            request.httpBody = jsonData
            URLSession.shared.dataTask(with: request) { data, response, error in
                guard let _ = data, error == nil else {
                    print(error?.localizedDescription ?? "No data")
                    DispatchQueue.main.async {
                        completion(false)
                    }
                    return
                }
                DispatchQueue.main.async {
                    completion(true)
                }
            }.resume()
        }
    }
    
    func getPossibleBros(completion: @escaping ((Bool)->(Void))) {
        
    }
    
    func deny(token: String, receiver: String, completion: @escaping ((Bool)->(Void))) {
        let json: [String: Any] = [
            "username": receiver
        ]
        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        
        let url = URL(string: "\(urlAPI)/brotherhood/deny")
        if let url = url {
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
            request.addValue(token, forHTTPHeaderField: "token")
            request.httpBody = jsonData
            URLSession.shared.dataTask(with: request) { data, response, error in
                guard let _ = data, error == nil else {
                    print(error?.localizedDescription ?? "No data")
                    DispatchQueue.main.async {
                        completion(false)
                    }
                    return
                }
                DispatchQueue.main.async {
                    completion(true)
                }
            }.resume()
        }
    }
    
    func sendInvitation(token : String, receiver: String, completion: @escaping ((Bool)->(Void))) {
        let json: [String: Any] = [
            "username": receiver
        ]
        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        
        let url = URL(string: "\(urlAPI)/brotherhood/create")
        if let url = url {
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
            request.addValue(token, forHTTPHeaderField: "token")
            request.httpBody = jsonData
            URLSession.shared.dataTask(with: request) { data, response, error in
                guard let _ = data, error == nil else {
                    print(error?.localizedDescription ?? "No data")
                    DispatchQueue.main.async {
                        completion(false)
                    }
                    return
                }
                DispatchQueue.main.async {
                    completion(true)
                }
            }.resume()
        }
    }
    
    func getLastPostion(username : String, completion: @escaping ((Position?)->(Void))) {
        let url = URL(string: "\(urlAPI)/geolocation/history")
        if let url = url {
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            request.addValue(username, forHTTPHeaderField: "username")
            request.addValue("1", forHTTPHeaderField: "nbGeo")
            request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
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
                    var position : Position?
                    if let response = jsonResponse as? [[String: Any]] {
                        let response = response[0] as [String: Any]
                        if let lat = response["lat"] as? Double, let lng = response["lng"] as? Double {
                            position = Position(title: username, coordinate: CLLocationCoordinate2D(latitude: lat, longitude: lng))
                        }
                        DispatchQueue.main.async {
                            completion(position)
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
    }
    
    func sendPosition(token: String, lat: Double, lng: Double, completion: @escaping ((Bool) -> (Void))) {
        let json: [String: Any] = [
            "lat": lat,
            "lng" : lng,
            ]
        
        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        let url = URL(string: "\(urlAPI)/geolocation/create")
        if let url = url {
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.addValue(token, forHTTPHeaderField: "token")
            request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
            request.httpBody = jsonData
            URLSession.shared.dataTask(with: request) { data, response, error in
                guard error == nil else {
                    print(error?.localizedDescription ?? "No data")
                    DispatchQueue.main.async {
                        completion(false)
                    }
                    return
                }
                DispatchQueue.main.async {
                    completion(true)
                }
            }.resume()
        }
    }
    
    func getBrosDistance(token: String, completion: @escaping (([String : Double]?)->(Void))) {
        let url = URL(string: "\(urlAPI)/gelocation/get_bros_distance")
        if let url = url {
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            request.addValue(token, forHTTPHeaderField: "token")
            request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
            URLSession.shared.dataTask(with: request) { data, response, error in
                guard error == nil else {
                    return
                }
                DispatchQueue.main.async {
                    completion(nil)
                }
            }.resume()
        }
    }
    
    func getBros(token: String, completion: @escaping (([String]?)->(Void))){
        let url = URL(string: "\(urlAPI)/brotherhood/accepted_bros")
        if let url = url {
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            request.addValue(token, forHTTPHeaderField: "token")
            request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
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
                    var bros = [String]()
                    if let response = jsonResponse as? [String] {
                        bros = response
                        DispatchQueue.main.async {
                            completion(bros)
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
    }

    func getWaiting(token: String, completion: @escaping (([String]?)->(Void))){
        let url = URL(string: "\(urlAPI)/brotherhood/awaiting_bros")
        if let url = url {
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            request.addValue(token, forHTTPHeaderField: "token")
            request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
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
                    var bros = [String]()
                    if let response = jsonResponse as? [String] {
                        bros = response
                        DispatchQueue.main.async {
                            completion(bros)
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
    }
}

