//
//  ItemTableViewCell.swift
//  MyDiary
//
//  Created by Laibit on 2018/9/12.
//  Copyright © 2018年 Laibit. All rights reserved.
//

import UIKit

class ItemTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var quantityLabel: UILabel!
    @IBOutlet weak var iconImage: UIImageView!
    @IBOutlet weak var nextIconImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setData(image:UIImage ,title:String, quantity:String){
        iconImage.image = image
        titleLabel.text = title
        quantityLabel.text = quantity
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
