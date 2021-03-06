//
//  EntryDeatilView.swift
//  MyDiary
//
//  Created by Laibit on 2018/9/13.
//  Copyright © 2018年 Laibit. All rights reserved.
//

import UIKit

protocol EntryDeatilViewDelegate: class {
    func closeView()
}

extension EntryDeatilViewDelegate { //可選型別
    func closeView(){}
}

class EntryDeatilView: UIView {
    weak var delegate:EntryDeatilViewDelegate?
    
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet var view: UIView!
    
    @IBOutlet weak var monthLabel: UILabel!
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var weekAndYearLabel: UILabel!
    @IBOutlet weak var weatherAndLocationLabel: UILabel!
    
    
    override public init(frame: CGRect){
        super.init(frame: frame)
        self.setup()
    }
    
    required public init?(coder aDecoder: NSCoder){
        super.init(coder: aDecoder)
        self.setup()
    }
    
    convenience init(frame: CGRect, diaryStatus:DiaryStatus) {
        self.init(frame: frame)
        setup()
        showTime(diaryStatus: diaryStatus)
    }
    
    private func setup() {
        Bundle.init(for:EntryDeatilView.self).loadNibNamed("EntryDeatilView", owner: self, options: nil)
        guard let content = view else { return }
        content.frame = self.bounds
        content.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        content.layer.cornerRadius = 10;
        content.layer.shadowColor = UIColor.gray.cgColor
        content.layer.shadowOpacity = 1.0
        content.layer.shadowOffset = CGSize(width: 0, height: 0)
        content.layer.shadowRadius = 5
        content.layer.masksToBounds = false
        self.addSubview(content)
                
        view.layer.roundCorners([.topLeft, .topRight, .bottomLeft, .bottomRight], radius: 12)
        topView.layer.roundCorners([.topLeft,.topRight], radius: 12)
        bottomView.layer.roundCorners([.bottomLeft, .bottomRight], radius: 12)
    }
    
    func showTime(diaryStatus:DiaryStatus){
        switch diaryStatus {
        case .add:
            let (year, month, day, week, _) = Helper.generateNowTimes()
            monthLabel.text = "\(month)"
            dayLabel.text = "\(day)"
            weekAndYearLabel.text = "\(week)  \(year)"
        default:
            break
        }
        
    }
    
    @IBAction func closePressed(_ sender: UIButton) {
        self.delegate?.closeView()
    }
    
}
