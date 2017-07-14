//
//  Extension-UIViewController.swift
//  Hasura-Todo-iOS
//
//  Created by Jaison on 17/01/17.
//  Copyright © 2017 Hasura. All rights reserved.
//

import UIKit
import Hasura

extension UIViewController {
    
    var client: HasuraClient {
        get {
            return try! Hasura.getClient()
        }
    }
    
    var user: HasuraUser {
        get {return try! Hasura.getClient().currentUser}
        set {}
    }
    
    func showAlert(title: String?, message: String?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func showErrorAlert(error: Error) {
        debugPrint("Error: \(error)")
        showAlert(title: "Error", message: error.localizedDescription)
    }
    
    func handleError(error: HasuraError?) {
        
    }
    
}
