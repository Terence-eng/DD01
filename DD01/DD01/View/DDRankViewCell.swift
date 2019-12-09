//
//  DDRankViewCell.swift
//  DD01
//
//  Created by Terrence on 2019/12/8.
//  Copyright © 2019 DD01. All rights reserved.
//

import UIKit


class DDRankViewCell: UITableViewCell {
    
    private let appImageSize: CGSize = CGSize(width: 60, height: 60)
    private lazy var rankLabel: UILabel = {
        let rl = UILabel()
        rl.font = UIFont.systemFont(ofSize: 16)
        rl.textColor = UIColor.hex(hexString: "#838383")
        return rl
    }()
    
    private lazy var appImageView: UIImageView = {
        let img = UIImageView()
        
        return img
    }()
    
    private lazy var appName: UILabel = {
        let nameL = UILabel()
        nameL.font = UIFont.systemFont(ofSize: 14)
        nameL.textColor = UIColor.hex(hexString: "#3e3e3e")
        return nameL
    }()
    
    private lazy var appType: UILabel = {
        let appT = UILabel()
        appT.font = UIFont.systemFont(ofSize: 13)
        appT.textColor = UIColor.hex(hexString: "#838383")
        return appT
    }()
    
    private lazy var starView: DDStartView = {
        let starView = DDStartView()
        return starView
    }()
    
    private lazy var commentLabel: UILabel = {
        let cl = UILabel()
        cl.font = UIFont.systemFont(ofSize: 12)
        cl.textColor = UIColor.hex(hexString: "#838383")
        return cl
    }()
    
    var model: DDModel? {
        didSet {
            guard let model = model else { return }
            rankLabel.text = String(model.rank)
            appName.text = model.name
            appType.text = model.appType
            appImageView.isHidden = true
            commentLabel.text = "(\(model.commentNum))"
            starView.rate(rate: model.rate)
            if let iconUrl = model.iconUrl {
                
                if let cacheImg = DDAppIconCacheManager.sharedInstance.object(forKey: ("rank" + iconUrl)) {
                    appImageView.image = cacheImg
                    appImageView.isHidden = false
                }
                else {
                    appImageView.kf.setImage(with: URL(string: iconUrl), options: [.transition(.fade(0.5))]) {[weak self] (image, error, type, url) in
                        guard let image = image, error == nil else { return }
                        guard let self = self else { return }
                        
                        if model.rank % 2 == 0 {
                            if let outputImage = image.cutRoundCorner(size: self.appImageSize, radius: 8) {
                                self.appImageView.image = outputImage
                                DDAppIconCacheManager.sharedInstance.setObject(outputImage, forKey: ("rank" + iconUrl))
                                self.appImageView.isHidden = false
                            }
                        }
                        else {
                            if let outputImage = image.cutCircleImage(size: self.appImageSize) {
                                self.appImageView.image = outputImage
                                DDAppIconCacheManager.sharedInstance.setObject(outputImage, forKey: ("rank" + iconUrl))
                                self.appImageView.isHidden = false
                            }
                        }
                    }
                }
            }
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: UIDevice.orientationDidChangeNotification, object: nil)
    }
    private func configUI() {
        
        
        addDeviceOrientationDidChangeNotification()
        
        addSubview(rankLabel)
        addSubview(appImageView)
        addSubview(appName)
        addSubview(appType)
        addSubview(starView)
        addSubview(commentLabel)
        
        rankLabel.snp.makeConstraints {
            $0.left.equalTo(15)
            $0.width.equalTo(28)
            $0.centerY.equalToSuperview()
        }
        appImageView.snp.makeConstraints {
            $0.left.equalTo(rankLabel.snp_right).offset(8)
            $0.size.equalTo(appImageSize)
            $0.centerY.equalToSuperview()
        }
        
        appName.snp.makeConstraints{
            $0.top.equalTo(appImageView.snp_top).offset(2)
            $0.left.equalTo(appImageView.snp_right).offset(8)
            $0.right.equalTo(-15)
        }
        appType.snp.makeConstraints {
            $0.top.equalTo(appName.snp_bottom).offset(5)
            $0.left.right.equalTo(appName)
        }
        
        starView.snp.makeConstraints {
            $0.top.equalTo(appType.snp_bottom).offset(5)
            $0.left.equalTo(appName)
            $0.size.equalTo(CGSize(width: DDStartView.kDDStartViewWidth, height: DDStartView.kDDStartViewHeight))
        }
        
        commentLabel.snp.makeConstraints {
            $0.left.equalTo(starView.snp.right).offset(3)
            $0.top.equalTo(starView.snp_top)
            $0.right.equalToSuperview()
            $0.bottom.equalTo(starView.snp_bottom)
        }
    }
}

extension DDRankViewCell {
    func addDeviceOrientationDidChangeNotification() {
        NotificationCenter.default.addObserver(self,
        selector: #selector(handleDeviceOrientationChange(notification:)),
        name:UIDevice.orientationDidChangeNotification,
        object: nil)
    }
    
    @objc private func handleDeviceOrientationChange(notification: Notification) {
        // 获取设备方向
        let orientation = UIDevice.current.orientation
        switch orientation {
        case .landscapeRight, .landscapeLeft:
                // iOS8之后,横屏UIScreen.main.bounds.width等于竖屏时的UIScreen.main.bounds.height
            if isFullScreen {
                self.rankLabel.snp.updateConstraints {
                    $0.left.equalTo(40)
                    $0.width.equalTo(28)
                    $0.centerY.equalToSuperview()
                }
            }
        case .portrait:
            if isFullScreen {
                self.rankLabel.snp.updateConstraints {
                    $0.left.equalTo(15)
                    $0.width.equalTo(28)
                    $0.centerY.equalToSuperview()
                }
            }
            break
        default:
            break

        }
    }

}
