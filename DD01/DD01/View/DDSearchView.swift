//
//  DDSearchView.swift
//  DD01
//
//  Created by Terrence on 2019/12/8.
//  Copyright © 2019 DD01. All rights reserved.
//

import UIKit

protocol DDSearchBarDelegate {
    func searchBar(textDidChange searchText: String)
}

class DDSearchView: UIView {
    var delegate: DDSearchBarDelegate?
    
    lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.showsCancelButton = false
        searchBar.placeholder = "搜寻"
        searchBar.prompt = "搜寻"
        searchBar.delegate = self
        return searchBar
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configUI()
    }
    
    private func configUI() {
//        backgroundColor = UIColor(r: 228, g: 229, b: 230)
        addSubview(self.searchBar)
        self.searchBar.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension DDSearchView: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        delegate?.searchBar(textDidChange: searchText)
    }
}

