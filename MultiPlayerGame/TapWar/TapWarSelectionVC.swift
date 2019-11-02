//
//  TapWarSelectionVC.swift
//  TicTacToe!
//
//  Created by Pawan Badsewal on 08/02/19.
//  Copyright © 2019 Pawan Badsewal. All rights reserved.
//

import UIKit


var tapWarGameMode:Int = 0
var tapWarNumberOfRounds:Int = 0


class TapWarSelectionVC: UIViewController {

    @IBOutlet var gameModeSC: UISegmentedControl!
    @IBOutlet var roundsSC: UISegmentedControl!
    @IBAction func unwindToTapWarSelectionVC(_ sender: UIStoryboardSegue) {}
    
    
    @IBAction func modeRoundSelectionAction(_ sender: UISegmentedControl) {
        if (sender.tag == 1){
            tapWarGameMode = gameModeSC.selectedSegmentIndex
        }else if (sender.tag == 2){
            tapWarNumberOfRounds = roundsSC.selectedSegmentIndex
        }
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        gameModeSC.selectedSegmentIndex = tapWarGameMode
        roundsSC.selectedSegmentIndex = tapWarNumberOfRounds
    }
    
}
