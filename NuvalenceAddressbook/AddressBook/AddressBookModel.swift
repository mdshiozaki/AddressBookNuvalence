//
//  HomeModel.swift
//  NuvalenceAddressbook
//
//  Created by Mshiozaki on 2021-06-02.
//

import Foundation

class AddressBookModel {
    var session : URLSession
    init(urlSession: URLSession = .shared) {
        self.session = urlSession
    }
    
    func getPeople(completion: @escaping ([Person]?, Error?) -> Void) {
        guard let url = URL(string: "https://randomuser.me/api/?results=30") else {
            print("Failed to obtain URL from string")
            return
        }
        
        var req = URLRequest(url: url)
        req.httpMethod = "GET"
        DispatchQueue.main.async {
            let task = self.session.dataTask(with: req, completionHandler: { data, response, error in
                if error != nil {
                    print("Error getting people due to \(error)")
                    completion(nil, error)
                    return
                }
                
                guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                    print("Error from HTTP server, status code \(response)")
                    return
                }
                
                if let data = data {
                    do {
                        if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                            if let results = json["results"] as? [[String:Any]] {
                                let personsList = results.map { (result) -> Person in
                                    let name = result["name"] as! [String: String]
                                    let firstName = name["first"]!
                                    let lastName = name["last"]!
                                    
                                    let email = result["email"] as! String
                                    let phone = result["phone"] as! String
                                    
                                    let picture = result["picture"] as! [String: String]
                                    let thumbnail = picture["thumbnail"]! as String
                                    
                                    return Person(name: firstName + " " + lastName, phone: phone, email: email, imageURL: thumbnail)
                                }
                                completion(personsList, nil)
                            }
                        }
                    } catch let error as NSError {
                        print("failed to load")
                        completion(nil, error)
                    }
                }
            })
            task.resume()
        }
    }
}
