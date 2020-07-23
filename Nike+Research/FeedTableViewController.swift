//
//  FeedTableViewController.swift
//  Nike+Research
//
//  Created by Duc Tran on 3/19/17.
//  Copyright © 2017 Developers Academy. All rights reserved.
//

import UIKit
import Firebase
import SDWebImage
import FirebaseDatabase
class FeedTableViewController : UITableViewController
{
    var shoes: [Shoe]?
    var podcasts: [Podcast2]=[]
    
    @IBOutlet weak var imageProduct: UIImageView!
    @IBOutlet weak var nameProduct: UILabel!
    @IBOutlet weak var priceProduct: UILabel!
    struct Storyboard {
        static let feedShoeCell = "FeedShoeCell"
        static let showShoeDetail = "ShowShoeDetail"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "FEED"
        
        //shoes = Shoe.fetchShoes()
        //podcasts = Podcast2.fetchPodcast()
        
        Database.database().reference().child("podcasts").observe(DataEventType.childAdded, with: { (snapshot) in
                            
                    let pod = Podcast2()
                    pod.uid = snapshot.key
                    pod.name = (snapshot.value as! NSDictionary)["name"] as! String
                    pod.image_url = (snapshot.value as! NSDictionary)["image_url"] as! String
        //            pod.short_audio_url = (snapshot.value as! NSDictionary)["short_audio_url"] as! String
        //            pod.complete_audio_url = (snapshot.value as! NSDictionary)["complete_audio_url"] as! String
                    pod.price = (snapshot.value as! NSDictionary)["price"] as! Double
                    pod.detail = (snapshot.value as! NSDictionary)["detail"] as! String
                    
            self.podcasts.append(pod)
                    print("Esto es detalles\(pod.uid)")
                })
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            print("Lista de podcats\(self.podcasts.count)")
        self.tableView.reloadData()
        self.tableView.estimatedRowHeight = self.tableView.rowHeight
            self.tableView.rowHeight = UITableViewAutomaticDimension}
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Storyboard.showShoeDetail {
            if let shoeDetailTVC = segue.destination as? ShoeDetailTableViewController {
                let selectedShoe = self.podcasts[(sender as! IndexPath).row]
                shoeDetailTVC.pod = selectedShoe
            }
        }
    }
}

// MARK - UITableViewDataSource

extension FeedTableViewController
{
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if podcasts.count == 0 {
            return 1
        }else{
            return podcasts.count
        }
//        if let podcasts = podcasts{
//            return podcasts.count
//        }else{
//            return 0
//        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Storyboard.feedShoeCell, for: indexPath) as! FeedShoeTableViewCell
        
//        if podcasts.count == 0 {
//            cell.textLabel?.text = "No tienes Snaps 😂"
//        }else{
//            let pod = podcasts[indexPath.row]
//            //let url = URL(string: pod.image_url!)
//            //let url = NSURL(string: pod.image_url!)! as URL
//            cell.textLabel?.text = pod.name
//            cell.detailTextLabel?.text = pod.detail
//            cell.imageView?.sd_setImage(with: URL(string: pod.image_url!))
//        
//        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
        cell.podcast = self.podcasts[indexPath.row]
            cell.selectionStyle = .none}

        
        return cell
    }

}


// MARK: - UITableViewDelegate

extension FeedTableViewController
{
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: Storyboard.showShoeDetail, sender: indexPath)
    }
}




















