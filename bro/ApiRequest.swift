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
    
  //  let urlAPI = "https://f4539846.ngrok.io"  // Florent
   let urlAPI = "https://79967509.ngrok.io"    // Nassim
    
    func getBrosOf(tokenOfUser : String, completion : @escaping (([Bro]?) -> (Void))){
        let url = URL(string: "\(urlAPI)/geolocation/get_bro_locations")
        if let url = url {
            var request = URLRequest(url : url)
            request.httpMethod = "GET"
//            request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
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
//                        print(bros)
                        for map in bros {
//                            print(" ---- Bro : \(map)")
                            let bro = map["map"] as! [String : Any]
                            let map = bro["position"] as! [String : Any]
                            let position = map["map"] as! [String : Any]
//                            print(position)
                            if let lat = position["lat"] as! Double?, let lng = position["lng"] as! Double? {
//                                print("lng : \(lng)")
//                                print("lat : \(lat)")
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
        
        let url = URL(string: "\(urlAPI)/user/create")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData
        print("test: before sending")
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
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
    
    func getUser(token : String, completion: @escaping ((User?)->(Void))){
        let url = URL(string: "\(urlAPI)/user/isconnected/")!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.addValue(token, forHTTPHeaderField: "token")
        
        var userResponse : User? = nil
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
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
        }
        task.resume()
        
    }
    
    func logout(token: String, completion: @escaping ((Bool)->(Void))){
        let url = URL(string: "\(urlAPI)/user/logout")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue(token, forHTTPHeaderField: "token")
        
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
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
        }
        task.resume()
    }
    
    func updateSettings(token: String, localizable: Bool, firstName: String, lastName: String, username: String, email: String, password: String, completion: @escaping ((Bool)->(Void))) {
        let json: [String: Any] = [
            "firstName": firstName,
            "lastName": lastName,
            "email": email,
            "password": password,
            "username": username,
            "localizable": localizable
        ]
        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        
        let url = URL(string: "\(urlAPI)/user/settings")!
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.addValue(token, forHTTPHeaderField: "token")
        request.httpBody = jsonData
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
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
        }
        task.resume()
    }
    
    func deny(sender: String, receiver: String, completion: @escaping ((Bool)->(Void))) {
        let json: [String: Any] = [
            "username": sender,
            "username": receiver
        ]
        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        
        let url = URL(string: "\(urlAPI)/brotherhood/deny")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
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
        }
        task.resume()

    }
}
