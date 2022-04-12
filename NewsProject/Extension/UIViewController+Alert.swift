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
}
