//
//  DisplaySettingsViewController.swift
//  NewsProject
//
//  Created by Chris Kim on 2022/04/05.
//

import UIKit

class DisplaySettingsViewController: CommonViewController {
    
    @IBOutlet weak var darkModeSwitch: UISwitch!
    
    @IBOutlet weak var systemTextSize: UISwitch!
    
    
    @IBAction func toggleDarkModeSwitch(_ sender: Any) {
        UserDefaults.standard.set(darkModeSwitch.isOn, forKey: "darkModeSwitch")
        let userInfo = ["mode": darkModeSwitch.isOn]
        NotificationCenter.default.post(name: .setDarktMode, object: nil, userInfo: userInfo)
    }
    
    
    @IBAction func toggleSystemTextSizeSwitch(_ sender: Any) {
        UserDefaults.standard.set(systemTextSize.isOn, forKey: "systemTextSize")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        darkModeSwitch.isOn = UserDefaults.standard.bool(forKey: "darkModeSwitch")
        systemTextSize.isOn = UserDefaults.standard.bool(forKey: "systemTextSize")
    }
}
