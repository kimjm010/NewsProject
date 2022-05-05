//
//  UIViewController+Alert.swift
//  NewsProject
//
//  Created by Chris Kim on 2022/04/11.
//

import UIKit

extension UIViewController {
    
    func alertLogOut(title: String,
               message: String,
               okHandler: ((UIAlertAction) -> Void)? = nil,
               cancelHandler: ((UIAlertAction) -> Void)? = nil) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK", style: .destructive, handler: okHandler)
        alertController.addAction(okAction)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: cancelHandler)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    
    func alertToEnterOnlyNumber(title: String, message: String, okHandler: ((UIAlertAction) -> Void)? = nil) {
        let controller = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK", style: .default, handler: okHandler)
        controller.addAction(okAction)
        
        present(controller, animated: true, completion: nil)
    }
    
    
    func alertGoToSetting(title: String, message: String, okHandelr: ((UIAlertAction) -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "Go", style: .default, handler: okHandelr)
        alert.addAction(okAction)
        
        let laterAction = UIAlertAction(title: "Later", style: .cancel, handler: nil)
        alert.addAction(laterAction)
        
        present(alert, animated: true, completion: nil)
    }
    
}
