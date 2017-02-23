//
//  SearchViewController.swift
//  VerticalPrototype
//
//  Created by Local Account 123-28 on 2/22/17.
//  Copyright © 2017 Austin McInnis. All rights reserved.
//

import UIKit
import Firebase

class SearchViewController: UIViewController, UITextFieldDelegate{
    
    private var videosRef = FIRDatabase.database().reference().child("videos")
    
    @IBOutlet weak var searchField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        searchField.delegate = self
    }
    
    @IBAction func search(_ sender: Any) {
        if searchField.text?.isEmpty == false {
            let searchKey = searchField.text!
            
            videosRef.observe(.value, with: {
                [weak self] (snapshot) in
                guard let this = self else { return }
                let videoID = snapshot.key
                let query = this.videosRef.child(videoID).queryOrdered(byChild: "name").queryEqual(toValue: searchKey)
                query.observeSingleEvent(of: .value, with: {
                    (newSnapshot) in
                    for child in newSnapshot.children.allObjects as! [FIRDataSnapshot] {
                        print("\(child.value)")
                    }
                })
            })
            
//            performSegue(withIdentifier: "SearchSegue", sender: nil)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchField.resignFirstResponder()
        return true
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "SearchSegue" {
            if let dest = segue.destination as? SearchTableViewController {
                
            }
        }
    }
 

}
