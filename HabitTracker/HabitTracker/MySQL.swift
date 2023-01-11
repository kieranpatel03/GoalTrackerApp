//
//  MySQL.swift
//  HabitTracker
//
//  Created by Kieran on 02/07/2022.
//

import UIKit
import Foundation


enum alteringTableErrors: Error {
   case NotValidParameters
   case InvalidResponse
   case InvalidUrl
}


func alteringTable(route: String, parameters: [String: Any]) async throws -> Data {
    
    print("ok")
    
    guard let url = URL(string: "http://127.0.0.1:5000/\(route)") else {
        throw alteringTableErrors.InvalidUrl
    }

    var request = URLRequest(url: url,timeoutInterval: Double.infinity)
    
   
    request.addValue("application/json", forHTTPHeaderField: "Content-Type")


    request.addValue("application/json", forHTTPHeaderField: "Accept")
        
    request.httpMethod = "POST"
       
    do {
        request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
    } catch {
        throw alteringTableErrors.NotValidParameters
    }
    
    
    var data_from_db: Data?;
        
    (data_from_db, _) = try await URLSession.shared.data(for: request)
    
    guard let data_from_db = data_from_db else {
        throw alteringTableErrors.InvalidResponse
    }
        
    return data_from_db;
}


