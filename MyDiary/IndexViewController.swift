//
//  IndexViewController.swift
//  MyDiary
//
//  Created by Laibit on 2018/9/12.
//  Copyright © 2018年 Laibit. All rights reserved.
//

import UIKit

class IndexViewController: UIViewController {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    @IBOutlet weak var profilePhotoImageView: UIImageView!
    @IBOutlet weak var itemTableView: UITableView!
    @IBOutlet weak var headView: UIView!
    @IBOutlet weak var bottomView: UIView!
    
    private var user = RLM_User()
    private let itemTitles = ["DIARY", "緊急聯絡人"]
    private let imageName = ["DIARY", "緊急聯絡人"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initData()
        initView()
    }
    
    func initView(){
        let image = #imageLiteral(resourceName: "blueskytable")
        let imageView = UIImageView(image: image)
        imageView.frame = CGRect(x: 0, y: 0, width: 375, height: 110)
        headView.addSubview(imageView)
        
    }
    
    func initData(){
        nameLabel.text = user.name
        detailLabel.text = user.email
        do {
            if user.picture.count > 0{
                let imageData = try Data(contentsOf: URL(string: user.picture)!)
                profilePhotoImageView.image = UIImage(data: imageData)
                profilePhotoImageView.clipsToBounds = true
                profilePhotoImageView.layer.cornerRadius = 40
            }
        } catch {
            print("Unable to load data: \(error)")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension IndexViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {        
        return 64
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let imageCell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath as IndexPath) as! ItemTableViewCell
        imageCell.setData(image: UIImage(), title: itemTitles[indexPath.row], quantity:"1")
        
        return imageCell
    }
    
    
}
