//
//  PostTableViewCell.swift
//  Instagram
//
//  Created by 宮崎英美 on 2016/06/27.
//  Copyright © 2016年 e-miya. All rights reserved.
//

import UIKit

class PostTableViewCell: UITableViewCell {

    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var likeLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var captionLabel: UILabel!
    
    @IBOutlet weak var commentButton: UIButton! // 課題追加
    @IBOutlet weak var commentLabel: UILabel!   // 課題追加
    
    var postData: PostData!
    var commentList: [Int: String] = [:]
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    //表示される時に呼ばれるメソッドをオーバーライドしてデータをUIに反映する
    override func layoutSubviews() {
        
        postImageView.image = postData.image
        captionLabel.text = "\(postData.name!)"
        
        let likeNumber = postData.likes.count
        likeLabel.text = "\(likeNumber)"
        
        let formatter = NSDateFormatter()
        formatter.locale = NSLocale(localeIdentifier: "ja_JP")
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        
        let dateString:String = formatter.stringFromDate(postData.date!)
        dateLabel.text = dateString
        
        if postData.isLiked{
            let buttonImage = UIImage(named: "like_exist")
            likeButton.setImage(buttonImage, forState: UIControlState.Normal)
        }else{
            let buttonImage = UIImage(named: "like_none")
            likeButton.setImage(buttonImage, forState: UIControlState.Normal)
        }
        
        if !postData.commentList.isEmpty {
            commentLabel.hidden = false
            var flag :Bool = false
            var text : String = ""
            for comment in postData.commentList{
                if flag == true{
                    text = text + "\n"
                }else{
                    flag = true
                }
                text = text + comment
            }
            commentLabel.text = text
        }else{
            commentLabel.hidden = true
        }
        
        super.layoutSubviews()
        
    }
    
}
