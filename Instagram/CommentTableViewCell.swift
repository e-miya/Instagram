//
//  CommentTableViewCell.swift
//  Instagram
//
//  Created by 宮崎英美 on 2016/07/05.
//  Copyright © 2016年 e-miya. All rights reserved.
//

import UIKit

class CommentTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var commentLabel: UILabel!
    
    var commentList: [String] = []
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func layoutSubviews() {
        for value in commentList{
            let comment = value.componentsSeparatedByString(" ")
            nameLabel.text = "\(comment[0])"
            commentLabel.text = "\(comment[1])"
        }
        
        super.layoutSubviews()
    }

}
