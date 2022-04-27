//
//  SelectTimeIntervalTableViewController.swift
//  NewsProject
//
//  Created by Chris Kim on 4/21/22.
//

import UIKit

class SelectTimeIntervalTableViewController: UITableViewController {
    
    let timeInterval: [Double] = {
        var tempTimeInterval: [Double] = []
        for i in 1..<60 {
            tempTimeInterval.append(Double(i))
        }
        return tempTimeInterval
    }()
    

    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return timeInterval.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "minuteCell", for: indexPath)
        if indexPath.row == 0 {
            cell.textLabel?.text = "\(timeInterval[indexPath.row]) minute"
        }
        cell.textLabel?.text = "\(timeInterval[indexPath.row]) minutes"

        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let userInfo = ["timeInterval": timeInterval[indexPath.row]]
        NotificationCenter.default.post(name: .sendSelectedTimeInterval, object: nil, userInfo: userInfo)
        navigationController?.popViewController(animated: true)
    }
}
