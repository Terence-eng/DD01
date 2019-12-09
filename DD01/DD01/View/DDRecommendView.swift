//
//  DDRecommendView.swift
//  DD01
//
//  Created by Terrence on 2019/12/8.
//  Copyright © 2019 DD01. All rights reserved.
//

import UIKit

class DDRecommendView: UIView {
    
    private lazy var collectionView : UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
        layout.minimumInteritemSpacing = 1
        layout.minimumLineSpacing = 10
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 70, height: 130)
        let cw = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cw.backgroundColor = UIColor.white
        cw.dd_registerCellClass(DDRecommendViewCell.self)
        cw.delegate = self
        cw.dataSource = self
        cw.alwaysBounceHorizontal = true
        cw.showsHorizontalScrollIndicator = false
//        cw.alwaysBounceVertical = true
        return cw
    }()
    
    private lazy var recommendLabel: UILabel = {
        let rl = UILabel()
        rl.textColor = UIColor.hex(hexString: "#010101")
        rl.font = UIFont.systemFont(ofSize: 18)
        rl.text = "推荐"
        return rl
    }()
    
    private lazy var lineView: UIView = {
        let line = UIView()
        line.backgroundColor = UIColor.hex(hexString: "#838383")
        return line
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var modelArray: [DDModel] = [DDModel]()
    var originArray: [DDModel] = [DDModel]()
    
    private func configUI() {
        addSubview(recommendLabel)
        addSubview(collectionView)
        addSubview(lineView)
        recommendLabel.snp.makeConstraints {
            $0.left.equalTo(15)
            $0.top.equalTo(20)
        }
        
        collectionView.snp.makeConstraints {
            $0.top.equalTo(recommendLabel.snp_bottom).offset(15)
            $0.left.right.bottom.equalToSuperview()
        }
        
        lineView.snp.makeConstraints {
            $0.left.equalTo(15)
            $0.right.equalTo(-15)
            $0.bottom.equalToSuperview()
            $0.height.equalTo(0.5)
        }
    }
    
    func reloadData() {
        collectionView.reloadData()
    }
    
    func search(searchText: String) {
        if searchText.count > 0 {
            
            let result = originArray.filter { (model) -> Bool in
                let pre = NSPredicate(format: "SELF CONTAINS[cd] %@", searchText)
                return pre.evaluate(with: model.name)
            }
            modelArray.removeAll()
            modelArray.append(contentsOf: result)
        }
        else {
            modelArray.append(contentsOf: originArray)
        }
        collectionView.reloadData()
    }
}

//MARK: -- UICollectionViewDataSource AND UICollectionViewDelegateFlowLayout
extension DDRecommendView: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource  {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return modelArray.count
    }
        

        
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dd_dequeueReusableCell(DDRecommendViewCell.self, indexPath: indexPath)
        if indexPath.row < modelArray.count {
            cell.model = modelArray[indexPath.row]
        }
        return cell
    }
        
}
