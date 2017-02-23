//
//  CameraViewController.swift
//  VerticalPrototype
//
//  Created by Local Account 123-28 on 2/21/17.
//  Copyright © 2017 Austin McInnis. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation
import Firebase
import FirebaseStorage

class CameraViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    
    var user: User?
    private var video: Video? {
        didSet {
            if video != nil {
                nameField.isEnabled = true
            }
            else {
                nameField.isEnabled = false
            }
        }
    }
    private var imagePicker = UIImagePickerController()
    private var player = AVPlayer()
    private var controller = AVPlayerViewController()
    @IBOutlet weak var selectVideoButton: UIButton!
    @IBOutlet weak var videoView: UIView!
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var uploadButton: UIButton!
    @IBOutlet weak var progressLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        imagePicker.mediaTypes = ["public.movie"]
        
        controller.view.frame = CGRect(x: 0, y: 0, width: videoView.frame.width, height: videoView.frame.height)
        self.addChildViewController(controller)
        videoView.addSubview(controller.view)
        
        nameField.delegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(CameraViewController.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(CameraViewController.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    @IBAction func takeVideo(_ sender: Any) {
        imagePicker.sourceType = .camera
        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func selectVideo(_ sender: Any) {
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let videoURL = info[UIImagePickerControllerMediaURL] as? NSURL
        print("\(videoURL)")
        imagePicker.dismiss(animated: true, completion: nil)
        nameField.placeholder = "Please Name Video"
        
        if let url = videoURL {
            video = Video()
            player = AVPlayer(url: url as URL)
            controller.player = player
            video?.url = url
            
            do {
                let attr = try FileManager.default.attributesOfItem(atPath: url.path!)
                let creationDate = attr[FileAttributeKey.creationDate] as? Date
                if let date = creationDate {
                    video?.creationDate = date as NSDate?
                }
            }
            catch {
                
            }
        }
    }
    
    @IBAction func upload(_ sender: Any) {
        if let video = video {
            video.name = nameField.text
        
            //Database
            let database = FIRDatabase.database()
            let databaseRef = database.reference()
            
            let videosRef = databaseRef.child("videos")
            let videoRef = videosRef.childByAutoId()
            videoRef.child("name").setValue(video.name)
            videoRef.child("id").setValue(videoRef.key)
            videoRef.child("creation_date").setValue(video.creationDate?.description)
            
            //Storage
            let storage = FIRStorage.storage()
            let storageRef = storage.reference()
            
            let videosRefStorage = storageRef.child("videos")
            let videoRefStorage = videosRefStorage.child(videoRef.key)
            if let url = video.url {
                let uploadTask = videoRefStorage.putFile(url as URL, metadata: nil) {
                    (metadata, error) in
                    if let error = error {
                        print("Error!: \(error.localizedDescription)")
                    }
                    else {
                        print("Upload Success!")
                    }
                }
                
                uploadTask.observe(.resume) {
                    [weak self] snapshot in
                    guard let this = self else { return }
                    this.uploadButton.isEnabled = false
                    this.uploadButton.isHidden = true
                    this.progressLabel.isHidden = false
                }
                
                uploadTask.observe(.progress) {
                    [weak self] snapshot in
                    guard let this = self else { return }
                    let percentComplete = 100.0 * Double(snapshot.progress!.completedUnitCount) / Double(snapshot.progress!.totalUnitCount)
                    this.progressLabel.text = "\(String(format: "%3.1f", percentComplete))% Uploaded"
                }
                
                uploadTask.observe(.success) {
                    [weak self] snapshot in
                    guard let this = self else { return }
                    this.progressLabel.isHidden = true
                    this.uploadButton.isHidden = false
                    this.nameField.isEnabled = false
                    this.nameField.text = ""
                    this.nameField.placeholder = "Please Select Video"
                    this.controller.player = nil
                    let alert = UIAlertController(title: "Success", message: "The file '\(video.name!)' successfully uploaded.", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    this.present(alert, animated: true, completion: nil)
                }
            }
        }
    }
    
    func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y != 0 {
                self.view.frame.origin.y += keyboardSize.height
            }
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if nameField.text?.isEmpty == false {
            uploadButton.isEnabled = true
        }
        else {
            uploadButton.isEnabled = false
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
