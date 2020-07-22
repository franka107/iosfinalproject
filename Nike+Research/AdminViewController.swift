//
//  AdminViewController.swift
//  Nike+Research
//
//  Created by Mathi03 on 7/22/20.
//  Copyright © 2020 Developers Academy. All rights reserved.
//

import UIKit

class AdminViewController: UIViewController {
    
    var userInfo = Userdata()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(userInfo.name)
        print(userInfo.type)
        print(userInfo.imageURL)
        
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
