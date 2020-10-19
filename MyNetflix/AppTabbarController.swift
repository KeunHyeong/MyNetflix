//
//  ViewController.swift
//  MyNetflix
//
//  Created by KeunHyeong on 2020/10/18.
//  Copyright © 2020 com.KeunHyeong. All rights reserved.
//

import UIKit

class AppTabbarController: UITabBarController {
    
   override var shouldAutorotate: Bool {
        return false
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
}
