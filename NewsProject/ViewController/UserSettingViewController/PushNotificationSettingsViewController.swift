//
//  PushNotificationSettingsViewController.swift
//  NewsProject
//
//  Created by Chris Kim on 2022/04/05.
//

import UIKit
import CloudKit

class PushNotificationSettingsViewController: CommonViewController {
    
    @IBOutlet weak var todayNewsSwitch: UISwitch!
    
    @IBOutlet weak var reminderView: UIStackView!
    
    @IBOutlet weak var timeIntervalBtn: UIButton!
    
    @IBOutlet weak var reminderTypeSegmentedControl: UISegmentedControl!
    
    @IBOutlet weak var timeIntervalView: UIStackView!
    
    @IBOutlet weak var dateView: UIStackView!
    
    @IBOutlet weak var locationView: UIStackView!
    
    @IBOutlet weak var datePicker: UIDatePicker!
    
    @IBOutlet weak var latitudeTextField: UITextField!
    
    @IBOutlet weak var longitudeTextField: UITextField!
    
    @IBOutlet weak var radiusTextField: UITextField!
    
    @IBOutlet weak var repeatSwitch: UISwitch!
    
    @IBOutlet weak var timeIntervalLabel: UILabel!
    
    var selectedTimeInterval: Double?
    
    var isRepeats: Bool = false
    
    
    @IBAction func saveNotification(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func toggleTodayNewsSwitch(_ sender: Any) {
        UserDefaults.standard.set(todayNewsSwitch.isOn, forKey: "todayNews")
        reminderView.isHidden = todayNewsSwitch.isOn ? false : true
    }
    
    @IBAction func toggleReminderType(_ sender: Any) {
        let currentIndex = reminderTypeSegmentedControl.selectedSegmentIndex
        
        switch currentIndex {
        case 0:
            timeIntervalView.isHidden = false
            dateView.isHidden = true
            locationView.isHidden = dateView.isHidden
            
            guard let selectedTimeInterval = selectedTimeInterval,
                  let userId = usertemp.name else { return }
            let currentIndex = Int16(currentIndex)
            
            CommonDataManager.shared.updateTimeIntervalReminder(user: usertemp,
                                                                reminderType: currentIndex,
                                                                timeInterval: selectedTimeInterval) { [weak self] in
                guard let self = self else { return }
                NotificationManager.shared.scheduleNoti(id: userId,
                                                        reminderType: currentIndex,
                                                        timeInterval: selectedTimeInterval,
                                                        date: nil,
                                                        latitude: nil,
                                                        longitude: nil,
                                                        radius: nil,
                                                        repeats: self.isRepeats) {
                    
                }
            }
            
            #if DEBUG
            print(currentIndex)
            #endif
        case 1:
            dateView.isHidden = false
            timeIntervalView.isHidden = true
            locationView.isHidden = timeIntervalView.isHidden
            
            UserDefaults.standard.set(currentIndex, forKey: "dateReminder")
            
            #if DEBUG
            print(currentIndex)
            #endif
        case 2:
            locationView.isHidden = false
            timeIntervalView.isHidden = true
            dateView.isHidden = timeIntervalView.isHidden
            
            UserDefaults.standard.set(currentIndex, forKey: "locationReminder")
            
            #if DEBUG
            print(currentIndex)
            #endif
        default:
            break
        }
    }
    
    @IBAction func toggleRepeats(_ sender: Any) {
        UserDefaults.standard.set(repeatSwitch.isOn, forKey: "repeatNoti")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initialSetting()
//        CommonDataManager.shared.fetchUser()
        
        let token = NotificationCenter.default.addObserver(forName: .sendSelectedTimeInterval,
                                                       object: nil,
                                                       queue: .main,
                                                       using: { [weak self] (noti) in
            guard let self = self else { return }
            guard let timeInterval = noti.userInfo?["timeInterval"] as? Double else { return }
            self.timeIntervalLabel.text = "\(timeInterval) minutes"
            self.selectedTimeInterval = timeInterval
        })
        
        tokens.append(token)
    }
    
    
    
    func initialSetting() {
        timeIntervalBtn.setTitle("", for: .normal)
        
        todayNewsSwitch.isOn = UserDefaults.standard.bool(forKey: "todayNews")
        reminderView.isHidden = todayNewsSwitch.isOn ? false : true
        repeatSwitch.isOn = UserDefaults.standard.bool(forKey: "repeatNoti")
        isRepeats = repeatSwitch.isOn
        dateView.isHidden = true
        locationView.isHidden = true
    }
}



extension PushNotificationSettingsViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let lat = latitudeTextField.text,
              let lon = longitudeTextField.text,
              let rad = radiusTextField.text else { return }
        
    }
}
