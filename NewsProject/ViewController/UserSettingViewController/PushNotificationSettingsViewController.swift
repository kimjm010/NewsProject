//
//  PushNotificationSettingsViewController.swift
//  NewsProject
//
//  Created by Chris Kim on 2022/04/05.
//

import UIKit

class PushNotificationSettingsViewController: CommonViewController {
    
    @IBOutlet weak var todayNews: UISwitch!
    
    @IBOutlet weak var covidNews: UISwitch!
    
    @IBOutlet weak var selectedNews: UISwitch!
    
    
    @IBAction func toggleTodayNewsSwitch(_ sender: Any) {
        UserDefaults.standard.set(todayNews.isOn, forKey: "todayNews")
    }
    
    
    @IBAction func toggleCovidNewsSwitch(_ sender: Any) {
        UserDefaults.standard.set(covidNews.isOn, forKey: "covidNews")
    }
    
    
    @IBAction func toggleSelectedNewsSwitch(_ sender: Any) {
        UserDefaults.standard.set(selectedNews.isOn, forKey: "selectedNews")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        todayNews.isOn = UserDefaults.standard.bool(forKey: "todayNews")
        covidNews.isOn = UserDefaults.standard.bool(forKey: "covidNews")
        selectedNews.isOn = UserDefaults.standard.bool(forKey: "selectedNews")
    }
    
}
