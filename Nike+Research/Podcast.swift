//
//  Podcast.swift
//  Nike+Research
//
//  Created by Frank Cary Viveros on 7/21/20.
//  Copyright © 2020 Developers Academy. All rights reserved.
//


import UIKit
import Firebase
import FirebaseDatabase

class Podcast{
    var uid: String?
    var name: String?
    var image_url: String?
    var short_audio_url: String?
    var complete_audio_url: String?
    var price: Double?
    var detail: String?
    
    init(uid: String, name: String, image_url: String, short_audio_url:String, complete_audio_url: String,price: Double, detail: String){
        self.uid = uid
        self.name = name
        self.image_url = image_url
        self.short_audio_url = short_audio_url
        self.complete_audio_url = complete_audio_url
        self.price = price
        self.detail = detail
    }
    
    class func fetchPodcasts() -> [Podcast]{
        Database.database().reference().child('podcasts').observe(DataEventType.childAdded, with: {(snapshot) in
            let podcast = Podcast()
            podcast.uid = (snapshot.value as! NSDictionary)["uid"] as! String
        })
        return []
    }
}
