//
//  DDRecommendViewCell.swift
//  DD01
//
//  Created by Terrence on 2019/12/8.
//  Copyright © 2019 DD01. All rights reserved.
//

import UIKit
import Kingfisher
class DDRecommendViewCell: UICollectionViewCell {
//    private lazy var iconCache: NSCache = {
//        
//    }()
    
    private let appImageSize: CGSize = CGSize(width: 60, height: 60)
    
    private lazy var appImageView: UIImageView = {
        let img = UIImageView()
        return img
    }()
    
    private lazy var appNameLabel: UILabel = {
        let nl = UILabel()
        nl.font = UIFont.systemFont(ofSize: 14)
        nl.textColor = UIColor.hex(hexString: "#3e3e3e")
        nl.numberOfLines = 2
        nl.text = "sdfdsffsfs"
        return nl
    }()

    private lazy var appTypeLabel: UILabel = {
        let typeL = UILabel()
        typeL.font = UIFont.systemFont(ofSize: 13)
        typeL.textColor = UIColor.hex(hexString: "#838383")
        typeL.text = "bbsdfs"
        return typeL
    }()
    
    
    var model: DDModel? {
        didSet {
            guard let model = model else { return }
            appNameLabel.text = model.name
            appTypeLabel.text = model.appType
            appImageView.isHidden = true
            if let iconUrl = model.iconUrl {
                if let cacheImg = DDAppIconCacheManager.sharedInstance.object(forKey: iconUrl) {
                    appImageView.image = cacheImg
                    appImageView.isHidden = false
                }
                else {
                    appImageView.kf.setImage(with: URL(string: iconUrl), options: [.transition(.fade(0.5))]) {[weak self] (image, error, type, url) in
                        guard let image = image, error == nil else { return }
                        guard let self = self else { return }
                        if let outputImage = image.cutRoundCorner(size: self.appImageSize, radius: 8) {
                            self.appImageView.image = outputImage
                            DDAppIconCacheManager.sharedInstance.setObject(outputImage, forKey: iconUrl)
                            self.appImageView.isHidden = false
                        }
                    }
                }
            }
            
        }
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configUI()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private func configUI(){
        
        
        addSubview(appImageView)
        addSubview(appNameLabel)
        addSubview(appTypeLabel)
        
        appImageView.snp.makeConstraints {
            $0.top.equalTo(0)
            $0.centerX.equalToSuperview()
            $0.size.equalTo(appImageSize)
        }
        
        appNameLabel.snp.makeConstraints {
            $0.top.equalTo(appImageView.snp_bottom).offset(5)
            $0.left.right.equalTo(appImageView)
        }
        
        appTypeLabel.snp.makeConstraints {
            $0.top.equalTo(appNameLabel.snp_bottom).offset(5)
            $0.left.right.equalTo(appImageView)
        }
    }
}
