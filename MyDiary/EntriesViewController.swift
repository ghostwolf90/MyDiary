//
//  EntriesViewController.swift
//  MyDiary
//
//  Created by Laibit on 2018/9/12.
//  Copyright © 2018年 Laibit. All rights reserved.
//

import UIKit
import CoreLocation

enum DiaryStatus {
    case read
    case add
    case edit
    case delete
}

class EntriesViewController: UIViewController {

    @IBOutlet weak var middleView: UIView!
    @IBOutlet weak var entriesTableView: UITableView!
    
    private var entryDeatilView:EntryDeatilView!
    private var viewMask : UIView!
    private var locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
        setLocation()
    }
    
    func initView(){
        let image = #imageLiteral(resourceName: "loveSky")
        let imageView = UIImageView(image: image)
        imageView.frame = CGRect(x: 0, y: 0, width: entriesTableView.frame.size.width, height: entriesTableView.frame.size.height)
        //middleView.addSubview(imageView)
        entriesTableView.backgroundView = imageView
        entriesTableView.backgroundView?.alpha = 0.5
        entriesTableView.reloadData()
        //遮罩
        viewMask = UIView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height))
        viewMask.backgroundColor = UIColor.QlieerStyleGuide.qlrMask
        viewMask.isHidden = true
        self.view.addSubview(viewMask)
    }
    
    func setLocation(){
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    @IBAction func favoritePressed(_ sender: UIButton) {
        
    }
    
    @IBAction func addDiaryPressed(_ sender: UIButton) {
        showEntryDeatilView(diaryStatus: .add)
    }
    
    func showMaskView(isHidden:Bool){
        viewMask.isHidden = isHidden
    }
    
    //顯示已完成綁定畫面
    func showEntryDeatilView(diaryStatus:DiaryStatus){
        showMaskView(isHidden: false)
        let window = UIApplication.shared.keyWindow!
        let screenSize = window.frame.size
        let scannViewSize = CGSize(width: 330, height: 470)
        let rect = CGRect(x: (screenSize.width/2) - (scannViewSize.width / 2), y: (screenSize.height/2) - (scannViewSize.height/2), width: scannViewSize.width, height: scannViewSize.height)
        entryDeatilView = EntryDeatilView(frame: rect, diaryStatus: diaryStatus)
        entryDeatilView.delegate = self
        window.addSubview(entryDeatilView)
        entryDeatilView.center.y = screenSize.height + 100
        UIView.animate(withDuration: 0.24, animations: {
            self.entryDeatilView.center.y = scannViewSize.height - 100
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()        
    }
}

extension EntriesViewController: CLLocationManagerDelegate{
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation: CLLocation = locations[0]
        //CLGeocoder地理編碼 經緯度轉換地址位置
        CLGeocoder().reverseGeocodeLocation(userLocation) { (placemark, error) in
            if error == nil{
                if let placemark = placemark?[0] {
                    //print(placemark)
                    var address = ""
                    if placemark.subThoroughfare != nil {
                        address += placemark.subThoroughfare! + " "
                    }
                    if placemark.thoroughfare != nil {
                        address += placemark.thoroughfare! + "\n"
                    }
                    if placemark.subLocality != nil {
                        address += placemark.subLocality! + "\n"
                    }
                    if placemark.subAdministrativeArea != nil {
                        address += placemark.subAdministrativeArea! + "\n"
                    }
                    if placemark.postalCode != nil {
                        address += placemark.postalCode! + "\n"
                    }
                    if placemark.country != nil {
                        address += placemark.country!
                    }
                    print(String(address))
                }
            }
        }
    }
    
}

extension EntriesViewController: EntryDeatilViewDelegate{
    func closeView(){
        showMaskView(isHidden: true)
        entryDeatilView.removeFromSuperview()
    }
    
}

extension EntriesViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let entriesTableViewCell = cell as? EntriesTableViewCell{
            entriesTableViewCell.setCornerRadius(isFirst: indexPath.row == 0, isLast: true)
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width:584 , height: 8))
        headerView.backgroundColor = UIColor.clear
        let label = UILabel(frame: CGRect(x: 5, y: 15, width:584 , height: 30))
        label.font = UIFont(name:"PingFangTC-Regular", size: 40.0)
        label.textColor = UIColor.black
        //label.textAlignment = .center
        label.text = "9"
        headerView.addSubview(label)
        return headerView
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "9"
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 84
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let entriesCell = tableView.dequeueReusableCell(withIdentifier: "EntriesCell", for: indexPath as IndexPath) as! EntriesTableViewCell
        entriesCell.titleLabel.text = "123"
        return entriesCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        showEntryDeatilView(diaryStatus: .read)
        showMaskView(isHidden: false)
    }
    
}
