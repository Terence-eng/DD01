//
//  ViewController.swift
//  DD01
//
//  Created by Terrence on 2019/12/8.
//  Copyright © 2019 DD01. All rights reserved.
//

import UIKit
import SnapKit
import MBProgressHUD
import MJRefresh
//import SVProgressHUD

class DDHomeViewController: UIViewController {
    private var rankArray: [DDModel] = [DDModel]()
    private var rankAllArray: [DDModel] = [DDModel]()
    private let pageNumber: Int = 10
    private var currentPage: Int = 1
    
    private var isScrolling = false
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.backgroundColor = .white
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.keyboardDismissMode = UIScrollView.KeyboardDismissMode.onDrag
        tableView.dd_registerCellClass(DDRankViewCell.self)
        tableView.tableFooterView = UIView()
        tableView.rowHeight = 70
        tableView.mj_header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: #selector(loadData))
        return tableView
    }()
    
    private lazy var searchView: DDSearchView = {
        let searchView = DDSearchView()
        searchView.delegate = self
        return searchView
    }()
    
    private lazy var recommendView: DDRecommendView = {
        let recommendView = DDRecommendView()
        recommendView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 200)
        recommendView.autoresizingMask = .flexibleWidth 
        return recommendView
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        view.addSubview(tableView)
        tableView.tableHeaderView = recommendView
        navigationItem.titleView = searchView
        loadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.snp.makeConstraints{
                  $0.edges.equalToSuperview()
              }

        searchView.snp.makeConstraints{
              $0.edges.equalTo(UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10))
          }
    }
    override var prefersStatusBarHidden: Bool {
        return false
    }
    override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
        return .none
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
}



// MARK:-- UITableViewDelegate and UITableViewDataSource
extension DDHomeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return rankArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dd_dequeueReusableCell(DDRankViewCell.self)
        if indexPath.row < rankArray.count {
            cell.model = rankArray[indexPath.row]
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if tableView.mj_header != nil && tableView.mj_header.isRefreshing {
            return
        }
        if tableView.mj_footer != nil && tableView.mj_footer.isRefreshing {
            return
        }
        if tableView.isDragging == false && tableView.isDecelerating == false {
            return
        }
        let scaleAnimation = CABasicAnimation(keyPath: "transform")
        scaleAnimation.fromValue = NSValue(caTransform3D: CATransform3DMakeScale(0.8, 0.8, 1))
        scaleAnimation.toValue = NSValue(caTransform3D: CATransform3DMakeScale(1, 1, 1))
        scaleAnimation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeIn)
        cell.layer.add(scaleAnimation, forKey: "transform")
        
    }
    
}

//MARK: -- DDSearchBarDelegate
extension DDHomeViewController: DDSearchBarDelegate {

    func searchBar(textDidChange searchText: String) {
        
        recommendView.search(searchText: searchText)
        
        let originArray = rankAllArray[0...(min(pageNumber * currentPage , rankAllArray.count) - 1)]
        if searchText.count > 0 {
            
            let result = originArray.filter { (model) -> Bool in
                let pre = NSPredicate(format: "SELF CONTAINS[cd] %@", searchText)
                return pre.evaluate(with: model.name)
            }
            rankArray.removeAll()
            rankArray.append(contentsOf: result)
            tableView.reloadData()
            
            if tableView.mj_header != nil {
                tableView.mj_header.removeFromSuperview()
                tableView.mj_header = nil
            }
            if tableView.mj_footer != nil {
                tableView.mj_footer.removeFromSuperview()
                tableView.mj_footer = nil
            }
        }
        else {
            rankArray.removeAll()
            rankArray.append(contentsOf: originArray)
            
            if tableView.mj_header == nil {
                tableView.mj_header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: #selector(loadData))
            }
            if tableView.mj_footer == nil && rankArray.count >= pageNumber {
                tableView.mj_footer = MJRefreshAutoNormalFooter(refreshingTarget: self, refreshingAction: #selector(loadMoreData))
                if rankArray.count == rankAllArray.count {
                    tableView.mj_footer.endRefreshingWithNoMoreData()
                }
            }
            tableView.reloadData()
        }
    }
}

//MARK: -- loadData
extension DDHomeViewController {
    @objc private func loadData() {
        currentPage = 1
        
        if rankAllArray.count > 0 {
            if tableView.mj_footer != nil && rankArray.count == rankAllArray.count{
                tableView.mj_footer.resetNoMoreData()
            }
            if tableView.mj_header.isRefreshing {
                tableView.mj_header.endRefreshing()
            }
            rankArray.removeAll()
            rankArray.append(contentsOf: rankAllArray[0...(min(pageNumber, rankAllArray.count) - 1)])
            tableView.reloadData()
        }
        else {
            UIActivityIndicatorView.appearance(whenContainedInInstancesOf: [MBProgressHUD.self]).color = .white
            let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
            hud.bezelView.backgroundColor = .black
            hud.label.textColor = .white
            hud.label.text = "loading"
            
            let group = DispatchGroup()
            let workingQueue = DispatchQueue.global()

            workingQueue.async(group: group) {
                group.enter()
                DDNetworkManager().send(DDRecomendRequest()) {[weak self](parseModel) in
                    group.leave()
                    guard let self = self else { return }
                    guard let parseModel = parseModel else { return }
                    self.recommendView.modelArray = parseModel.modelArray
                    self.recommendView.originArray = parseModel.modelArray
                }
                
            }

            workingQueue.async(group: group) {
                group.enter()
                DDNetworkManager().send(DDRankRequest()) {[weak self] (parseModel) in
                    group.leave()
                    guard let self = self else { return }
                    guard let parseModel = parseModel else { return }
                    
                    self.rankAllArray.removeAll()
                    self.rankArray.removeAll()
                    
                    self.rankAllArray.append(contentsOf: parseModel.modelArray)
                    self.rankArray.append(contentsOf: self.rankAllArray[0...(min(self.pageNumber, self.rankAllArray.count) - 1)])
                    
                    
                }
            }
            
            group.notify(queue: DispatchQueue.main) {[weak self] in
                hud.hide(animated: true)
                guard let self = self else {return}
                self.tableView.reloadData()
                self.recommendView.reloadData()
                if self.tableView.mj_header.isRefreshing {
                    self.tableView.mj_header.endRefreshing()
                }
                if self.rankAllArray.count > self.pageNumber {
                    self.tableView.mj_footer = MJRefreshAutoNormalFooter(refreshingTarget: self, refreshingAction: #selector(self.loadMoreData))
                }
                else {
                    if self.tableView.mj_footer != nil {
                        self.tableView.mj_footer.removeFromSuperview()
                        self.tableView.mj_footer = nil
                    }
                }
            }
        }
    }
    
    @objc private func loadMoreData() {
        if self.rankArray.count < self.rankAllArray.count {
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {[weak self] in
                
                guard let self = self else {return}
                self.currentPage += 1
                self.rankArray.append(contentsOf: self.rankAllArray[self.rankArray.count...(min(self.rankAllArray.count,self.currentPage*self.pageNumber)-1)])
                self.tableView.reloadData()
                self.tableView.mj_footer.endRefreshing()
            }
        }
        else {
            tableView.mj_footer.endRefreshingWithNoMoreData()
        }
    }
}
