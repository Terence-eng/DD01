//
//  DDModel.swift
//  DD01
//
//  Created by Terrence on 2019/12/8.
//  Copyright © 2019 DD01. All rights reserved.
//

import UIKit

struct DDModel {
    var rank: Int = 0
    var name: String?
    var iconUrl: String?
    var appType: String?
    var commentNum: Int = 0
    var rate: CGFloat = 0.0
}

struct DDParseModel: DDDecodable  {
    
    static func parse(data: Data) -> DDParseModel? {
        return DDParseModel(data: data)
    }
    
    let modelArray: [DDModel]
    
    
    
    init?(data: Data) {
        guard let obj = try? JSONSerialization.jsonObject(with: data, options: []) as? [String : Any] else {
            return nil
        }
        
        guard let feed = obj["feed"] as? [String: Any] else {
            return nil
        }
        
        guard let entry = feed["entry"] as? [[String: Any]] else {
            return nil
        }
        
        var modelArray = [DDModel]()
        for (index, dict) in entry.enumerated() {
            var model = DDModel()
            model.rank = index + 1
            model.commentNum = Int(arc4random_uniform(101))
            model.rate = CGFloat(CGFloat(model.commentNum) / CGFloat(100.0))
            if let im_name = dict["im:name"] as? [String: Any], let name = im_name["label"] as? String {
                model.name = name
            }
            if let im_image = dict["im:image"] as? [[String: Any]], let firstImgObj = im_image.first,let iconUlr = firstImgObj["label"] as? String  {
                model.iconUrl = iconUlr
            }
            if let category = dict["category"] as? [String: Any], let attributes = category["attributes"] as? [String: Any], let type = attributes["label"] as? String {
                model.appType = type
            }
            modelArray.append(model)
        }
        self.modelArray = modelArray
    }
}
