//
//  DDAppIconCacheManager.swift
//  DD01
//
//  Created by Terrence on 2019/12/8.
//  Copyright © 2019 DD01. All rights reserved.
//

import UIKit

class DDAppIconCacheManager: NSObject {
    static let sharedInstance = DDAppIconCacheManager()
    
    private var cacheQueue = DispatchQueue.init(label: "com.ddcacheManager.cacheQueue")
    
    private lazy var cache: NSCache<AnyObject, AnyObject> = {
        let cache = NSCache<AnyObject, AnyObject>()
        cache.name = "DDCacheManager"
        return cache
    }()
    
    func object(forKey key: String) -> UIImage? {
        if let image = cache.object(forKey: key as AnyObject) as? UIImage {
            return image
        }
        return nil
    }
    
    func setObject(_ obj: UIImage, forKey key: String) {
        cacheQueue.async { [weak self] in
            self?.cache.setObject(obj as AnyObject, forKey: key as AnyObject)
        }
    }
}
