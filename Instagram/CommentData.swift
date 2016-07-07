//
//  CommentData.swift
//  Instagram
//
//  Created by 宮崎英美 on 2016/07/04. 課題追加
//  Copyright © 2016年 e-miya. All rights reserved.
//

import UIKit

class CommentData: NSObject {
//    var date: NSDate?
    var name: String?
    var comment: String?
    
    init(name: String, comment: String){
        
        self.name = name
        
        self.comment = comment
        
/*        // 時間を取得する
        let commentDate = NSDate(timeIntervalSinceReferenceDate:NSDate.timeIntervalSinceReferenceDate())
        self.date = commentDate
 */       
    }

}
