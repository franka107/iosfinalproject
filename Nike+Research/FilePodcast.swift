//
//  FilePodcast.swift
//  Nike+Research
//
//  Created by Mathi03 on 7/22/20.
//  Copyright © 2020 Developers Academy. All rights reserved.
//

import Foundation
import Firebase

class Podcast1 {
    var uid: String?
    var name: String?
    var image_url: String?
    var short_audio_url: String?
    var complete_audio_url: String?
    var price: Double?
    var detail: String?
    var large_detail: String?
    
   
    
    class func fetchPodcast() -> [Podcast1]
    {
        var podcasts = [Podcast1]()
        
        Database.database().reference().child("podcasts").observe(DataEventType.childAdded, with: { (snapshot) in
                    
            let pod = Podcast1()
            pod.uid = snapshot.key
            pod.name = (snapshot.value as! NSDictionary)["name"] as! String
//            pod.image_url = (snapshot.value as! NSDictionary)["image_url"] as! String
//            pod.short_audio_url = (snapshot.value as! NSDictionary)["short_audio_url"] as! String
//            pod.complete_audio_url = (snapshot.value as! NSDictionary)["complete_audio_url"] as! String
            //pod.price = (snapshot.value as! NSDictionary)["price"] as! Double
            pod.detail = (snapshot.value as! NSDictionary)["detail"] as! String
            podcasts.append(pod)
            print("Esto es detalles\(pod.uid)")
        })
    
        
        return podcasts
    }
}
