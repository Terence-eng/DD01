//
//  UITableView+Extension.swift
//  DD01
//
//  Created by Terrence on 2019/12/8.
//  Copyright © 2019 DD01. All rights reserved.
//

import UIKit

extension UITableView {
    func dd_registerCellClass<T: UITableViewCell>(_ aClass: T.Type) {
        let name = String(describing: aClass)
        register(aClass, forCellReuseIdentifier: name)
    }
    
    func dd_dequeueReusableCell<T: UITableViewCell>(_ aClass: T.Type) -> T {
        let name = String(describing: aClass)
        guard let cell = dequeueReusableCell(withIdentifier: name) as? T else {
            fatalError("\(name) is not register")
        }
        return cell
    }
}
