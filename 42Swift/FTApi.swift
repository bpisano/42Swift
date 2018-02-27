//
//  FTApi.swift
//  42Swift
//
//  Created by Benjamin Pisano on 27/02/2018.
//  Copyright © 2018 bpisano. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class FTApi: NSObject {
    
    static var token = String()
    static var currentUserID: String? {
        guard let id = UserDefaults.standard.value(forKey: "currentUserID") as? String else {
            return nil
        }
        
        return id
    }
    
    func getToken(_ completion: ((_ error: Error?, _ token: String?) -> Void)?) {
        let url = "https://api.intra.42.fr/oauth/token"
        let parameters = ["grant_type" : "client_credentials",
                          "client_id": "d3c61e034d98ab0ea03f18bdc0ec6043533cbc178589ccb3799a7f58378a1ba1",
                          "client_secret": "002e7e32f2a664a10877b05d6e483e1aee735d3bc3806652e2cc4178e9e057dc"]
        
        Alamofire.request(url, method: .post, parameters: parameters).validate().responseJSON { (response) in
            switch response.result {
            case .failure(let error):
                print(error.localizedDescription)
                completion?(error, nil)
            case .success(let value):
                let token = JSON(value)["access_token"].stringValue
                
                print("Token : \(token)")
                FTApi.token = token
                completion?(nil, token)
            }
        }
    }
    
    func getAllUsers(page: Int, _ completion: ((_ error: Error?, _ users: [FTUser]?) -> Void)?) {
        let url = URL(string: "https://api.intra.42.fr/v2/campus/9/users?page=\(page)&per_page=100")
        let head = "Bearer " + FTApi.token
        var request = URLRequest(url: url!)
        
        request.httpMethod = "GET"
        request.setValue(head, forHTTPHeaderField: "Authorization")

        Alamofire.request(request).validate().responseJSON { (response) in
            guard JSON(response.result.value ?? "").count > 0 else {
                completion?(nil, nil)
                return
            }
            
            Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false, block: { (_) in
                self.getAllUsers(page: page + 1, { (error, users) in
                    switch response.result {
                    case .failure(let error):
                        print(error.localizedDescription)
                        completion?(error, nil)
                        return
                    case .success(let value):
                        var finalUsers = users ?? [FTUser]()
                        for userJSON in JSON(value) {
                            let user = FTUser(id: userJSON.1["id"].stringValue, username: userJSON.1["login"].stringValue, JSONData: userJSON.1)
                            finalUsers.append(user)
                        }
                        completion?(nil, finalUsers)
                    }
                })
            })
        }
    }
    
    func setCurrentUserID(_ id: String) {
        UserDefaults.standard.set(id, forKey: "currentUserID")
    }
}
