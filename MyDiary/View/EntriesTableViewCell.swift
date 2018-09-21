//
//  EntriesTableViewCell.swift
//  MyDiary
//
//  Created by Laibit on 2018/9/12.
//  Copyright © 2018年 Laibit. All rights reserved.
//

import UIKit

class EntriesTableViewCell: UITableViewCell {

    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var weekLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var weatherImage: UIImageView!
    @IBOutlet weak var moodImage: UIImageView!
    @IBOutlet weak var favoriteBtn: UIButton!
    @IBOutlet weak var appendixImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()        
    }
    
    func setCornerRadius(isFirst:Bool = false, isLast:Bool = false){
        // 設定cell圓角
        var coners = UIRectCorner()
        if isFirst{
            coners.insert(UIRectCorner.topLeft)
            coners.insert(UIRectCorner.topRight)
        }
        
        if isLast{
            coners.insert(UIRectCorner.bottomLeft)
            coners.insert(UIRectCorner.bottomRight)
            //bottomlineView.backgroundColor = UIColor.white
        }
        
        layer.roundCorners(coners, radius: 4)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
