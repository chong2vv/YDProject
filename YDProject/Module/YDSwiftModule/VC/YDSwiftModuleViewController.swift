//
//  YDSwiftModuleViewController.swift
//  YDProject
//
//  Created by 王远东 on 2024/12/22.
//

import Foundation
import UIKit

@objc
class YDSwiftModuleViewController: UIViewController {
    lazy var engine:YDSwfitModelEngine = YDSwfitModelEngine()
    
    static func createVC() -> UIViewController  {
        let vc = YDSwiftModuleViewController()
        return vc
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        configUI()
        configDataSource()
        setupEvents()
    }
}

/**
 配置UI
 */
extension YDSwiftModuleViewController {
    func configUI() {
        title = "Swift测试模块"
        view.backgroundColor = .white
    }
}

/**
 数据源
 */
extension YDSwiftModuleViewController {
    func configDataSource() {
        engine.loadData()
    }
    
    func setupEvents() {
        
    }
}
