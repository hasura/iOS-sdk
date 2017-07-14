//
//  AuthenticationViewController.swift
//  Hasura-Todo-iOS
//
//  Created by Jaison on 17/01/17.
//  Copyright © 2017 Hasura. All rights reserved.
//

import UIKit
import Hasura

class AuthenticationViewController: UIViewController {
    
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    
    let imagePicker = UIImagePickerController()
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let client = try! Hasura.getClient()
        let user = client.currentUser
        
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        
        if user.isLoggedIn {
            navigateToTodoVC()
        }
        
        downloadFile()
    }
    
    func downloadFile() {
        self.activityIndicator.hidesWhenStopped = true
        activityIndicator.startAnimating()
        
        client.useFileservice(role: "customrole")
            .downloadFile(fileId: "A274E59D-EC6E-4D2C-B926-211F8A836593")
            .response { (downloadedData, progress, error) in
                guard progress == 100 || progress == -1 else {
                    print("Download progress: \(progress)")
                    return
                }
                self.activityIndicator.stopAnimating()
                if let file = downloadedData {
                    self.imageView.image = UIImage(data: file)
                } else {
                    self.handleError(error: error)
                }
        }
    }
    
    @IBAction func onUploadImageButtonClicked(_ sender: UIButton) {
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    
    @IBAction func onLoginButtonClicked(_ sender: UIButton) {
        guard isFormValid() else {
            return
        }
        
        user.username = username.text!
        user.password = password.text!
        
        user.login { (successful: Bool, error: HasuraError?) in
            if successful {
                self.navigateToTodoVC()
            } else {
                self.handleError(error: error)
            }
        }

    }
    
    @IBAction func onRegisterButtonClicked(_ sender: UIButton) {
        guard isFormValid() else {
            return
        }
        
        user.username = username.text!
        user.password = password.text!
        
        user.signUp { (isSuccessful, isPendingVerification, error) in
            if isSuccessful {
                if isPendingVerification {
                    
                } else {
                    self.navigateToTodoVC()
                }
            } else {
                self.handleError(error: error)
            }
        }
    }
    
    private func navigateToTodoVC() {
        let navigationVC = storyboard!.instantiateViewController(withIdentifier: "TodoNavigationController")
        self.present(navigationVC, animated: true, completion: nil)
    }
    
    private func isFormValid() -> Bool {
        if username.text!.isEmpty {
            showAlert(title: "Invalid",message: "Username field cannot be left empty")
            return false
        }
        
        if password.text!.isEmpty {
            showAlert(title: "Invalid", message: "Password field cannot be left empty")
            return false
        }
        return true
    }
}


extension AuthenticationViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            if let data = UIImagePNGRepresentation(pickedImage) {
                
                client.useFileservice(role: nil)
                    .uploadFile(file: data, mimeType: "image/*")
                    .response(callbackHandler: { (response: FileUploadResponse?, error: HasuraError?) in
                        if response != nil {
                            print("Successfully uploaded image")
                        } else {
                            self.handleError(error: error)
                        }
                    })
            }
        }
        
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        //TODO: Handle
        picker.dismiss(animated: true, completion: nil)
    }
    
    
}
