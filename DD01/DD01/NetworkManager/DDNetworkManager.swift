//
//  DDNetworkManager.swift
//  DD01
//
//  Created by Terrence on 2019/12/8.
//  Copyright © 2019 DD01. All rights reserved.
//

import UIKit
import Alamofire
import Reachability
import MBProgressHUD
struct DDNetworkManager: DDClient {
    let host: String = "https://itunes.apple.com/hk/rss/"
    

    func send<T>(_ r: T, handle: @escaping (T.Response?) -> Void) where T : DDRequest {
        
        
        guard let url = URL(string: host.appending(r.path)) else {
            DispatchQueue.main.async {
               handle(nil)
            }
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = r.method.rawValue

        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let data = data,let res = T.Response.parse(data: data) {
                DispatchQueue.main.async {
                   handle(res)
                }
            }
            else {
                DispatchQueue.main.async {
                    
                    handle(nil)
                    if let error = error as NSError?, error.code == -1009 {
                        let hud = MBProgressHUD.showAdded(to: topVC!.view, animated: true)
                        hud.bezelView.backgroundColor = .black
                        hud.mode = .text
                        hud.label.textColor = .white
                        hud.label.text = "可怜的网络"
                        hud.hide(animated: true, afterDelay: 1.5)

                    }
                }
            }
        }
        task.resume()
    }
    
    
}

extension DDNetworkManager {
    
}
