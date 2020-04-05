//
//  EasyImageVideoPicker
//
//  Created by Avijit Babu on 04/05/2020.
//  Copyright (c) 2020 Avijit Babu. All rights reserved.
//

import Foundation
import UIKit
import AVKit
import Photos

public protocol EasyImageVideoPickerDelegate: class {
    func didSelect(image: UIImage?, video : URL?, fileName : String?)
}

public class EasyImageVideoPicker: NSObject {
    
    private let pickerController: UIImagePickerController
    private weak var presentationController: UIViewController?
    public var cameraPermissionText : String?
    public var videoPermissionText : String?
    public var microphonePermissionText : String?
    public var mediaPermissionText : String?
    public var photoPermissionText : String?
    private weak var delegate: EasyImageVideoPickerDelegate?
    
    public enum mediaType {
        case images
        case video
    }
    
    //Our class initializer
    public init(presentationController: UIViewController, delegate: EasyImageVideoPickerDelegate) {
        self.pickerController = UIImagePickerController()
        super.init()
        self.presentationController = presentationController
        self.delegate = delegate
        self.pickerController.delegate = self
        self.pickerController.allowsEditing = true
    }
    
    // Present your alert from here.
    public func present(from sourceView: UIView, mediaType : mediaType, onViewController : UIViewController) {
        sourceView.translatesAutoresizingMaskIntoConstraints = false
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        if mediaType == .video{
            self.pickerController.mediaTypes = ["public.movie"]
            let actionVideo = UIAlertAction(title: "Take Video", style: .default) { (action) in
                if AVCaptureDevice.authorizationStatus(for: .video) == .notDetermined || AVAudioSession.sharedInstance().recordPermission == .undetermined{
                    let _ = self.checkMicPermission()
                    let _ = self.checkCameraPermission()
                    self.presentAlert(sourceView: sourceView, alertController: alertController)
                }else{
                    if self.checkCameraPermission() && self.checkMicPermission(){
                        self.pickerController.sourceType = .camera
                        self.presentationController?.present(self.pickerController, animated: true)
                    }else{
                        self.presentCameraSettings(with: self.microphonePermissionText ?? "We need camera and microphone access for recording video", fromView: onViewController)
                    }
                }
            }
            var isVideo :Bool{
                if mediaType == .video {
                    return true
                }else if mediaType == .images{
                    return false
                }else{
                    return false
                }
            }
            if let actionLibrary  = self.checkPhotoLibrary(isVideo: isVideo, sourceView: sourceView, onViewController: onViewController, alertController: alertController){
                alertController.addAction(actionLibrary)
            }
            if UIImagePickerController.isSourceTypeAvailable(.camera){ alertController.addAction(actionVideo) }
        }else if mediaType == .images{
            self.pickerController.mediaTypes = ["public.image"]
            let actionCamera = UIAlertAction(title: "Take Photo", style: .default) { (action) in
                if AVCaptureDevice.authorizationStatus(for: .video) == .notDetermined{
                    let _ = self.checkCameraPermission()
                    self.presentAlert(sourceView: sourceView, alertController: alertController)
                }else{
                    if self.checkCameraPermission(){
                        self.pickerController.sourceType = .camera
                        self.presentationController?.present(self.pickerController, animated: true)
                    }else{
                        self.presentCameraSettings(with: self.cameraPermissionText ?? "We need camera access for capturing picture.", fromView: onViewController)
                    }
                }
            }
            
            if let actionLibrary  = self.checkPhotoLibrary(isVideo: false, sourceView: sourceView, onViewController: onViewController, alertController: alertController){
                alertController.addAction(actionLibrary)
            }
            if UIImagePickerController.isSourceTypeAvailable(.camera){ alertController.addAction(actionCamera) }
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        cancel.setValue(UIColor.red, forKey: "titleTextColor")
        alertController.addAction(cancel)
        presentAlert(sourceView: sourceView, alertController: alertController)
    }
    
    //Check which options are available for your device
    
    private func checkPhotoLibrary(isVideo : Bool,sourceView : UIView,onViewController : UIViewController,alertController : UIAlertController)-> UIAlertAction?{
        let actionLibrary = UIAlertAction(title: "\(isVideo ? "Video" : "Photo") Library", style: .default) { (action) in
            if PHPhotoLibrary.authorizationStatus() == .notDetermined{
                let _ = self.checkPhotoLibraryPermission()
                self.presentAlert(sourceView: sourceView, alertController: alertController)
            }else{
                if self.checkPhotoLibraryPermission(){
                    self.pickerController.sourceType = .photoLibrary
                    self.presentationController?.present(self.pickerController, animated: true)
                }else{
                    self.presentCameraSettings(with: isVideo ? (self.mediaPermissionText ?? "We gallery permission for pick video from you.") : (self.photoPermissionText ?? "We gallery permission for pick photos from you." ), fromView: onViewController)
                }
            }
        }
        return actionLibrary
    }
    
    //Present alert from here.
    
    private func presentAlert(sourceView : UIView, alertController : UIAlertController){
        if UIDevice.current.userInterfaceIdiom == .pad {
            alertController.popoverPresentationController?.sourceView = sourceView
            alertController.popoverPresentationController?.sourceRect = sourceView.bounds
            alertController.popoverPresentationController?.permittedArrowDirections = [.down, .up]
        }
        self.presentationController?.present(alertController, animated: true)
    }
    
    private func pickerController(_ controller: UIImagePickerController, image: UIImage?, video : URL?, file : String?) {
        controller.dismiss(animated: true, completion: nil)
        self.delegate?.didSelect(image: image, video: video, fileName: file)
    }
    
    //Check all camera permission here
    
    func checkCameraPermission() -> Bool{
        var permissionCheck: Bool = false
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .denied:
            permissionCheck = false
        case .restricted:
            permissionCheck = false
        case .authorized:
            permissionCheck = true
            
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { success in
                if success {
                    permissionCheck = true
                    
                } else {
                    permissionCheck = false
                }
            }
        default : break
        }
        return permissionCheck
    }
    
