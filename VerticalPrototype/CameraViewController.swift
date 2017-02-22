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

class CameraViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    private var imagePicker = UIImagePickerController()
    private var player = AVPlayer()
    private var controller = AVPlayerViewController()
    @IBOutlet weak var selectVideoButton: UIButton!
    @IBOutlet weak var videoView: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        imagePicker.mediaTypes = ["public.movie"]
        
        controller.view.frame = CGRect(x: 0, y: 0, width: videoView.frame.width, height: videoView.frame.height)
        self.addChildViewController(controller)
        videoView.addSubview(controller.view)
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
        imagePicker.dismiss(animated: true, completion: nil)
        
        if let url = videoURL {
            player = AVPlayer(url: url as URL)
            controller.player = player
        }
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
