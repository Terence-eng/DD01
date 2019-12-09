//
//  DDNetworkConfig.swift
//  DD01
//
//  Created by Terrence on 2019/12/8.
//  Copyright © 2019 DD01. All rights reserved.
//

import UIKit
import Alamofire

enum DDHttpMethod: String {
    case GET
    case POST
}

protocol DDDecodable {
    static func parse(data: Data) -> Self?
}

protocol DDRequest {
    associatedtype Response: DDDecodable
    
    var path: String { get }
    var method: DDHttpMethod { get }
    var parameter: [String: Any] { get }
}

protocol DDClient {
    var host: String { get }
    func send<T: DDRequest>(_ r:T, handle: @escaping (T.Response?) -> Void)
}



