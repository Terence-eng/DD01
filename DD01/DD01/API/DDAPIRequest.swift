//
//  DDRecomendRequest.swift
//  DD01
//
//  Created by Terrence on 2019/12/8.
//  Copyright © 2019 DD01. All rights reserved.
//

import UIKit

struct DDRecomendRequest: DDRequest {
    typealias Response = DDParseModel
    let path: String = "topgrossingapplications/limit=10/json"
    let method: DDHttpMethod = .GET
    let parameter: [String: Any] = [:]
    
}

struct DDRankRequest: DDRequest  {
    typealias Response = DDParseModel
    let path: String = "topfreeapplications/limit=100/json"
    let method: DDHttpMethod = .GET
    let parameter: [String : Any] = [:]
}
