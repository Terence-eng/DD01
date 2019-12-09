//
//  DDStartView.swift
//  DD01
//
//  Created by Terrence on 2019/12/8.
//  Copyright © 2019 DD01. All rights reserved.
//

import UIKit



class DDStartView: UIView {
    static let kDDStartViewWidth: CGFloat = 80
    static let kDDStartViewHeight: CGFloat = 16
    
    private lazy var normalView: UIView = {
        let nv = UIView()
        return nv
    }()
    
    private lazy var selectView: UIView = {
        let sv = UIView()
        sv.clipsToBounds = true
        return sv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func rate(rate: CGFloat) {
        selectView.snp.updateConstraints {
            let rateWidth = DDStartView.kDDStartViewWidth * rate
            $0.top.left.bottom.equalToSuperview()
            $0.width.equalTo(rateWidth)
        }
    }
    
    private func configUI() {
        
        addSubview(normalView)
        normalView.snp.makeConstraints{
            $0.edges.equalToSuperview()
        }
        
        addSubview(selectView)
        selectView.snp.makeConstraints{
            $0.top.left.bottom.equalToSuperview()
            $0.width.equalTo(0)
        }
        
        
        let width = DDStartView.kDDStartViewHeight
        for index in 0...4 {
            let normalImg = UIImageView()
            normalImg.image = UIImage(named: "startNormal")
            normalView.addSubview(normalImg)
            
            normalImg.snp.makeConstraints {
                $0.left.equalTo((Int(width) * index) )
                $0.size.equalTo(CGSize(width: width, height: width))
                $0.top.equalTo(0)
            }
            
            let selectImg = UIImageView()
            selectImg.image = UIImage(named: "startSelect")
            selectView.addSubview(selectImg)
            selectImg.snp.makeConstraints {
                $0.left.equalTo((Int(width) * index))
                $0.size.equalTo(CGSize(width: width, height: width))
                $0.top.equalTo(0)
            }
        }
    }
}
