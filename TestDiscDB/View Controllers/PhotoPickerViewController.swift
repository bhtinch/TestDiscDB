//
//  PhotoPickerViewController.swift
//  TestDiscDB
//
//  Created by Benjamin Tincher on 3/4/21.
//
import AVFoundation
import Photos
import UIKit

protocol PhotoPickerDelegate: AnyObject {
    func didSelect(image: UIImage)
}

class PhotoPickerViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    //  MARK: - Outlets
    //  MARK: - Properties
    let imagePicker = UIImagePickerController()
    weak var delegate: PhotoPickerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Camera Access
        AVCaptureDevice.requestAccess(for: AVMediaType.video) { response in
            if response {
                print("Camera Access Granted.")
            } else {
                print("no camera access granted.")
            }
        }
        
        //Photos Access
        let photos = PHPhotoLibrary.authorizationStatus()
        
        var photoAuthStatus = ""
        
        switch photos {
        case .notDetermined:
            photoAuthStatus = "notDetermined"
        case .restricted:
            photoAuthStatus = "restricted"
        case .denied:
            photoAuthStatus = "denied"
        case .authorized:
            photoAuthStatus = "authorized"
        case .limited:
            photoAuthStatus = "limited"
        @unknown default:
            photoAuthStatus = "unknown"
        }
        print("photoAuthStatus: \(photoAuthStatus)")
        
        if photos == .notDetermined {
            PHPhotoLibrary.requestAuthorization({status in
                if status == .authorized{
                    print("Photo Library Access Granted.")
                } else {
                    print("No photo library access granted.")
                }
            })
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        chooseMedia()
    }
    
    func chooseMedia() {
        let alertController = UIAlertController(title: "Add A Photo", message: nil, preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "Add A Photo", style: .cancel) { (_) in
            self.imagePicker.dismiss(animated: true, completion: nil)
        }
        
        let cameraAction = UIAlertAction(title: "Camera", style: .default) { (_) in
            self.openCamera()
        }
        
        let photoLibraryAction = UIAlertAction(title: "Photo Library", style: .default) { (_) in
            self.openGallery()
        }
        
        alertController.addAction(cancelAction)
        alertController.addAction(cameraAction)
        alertController.addAction(photoLibraryAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    func openCamera() {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            imagePicker.sourceType = .camera
            imagePicker.allowsEditing = false
            self.present(imagePicker, animated: true, completion: nil)
            
        } else {
            
            let alertController = UIAlertController(title: "No Camera Access", message: "Please allow access to the camera to use this feature", preferredStyle: .alert)
            
            let action = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(action)
            
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    func openGallery() {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            
            imagePicker.sourceType = .photoLibrary
            imagePicker.allowsEditing = false
            self.present(imagePicker, animated: true, completion: nil)
            
        } else {
            
            let alertController = UIAlertController(title: "No Photo Access", message: "Please allow access to the photo library to use this feature", preferredStyle: .alert)
            
            let action = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(action)
            
            self.present(alertController, animated: true, completion: nil)
            
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage {
            guard let delegate = delegate else { return }
            delegate.didSelect(image: image)
        }
        picker.dismiss(animated: true, completion: nil)
        self.dismiss(animated: true, completion: nil)
    }
    
}    //  End of Class
