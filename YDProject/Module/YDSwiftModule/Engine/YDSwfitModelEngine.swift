//
//  YDSwfitModelEngine.swift
//  YDProject
//
//  Created by 王远东 on 2024/12/22.
//

import Foundation

class YDSwfitModelEngine {
    let subject = PublishSubject<[String:Any]?>()
    
    func loadData() {
        
        var params = [String:Any]()
//        params["studentId"] = "12312412321321"
        
        let list = Array(YDSwiftMiddleware.selectAllUser())
        if list.count > 0 {
            subject.onNext(["action":"reloadListData", "list": list])
        }else {
            subject.onNext(["action":"reloadListData", "error": "查找失败"])
        }
    }
}
