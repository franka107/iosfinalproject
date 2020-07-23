//
//  FeedShoeTableViewCell.swift
//  Nike+Research
//
//  Created by Duc Tran on 3/19/17.
//  Copyright © 2017 Developers Academy. All rights reserved.
//

import UIKit

class FeedShoeTableViewCell : UITableViewCell
{
    @IBOutlet weak var shoeImageView: UIImageView!
    @IBOutlet weak var shoeNameLabel: UILabel!
    @IBOutlet weak var shoePriceLabel: UILabel!
    
    var podcast: Podcast2!{
        didSet {
            self.updateUI()
        }
    }
    
    func updateUI()
    {
        //shoeImageView.image = podcast.images?.first
        print("AQUI EL URL\(podcast.image_url)")
        shoeImageView?.sd_setImage(with: URL(string: podcast.image_url))
        shoeNameLabel?.text = podcast.name
       
        shoePriceLabel.text = "$\(podcast.price)"
        
    }
}
