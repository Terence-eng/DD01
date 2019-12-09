//
//  UICollectionView+Extension.swift
//  DD01
//
//  Created by Terrence on 2019/12/8.
//  Copyright © 2019 DD01. All rights reserved.
//

import UIKit

extension UICollectionView {
    func dd_registerCellClass<T: UICollectionViewCell>(_ aClass: T.Type) {
        let name = String(describing: aClass)
        register(aClass, forCellWithReuseIdentifier: name)
    }
    
    func dd_dequeueReusableCell<T: UICollectionViewCell>(_ aClass: T.Type, indexPath: IndexPath) -> T {
        let name = String(describing: aClass)
        guard let cell = dequeueReusableCell(withReuseIdentifier: name, for: indexPath) as? T else {
            fatalError("\(name) is not register")
        }
        return cell
    }
}