    func checkPhotoLibraryPermission() -> Bool {
        
        var permissionCheck: Bool = false
        let status = PHPhotoLibrary.authorizationStatus()
        switch status {
        case .authorized:
            permissionCheck = true
            break
        //handle authorized status
        case .denied, .restricted :
            permissionCheck = false
            break
        //handle denied status
        case .notDetermined:
            // ask for permissions
            PHPhotoLibrary.requestAuthorization { status in
                switch status {
                case .authorized:
                    permissionCheck = true
                    break
                // as above
                case .denied, .restricted:
                    permissionCheck = false
                    break
                // as above
                case .notDetermined:
                    permissionCheck = true
                    break
                // won't happen but still
                default : break
                }
            }
        default : break
        }
        return permissionCheck
    }
    
    func checkMicPermission() -> Bool {
        
        var permissionCheck: Bool = false
        switch AVAudioSession.sharedInstance().recordPermission {
        case .granted:
            permissionCheck = true
        case .denied:
            permissionCheck = false
        case .undetermined:
            AVAudioSession.sharedInstance().requestRecordPermission({ (granted) in
                if granted {
                    permissionCheck = true
                } else {
                    permissionCheck = false
                }
            })
        default:
            break
        }
        return permissionCheck
    }
    
    func presentCameraSettings(with text: String, fromView : UIViewController) {
        let alertController = UIAlertController(title: "Error",
                                                message: text,
                                                preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Cancel", style: .default))
        alertController.addAction(UIAlertAction(title: "Settings", style: .cancel) { _ in
            if let url = URL(string: UIApplication.openSettingsURLString) {
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(url, options: convertToUIApplicationOpenExternalURLOptionsKeyDictionary([:]), completionHandler: { _ in
                        // Handle
                    })
                } else {
                    print("this library does not support your version.")
                }
            }
        })
        fromView.present(alertController, animated: true)
    }
}

extension EasyImageVideoPicker: UIImagePickerControllerDelegate {
    
    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    @available(iOS 8.0, *)
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        // Local variable inserted by Swift 4.2 migrator.
        let info = convertFromUIImagePickerControllerInfoKeyDictionary(info)
        
        if let mediaURL = info[convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.mediaURL)] as? URL  {
            self.pickerController(picker, image: nil, video: mediaURL, file: mediaURL.lastPathComponent)
        }else{
            self.pickerController(picker, image: nil, video: nil, file: nil)
        }
        guard let image = info[convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.editedImage)] as? UIImage else {
            return self.pickerController(picker, image: nil, video: nil, file: nil)
        }
        self.pickerController(picker, image: image, video: nil, file: nil)
    }
    
//    @available(iOS 13.0, *)
//    override func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
//        if let mediaURL = info[UIImagePickerController.InfoKey.mediaURL] as? URL  {
//            self.pickerController(picker, image: nil, video: mediaURL, file: mediaURL.lastPathComponent)
//        }else{
//            self.pickerController(picker, image: nil, video: nil, file: nil)
//        }
//        guard let image = info[.editedImage] as? UIImage else {
//            return self.pickerController(picker, image: nil, video: nil, file: nil)
//        }
//        self.pickerController(picker, image: image, video: nil, file: nil)
//    }
    
}

extension EasyImageVideoPicker: UINavigationControllerDelegate {
    
}


// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKeyDictionary(_ input: [UIImagePickerController.InfoKey: Any]) -> [String: Any] {
	return Dictionary(uniqueKeysWithValues: input.map {key, value in (key.rawValue, value)})
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToUIApplicationOpenExternalURLOptionsKeyDictionary(_ input: [String: Any]) -> [UIApplication.OpenExternalURLOptionsKey: Any] {
	return Dictionary(uniqueKeysWithValues: input.map { key, value in (UIApplication.OpenExternalURLOptionsKey(rawValue: key), value)})
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKey(_ input: UIImagePickerController.InfoKey) -> String {
	return input.rawValue
}
