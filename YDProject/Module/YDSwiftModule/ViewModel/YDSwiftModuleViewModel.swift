//
//  YDSwiftModuleViewModel.swift
//  YDProject
//
//  Created by 王远东 on 2024/12/22.
//

import Foundation

class YDSwiftModuleViewModel {
    lazy var engine: YDSwfitModelEngine = YDSwfitModelEngine()
    lazy var list:[YDUser] = []
    private let disposeBag = DisposeBag()
    
    func setupEvents() {
        engine.subject.subscribe(onNext: { [weak self] (data) in
            guard let self = self else {return}
            if let action = data?["action"] as? String?{
                switch action {
                case "reloadListData":
                    if let error = data?["error"] as? String {
                        print(error)
                    } else {
                        if let list = data?["list"] as? Array<YDUser> {
                            self.list = list
                        }
                    }
                default:
                    print("default")
                }
            }
        }).disposed(by: disposeBag)
    }
}
