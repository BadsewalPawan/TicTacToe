//
//  launchVC.swift
//  brainFreeze
//
//  Created by Pawan Badsewal on 14/06/18.
//  Copyright © 2018 Pawan Badsewal. All rights reserved.
//

import UIKit

class launchVC: UIViewController {

    var timer:Timer = Timer()
    
    @objc func segue(){
        performSegue(withIdentifier: "selectionSegue", sender: Any?.self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        timer = Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(segue), userInfo: nil, repeats: false)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
