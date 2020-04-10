//
//  rest.swift
//  OscielDemo
//
//  Created by Desarrollo on 4/9/20.
//  Copyright © 2020 Desarrollo. All rights reserved.
//

import Foundation
import Alamofire

struct RequestToken {
    
    // MARK: - Singleton
    static let shared = RequestToken()
    // MARK: - URL
    private var tokenUrl = "oauth2/token"
    // MARK: - Services
    mutating func requestToken (username: String, password: String, completion: @escaping (Token?, Bool, Error?, String) -> ()) {
        
        let parameters: Parameters = [
            "grant_type": "password" ,
            "client_id": "testclient",
            "client_secret": "testpass",
            "username": username,
            "password": password
        ]
        
        let url = "\(Constants.WS_URL)/\(tokenUrl)"
        
        let request = Alamofire.request(url, method: .post, parameters: parameters)
        
        request.responseJSON(completionHandler: { response in
            switch response.result {
            case .success:
                if response.response?.statusCode == 200 {
                    let data: Dictionary<String,Any> = response.result.value as! Dictionary<String,Any>
                    let obj: Token = Token(from: data)
                    completion(obj, true, nil, "")
                    return
                } else if response.response?.statusCode == 422 {
                    let data: Dictionary<String,Any> = response.result.value as! Dictionary<String,Any>
                    let obj: ErrorResponse = ErrorResponse(from: data)
                    completion(nil, false, nil, obj.msg!)
                    return
                } else if response.response?.statusCode == 401 {
                    completion(nil, false, nil, "401")
                    return
                } else if response.response?.statusCode == 400  {
                    completion(nil, false, nil, "400: Solicitud incorrecta")
                    return
                } else if response.response?.statusCode == 500 {
                    completion(nil, false, nil, "500: Error interno del servidor")
                    return
                } else {
                    completion(nil, false, nil, "\(String(describing: response.response?.statusCode)):Ha ocurrido un error desconocido")
                    return
                }
            case .failure(let error):
                if let err = error as? URLError, err.code == .notConnectedToInternet {
                    completion(nil, false, nil, "Ha ocurrido un error al conectarnos con el servidor. Por favor verifica tu conexión a Internet")
                } else if error._code == NSURLErrorTimedOut {
                    completion(nil, false, nil, "Ha ocurrido un error al conectarnos con el servidor. Por favor verifica tu conexión a Internet")
                } else if response.response?.statusCode == 401 {
                    completion(nil, false, nil, "Unautorized: Credenciales Incorrectas")
                    return
                } else {
                    completion(nil, false, error,"")
                }
                return
            }
        })
    }
    
}

//MARK: - Response to Object

struct Token {
    
    let access_token : String?
    let expires_in : Int?
    let token_type : String?
    let scope : String?
    let refresh_token : String?
    
    enum CodingKeys: String, CodingKey {
        case access_token = "access_token"
        case expires_in = "expires_in"
        case token_type = "token_type"
        case scope = "scope"
        case refresh_token = "refresh_token"
    }
    
    init(from dictionary: Dictionary<String,Any>) {
        access_token = dictionary["access_token"] as? String
        expires_in = dictionary["expires_in"] as? Int
        token_type = dictionary["token_type"] as? String
        scope = dictionary["scope"] as? String
        refresh_token = dictionary["refresh_token"] as? String
    }
    
}

struct ErrorResponse {

    let error : Bool?
    let msg : String?
    
    init(from dictionary: Dictionary<String,Any>) {
        error = dictionary["error"] as? Bool
        msg = dictionary["message"] as? String
    }
    
}
