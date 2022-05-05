//
//  PushNotificationSettingsViewController.swift
//  NewsProject
//
//  Created by Chris Kim on 2022/04/05.
//

import UIKit


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
    
    var selectedDate: Date?
    
    var selectedLat: Double?
    
    var selectedLon: Double?
    
    var selectedRad: Double?
    
    @IBAction func saveNotification(_ sender: Any) {
        
        if let selectedTimeInterval = selectedTimeInterval {
            NotificationManager.shared.scheduleNoti(id: signinUser?.name ?? "옵셔널 체이닝 제대로 안됬다 확인하자",
                                                    reminderType: ReminderType.timeInterval.rawValue,
                                                    timeInterval: selectedTimeInterval * 60,
                                                    date: nil,
                                                    latitude: nil,
                                                    longitude: nil,
                                                    radius: nil,
                                                    isReminder: repeatSwitch.isOn) {
                DispatchQueue.main.async {
                    self.dismiss(animated: true, completion: nil)
                }
            }
        }

        
        
        
        if let selectedDate = selectedDate {
            NotificationManager.shared.scheduleNoti(id: signinUser?.name ?? "옵셔널 체이닝 제대로 안됬다 확인하자",
                                                    reminderType: ReminderType.calendar.rawValue,
                                                    timeInterval: nil,
                                                    date: selectedDate,
                                                    latitude: nil,
                                                    longitude: nil,
                                                    radius: nil,
                                                    isReminder: repeatSwitch.isOn) {
                self.dismiss(animated: true, completion: nil)
            }
        }
        
        

        if let selectedLat = selectedLat,
           let selectedLon = selectedLon,
           let selectedRad = selectedRad {
            NotificationManager.shared.scheduleNoti(id: signinUser?.name ?? "옵셔널 체이닝 제대로 안됬다 확인하자",
                                                    reminderType: ReminderType.location.rawValue,
                                                    timeInterval: nil,
                                                    date: nil,
                                                    latitude: selectedLat,
                                                    longitude: selectedLon,
                                                    radius: selectedRad,
                                                    isReminder: repeatSwitch.isOn) {
                self.dismiss(animated: true, completion: nil)
            }
        }
        
       
    }
    
    
    @IBAction func selectDate(_ sender: Any) {
        selectedDate = datePicker.date
    }
    
    
    @IBAction func toggleTodayNewsSwitch(_ sender: Any) {
        UserDefaults.standard.set(todayNewsSwitch.isOn, forKey: "todayNews")
        reminderView.isHidden = todayNewsSwitch.isOn ? false : true
    }
    
    
    
    
    @IBAction func toggleReminderType(_ sender: Any) {
        let currentIndex = reminderTypeSegmentedControl.selectedSegmentIndex
        
        showNotificationView(currentIndex)
        
        UserDefaults.standard.set(currentIndex, forKey: "reminderType")
    }
    
    @IBAction func toggleRepeats(_ sender: Any) {
        UserDefaults.standard.set(repeatSwitch.isOn, forKey: "repeatNoti")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initialSetting()
        
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
    
    
    /// show different notification views based on reminderTypeSegmentedControl's currentIndex.
    /// - Parameter index: reminderTypeSegmentedControl Index
    func showNotificationView(_ index: Int) {
        switch index {
        case 0:
            timeIntervalView.isHidden = false
            dateView.isHidden = true
            locationView.isHidden = dateView.isHidden
        case 1:
            dateView.isHidden = false
            timeIntervalView.isHidden = true
            locationView.isHidden = timeIntervalView.isHidden
        case 2:
            locationView.isHidden = false
            timeIntervalView.isHidden = true
            dateView.isHidden = timeIntervalView.isHidden
            
            LocationManager.shared.requestAuthorization()
        default:
            break
        }
    }
    
    
    
    func initialSetting() {
        timeIntervalBtn.setTitle("", for: .normal)
        todayNewsSwitch.isOn = UserDefaults.standard.bool(forKey: "todayNews")
        reminderView.isHidden = todayNewsSwitch.isOn ? false : true
        repeatSwitch.isOn = UserDefaults.standard.bool(forKey: "repeatNoti")
        reminderTypeSegmentedControl.selectedSegmentIndex = UserDefaults.standard.integer(forKey: "reminderType")
        showNotificationView(reminderTypeSegmentedControl.selectedSegmentIndex)
    }
}



extension PushNotificationSettingsViewController: UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        guard let lat = latitudeTextField.text,
              let lon = longitudeTextField.text,
              let rad = radiusTextField.text else { return }
        
        if let latValue = Double(lat),
           let lonValue = Double(lon),
           let radValue = Double(rad) {
            
            if latValue > 90 || latValue < -90 {
                alertToEnterOnlyNumber(title: "Alert to User",
                                       message: "Please enter Latitude Value from -90 to +90",
                                       okHandler: nil)
            } else if lonValue > 180 || lonValue < -180 {
                alertToEnterOnlyNumber(title: "Alert to User",
                                       message: "Please enter Longitude Value from -180 to +180",
                                       okHandler: nil)
            }
            
            selectedLat = latValue
            selectedLon = lonValue
            selectedRad = radValue
        }
    }
    
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        guard let text = textField.text,
              let _ = Double(text) else { return false }
        
        return true
    }
}
