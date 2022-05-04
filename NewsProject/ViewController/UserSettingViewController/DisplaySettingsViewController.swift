//
//  DisplaySettingsViewController.swift
//  NewsProject
//
//  Created by Chris Kim on 2022/04/05.
//

import UIKit

class DisplaySettingsViewController: CommonViewController {
    
    @IBOutlet weak var darkModeSwitch: UISwitch!
    
    @IBOutlet weak var adjustTextSizeButton: UIButton!
    
    var fontSize: CGFloat?
    
    
    @IBAction func toggleDarkModeSwitch(_ sender: Any) {
        UserDefaults.standard.set(darkModeSwitch.isOn, forKey: "darkModeSwitch")
        let userInfo = ["mode": darkModeSwitch.isOn]
        NotificationCenter.default.post(name: .setDarktMode, object: nil, userInfo: userInfo)
    }
    
    
    @IBAction func goSetting(_ sender: Any) {
        let urlStr = UIApplication.openSettingsURLString
        guard let url = URL(string: urlStr) else { return }
        
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        adjustTextSizeButton.setTitle("", for: .normal)
        darkModeSwitch.isOn = UserDefaults.standard.bool(forKey: "darkModeSwitch")
    }
}
