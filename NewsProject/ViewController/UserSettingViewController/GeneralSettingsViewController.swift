//
//  GeneralSettingsViewController.swift
//  NewsProject
//
//  Created by Chris Kim on 2022/04/05.
//

import UIKit

class GeneralSettingsViewController: CommonViewController {
    
    
    @IBAction func closeVC(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
}



extension GeneralSettingsViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 1:
            return 2
        default:
            return 1
        }
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "GeneralSettingsTableViewCell") as! GeneralSettingsTableViewCell
        
        switch indexPath.section {
        case 0:
            cell.textLabel?.text = "여기에 계정 닉네임을 표시하자"
            // TODO: user 이용해서 isMarked 구현하기
            // TODO: Push Notification 정리 및 구현하기
            break
            
        case 1:
            cell.textLabel?.text = generalSettingLists[indexPath.row]
            cell.accessoryType = .disclosureIndicator
        case 2:
            cell.textLabel?.text = "Log Out"
        case 3:
            cell.textLabel?.text = "About This App"
            cell.accessoryType = .disclosureIndicator
        default:
            break
        }
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "Account"
        case 1:
            return "App Settings"
        default:
            return " "
        }
    }
}





extension GeneralSettingsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        switch indexPath.section {
        case 1:
            if indexPath.row == 0 {
                performSegue(withIdentifier: "noti", sender: self)
            } else {
                performSegue(withIdentifier: "display", sender: self)
            }
        case 3:
            performSegue(withIdentifier: "app", sender: self)
        case 2:
            alertLogOut(title: "Log Out",
                        message: "If you log out, your saved articles won't be available on this device until you log back in",
                        okHandler: nil,
                        cancelHandler: nil)
            // TODO: okHandler구현해서 logOut하도록 할 것
        default:
            break
        }
    }
}
