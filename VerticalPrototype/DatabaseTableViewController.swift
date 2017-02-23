//
//  DatabaseTableViewController.swift
//  VerticalPrototype
//
//  Created by Local Account 123-28 on 2/22/17.
//  Copyright © 2017 Austin McInnis. All rights reserved.
//

import UIKit
import Firebase

class DatabaseTableViewController: UITableViewController {

    private var dataRef = FIRDatabase.database().reference()
    private var items = [FIRDataSnapshot]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        let videosRef = dataRef.child("videos")
        
        videosRef.observe(.childAdded, with: {
            [weak self] (snapshot) in
            guard let this = self else { return }
            this.items.append(snapshot)
            this.tableView.insertRows(at: [IndexPath(row: this.items.count-1, section:0)], with: .automatic)
        })
        
        videosRef.observe(.childRemoved, with: {
            [weak self] (snapshot) in
            guard let this = self else { return }
            let id = snapshot.childSnapshot(forPath: "id").value as? String
            var index = -1;
            for i in 0..<this.items.count {
                let snapshot = this.items[i]
                if snapshot.childSnapshot(forPath: "id").value as? String == id {
                    index = i
                }
            }
            this.items.remove(at: index)
            this.tableView.deleteRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
        })
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
//        let videosRef = dataRef.child("videos")
//        
//        videosRef.observe(.value, with: {
//            [weak self] (snapshot) in
//            guard let this = self else { return }
//            var newItems = [FIRDataSnapshot]()
//            
//            for item in snapshot.children {
//                newItems.append(item as! FIRDataSnapshot)
//            }
//            
//            this.items = newItems
//            this.tableView.reloadData()
//        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return items.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DatabaseEntry", for: indexPath)

        // Configure the cell...
        let snapshot = items[indexPath.row]
        cell.textLabel?.text = snapshot.childSnapshot(forPath: "name").value as? String
        cell.detailTextLabel?.text = snapshot.childSnapshot(forPath: "creation_date").value as? String
        
        return cell
    }
 

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
