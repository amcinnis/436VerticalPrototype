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
    @IBOutlet weak var selectVideoButton: UIButton!
    @IBOutlet weak var videoView: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = true
        imagePicker.mediaTypes = ["public.movie"]
    }

    @IBAction func selectVideo(_ sender: Any) {
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let videoURL = info[UIImagePickerControllerReferenceURL] as? NSURL
        print("\(videoURL)")
//        selectVideoButton.isHidden = true
        imagePicker.dismiss(animated: true, completion: nil)
        
        if let url = videoURL {
            let player = AVPlayer(url: url as URL)
            let controller = AVPlayerViewController()
            controller.player = player
            player.externalPlaybackVideoGravity = AVLayerVideoGravityResizeAspectFill
            controller.view.frame = videoView.frame
            print("\(videoView.frame.origin)")
//            self.addChildViewController(controller)
            videoView.addSubview(controller.view)
//            self.present(controller, animated: true) {
//                controller.player?.play()
//            }
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
