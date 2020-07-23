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
import TransitionButton

class PodcastsTableViewController: UITableViewController{
    
    var podcasts:[Podcast1] = []
    var cont = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        Database.database().reference().child("podcasts").observe(DataEventType.childAdded, with: { (snapshot) in
            let pod = Podcast1()
            pod.uid = snapshot.key
            pod.name = (snapshot.value as! NSDictionary)["name"] as! String
            pod.detail = (snapshot.value as! NSDictionary)["detail"] as! String
            pod.large_detail = (snapshot.value as! NSDictionary)["large_detail"] as! String
            pod.short_audio_url = (snapshot.value as! NSDictionary)["short_audio_url"] as! String
            pod.complete_audio_url = (snapshot.value as! NSDictionary)["complete_audio_url"] as! String
            pod.image_url = (snapshot.value as! NSDictionary)["image_url"] as! String
            pod.price = (snapshot.value as! NSDictionary)["price"] as! Double
            pod.imageID = (snapshot.value as! NSDictionary)["imageID"] as! String
            pod.audioID = (snapshot.value as! NSDictionary)["audioID"] as! String
            self.podcasts.append(pod)
            self.tableView.reloadData()
            print(pod.price)
            print(pod.audioID)
            print(pod.imageID)
            print(pod.name)
        })
        
        Database.database().reference().child("podcasts").observe(DataEventType.childChanged, with: { (snapshot) in
            self.cont = 0
            for podEdit in self.podcasts {
                if podEdit.uid == snapshot.key {
                    podEdit.name = (snapshot.value as! NSDictionary)["name"] as! String
                    podEdit.detail = (snapshot.value as! NSDictionary)["detail"] as! String
                    podEdit.large_detail = (snapshot.value as! NSDictionary)["large_detail"] as! String
                    podEdit.short_audio_url = (snapshot.value as! NSDictionary)["short_audio_url"] as! String
                    podEdit.complete_audio_url = (snapshot.value as! NSDictionary)["complete_audio_url"] as! String
                    podEdit.image_url = (snapshot.value as! NSDictionary)["image_url"] as! String
                    podEdit.price = (snapshot.value as! NSDictionary)["price"] as! Double
                    podEdit.imageID = (snapshot.value as! NSDictionary)["imageID"] as! String
                    podEdit.audioID = (snapshot.value as! NSDictionary)["audioID"] as! String
                    self.tableView.reloadData()
                
                self.cont = self.cont + 1
                }
            }
        })

    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
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
    
    override func viewWillAppear(_ animated: Bool) {
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let pod = podcasts[indexPath.row]
        performSegue(withIdentifier: "editarsegue", sender: pod)
        
    }
    
    @IBAction func SignOutAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "editarsegue"{
            let siguienteVC = segue.destination as! AddPodcastViewController
            siguienteVC.podEdit = sender as? Podcast1
        }
    }
}
