//
//  FilePodUser.swift
//  Nike+Research
//
//  Created by Mathi03 on 7/23/20.
//  Copyright © 2020 Developers Academy. All rights reserved.
//

import Foundation
import Firebase

class Podcast2 {
    var uid: String = ""
    var name: String = ""
    var image_url: String = ""
    var short_audio_url: String  = ""
    var complete_audio_url: String = ""
    var price: Double = 0
    var detail: String = ""
    var large_detail: String = ""
    
//    init(uid: String, name: String, image_url: String, price: Double, detail: String, large_detail: String, complete_audio_url: String)
//   {
//       self.uid = uid
//       self.name = name
//       self.image_url = image_url
//       self.price = price
//       self.large_detail = large_detail
//       self.detail = detail
//       self.complete_audio_url = complete_audio_url
//   }
    
    class func fetchPodcast() -> [Podcast2]
    {
        var podcasts = [Podcast2]()
        
        Database.database().reference().child("podcasts").observe(DataEventType.childAdded, with: { (snapshot) in
                    
            let pod = Podcast2()
            pod.uid = snapshot.key
            pod.name = (snapshot.value as! NSDictionary)["name"] as! String
//            pod.image_url = (snapshot.value as! NSDictionary)["image_url"] as! String
//            pod.short_audio_url = (snapshot.value as! NSDictionary)["short_audio_url"] as! String
//            pod.complete_audio_url = (snapshot.value as! NSDictionary)["complete_audio_url"] as! String
            pod.price = (snapshot.value as! NSDictionary)["price"] as! Double
            pod.detail = (snapshot.value as! NSDictionary)["detail"] as! String
            
            podcasts.append(pod)
            print("Esto es detalles\(pod.uid)")
        })
    
        
        return podcasts
    }
}
