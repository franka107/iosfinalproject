//
//  PodcastsTableViewController.swift
//  Nike+Research
//
//  Created by Mathi03 on 7/22/20.
//  Copyright © 2020 Developers Academy. All rights reserved.
//

import UIKit
import Firebase
import SDWebImage

class PodcastsTableViewController: UITableViewController {
    
    var podcasts:[Podcast1] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        Database.database().reference().child("podcasts").observe(DataEventType.childAdded, with: { (snapshot) in
            let pod = Podcast1()
            pod.uid = snapshot.key
            pod.name = (snapshot.value as! NSDictionary)["name"] as! String
//            pod.image_url = (snapshot.value as! NSDictionary)["image_url"] as! String
//            pod.short_audio_url = (snapshot.value as! NSDictionary)["short_audio_url"] as! String
//            pod.complete_audio_url = (snapshot.value as! NSDictionary)["complete_audio_url"] as! String
            pod.price = (snapshot.value as! NSDictionary)["price"] as! Double
            pod.detail = (snapshot.value as! NSDictionary)["detail"] as! String
            self.podcasts.append(pod)
            self.tableView.reloadData()
        })

    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if podcasts.count == 0 {
            return 1
        }else{
            return podcasts.count
        }
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
       
        
        if podcasts.count == 0 {
            cell.textLabel?.text = "No tienes Snaps 😂"
        }else{
            let pod = podcasts[indexPath.row]
            //let url = URL(string: pod.image_url!)
            //let url = NSURL(string: pod.image_url!)! as URL
            cell.textLabel?.text = pod.name
            cell.detailTextLabel?.text = pod.detail
            //cell.imageView?.sd_setImage(with: URL(string: pod.image_url!), completed: nil)
        
        }

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
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
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
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
