//
//  aiProViewController.swift
//  TicTacToe!
//
//  Created by Pawan Badsewal on 19/02/18.
//  Copyright © 2018 Pawan Badsewal. All rights reserved.
//

import UIKit

class aiProViewController: UIViewController {

    var board = [" ", " ", " ", " ", " ", " ", " ", " ", " "]
    let winningCombos = [ [0,1,2] , [3,4,5] , [6,7,8] , [0,3,6] , [1,4,7] , [2,5,8] , [0,4,8] , [2,4,6] ]
    var cornerSpots = [0,2,6,8]
    var middleSpots = [1,3,5,7]
    var gameActive:Bool = true
    var winner:String?
    var iCount:Int = 0
    var elements:Int = 0
    var iPlayerCount:Int = 0
    var iDrawCount:Int = 0
    var iAiCount:Int = 0
    var aiSpot:UIButton!
    var aiPlayed:Bool = false
    var ix:Int = 0
    var iy:Int = 0
    var iz:Int = 0
    var iAiAttackingSpot:Int!
    var iAiDefendingSpot:Int!
    var iAiPlaySpot:Int!
    var bAiGoesFirst:Bool = false
    var iRemoveSpot:Int!
    var iTimer = Timer()
    var iRandomDelay:Double!
    
    @IBOutlet var statelbl: UILabel!
    @IBOutlet var playAgainbtn: UIButton!
    @IBOutlet var PlayerScorelbl: UILabel!
    @IBOutlet var drawScorelbl: UILabel!
    @IBOutlet var aiScorelbl: UILabel!
    @IBOutlet var boardHash: UIImageView!
    @IBOutlet var playerNamelbl: UILabel!
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    
    func checkWinner() -> (String){
        for combo in winningCombos{
            if (board[combo[0]] != " " && board[combo[0]] == board[combo[1]] && board[combo[0]] == board[combo[2]]){
                gameActive = false
                playAgainbtn.isHidden = false
                statelbl.isHidden = false
                for iCount in 1...9{
                    if(iCount-1 != combo[0] && iCount-1 != combo[1] && iCount-1 != combo[2]){
                        if (board[iCount-1] == playerAs){
                            aiSpot = view.viewWithTag(iCount) as! UIButton
                            aiSpot.setImage(UIImage(named: themeSelected + playerAs + "Dull"), for: UIControlState())
                        }else if (board[iCount-1] == aiAs) {
                            aiSpot = view.viewWithTag(iCount) as! UIButton
                            aiSpot.setImage(UIImage(named: themeSelected + aiAs + "Dull"), for: UIControlState())
                        }
                    }
                }
                return board[combo[0]]
            }
        }; elements = 0; iCount = 0
        while (elements < 9){
            if (board[elements] != " "){
                iCount+=1
            }; elements+=1
        }
        if (iCount == 9){
            gameActive = false
            playAgainbtn.isHidden = false
            statelbl.isHidden = false
            for iCount in 1...9{
                if (board[iCount-1] == playerAs){
                    aiSpot = view.viewWithTag(iCount) as! UIButton
                    aiSpot.setImage(UIImage(named: themeSelected + playerAs + "Dull"), for: UIControlState())
                }else if (board[iCount-1] == aiAs) {
                    aiSpot = view.viewWithTag(iCount) as! UIButton
                    aiSpot.setImage(UIImage(named: themeSelected + aiAs + "Dull"), for: UIControlState())
                }
            }
            return "Draw"
        }
        return " "
    }
    
    func declareWinner(){
        switch winner{
        case playerAs?:
            iPlayerCount+=1
            PlayerScorelbl.text = "\(iPlayerCount)"
            statelbl.text = "You win!"
        case aiAs?:
            iAiCount+=1
            aiScorelbl.text = "\(iAiCount)"
            statelbl.text = "AI win!"
        case "Draw"?:
            iDrawCount+=1
            drawScorelbl.text = "\(iDrawCount)"
            statelbl.text = "Draw"
        default:
            break
        }
    }

    func aiCornerPlay() -> Bool{
        while (cornerSpots.count > 0){
            iRemoveSpot = Int(arc4random_uniform(UInt32(cornerSpots.count)))
            iAiPlaySpot = cornerSpots[iRemoveSpot]
            cornerSpots.remove(at: iRemoveSpot)
            if (board[iAiPlaySpot] == " "){
                aiSpot = view.viewWithTag(iAiPlaySpot+1) as! UIButton
                aiSpot.setImage(UIImage(named: themeSelected + aiAs), for: UIControlState())
                board[iAiPlaySpot] = aiAs
                return true
            }
        }
        return false
    }

    func aiMiddlePlay() -> Bool{
        while (middleSpots.count > 0){
            iRemoveSpot = Int(arc4random_uniform(UInt32(middleSpots.count)))
            iAiPlaySpot = middleSpots[iRemoveSpot]
            middleSpots.remove(at: iRemoveSpot)
            if (board[iAiPlaySpot] == " "){
                aiSpot = view.viewWithTag(iAiPlaySpot+1) as! UIButton
                aiSpot.setImage(UIImage(named: themeSelected + aiAs), for: UIControlState())
                board[iAiPlaySpot] = aiAs
                return true
            }
        }
        return false
    }

    @objc func aiGoesFirst(){
        activityIndicator.stopAnimating()
        UIApplication.shared.endIgnoringInteractionEvents()
        if(Int(arc4random_uniform(2)) == 0){
            _ = aiCornerPlay()
        }else{
            aiSpot = view.viewWithTag(5) as! UIButton
            aiSpot.setImage(UIImage(named: themeSelected + aiAs), for: UIControlState())
            board[4] = aiAs
        }
        
    }
    
    @objc func aiPlay(){
        activityIndicator.stopAnimating()
        UIApplication.shared.endIgnoringInteractionEvents()
        iAiAttackingSpot = aiSearching(target: aiAs)
        if (iAiAttackingSpot<10){
            aiSpot = view.viewWithTag(iAiAttackingSpot) as! UIButton
            aiSpot.setImage(UIImage(named: themeSelected + aiAs), for: UIControlState())
            board[iAiAttackingSpot-1] = aiAs
        }else{
            iAiDefendingSpot = aiSearching(target: playerAs)
            if (iAiDefendingSpot<10){
                aiSpot = view.viewWithTag(iAiDefendingSpot) as! UIButton
                aiSpot.setImage(UIImage(named: themeSelected + aiAs), for: UIControlState())
                board[iAiDefendingSpot-1] = aiAs
            }else{
                aiPlayed = false
                if (bAiGoesFirst == true ){
                    aiPlayed = aiCornerPlay()
                    if (aiPlayed == false){
                        _ = aiMiddlePlay()
                    }
                }else{
                    if (board[4] == " "){
                        aiSpot = view.viewWithTag(5) as! UIButton
                        aiSpot.setImage(UIImage(named: themeSelected + aiAs), for: UIControlState())
                        board[4] = aiAs
                    }else if (board[4] == aiAs){
                        aiPlayed = aiMiddlePlay()
                        if (aiPlayed == false){
                            _ = aiCornerPlay()
                        }
                    }else if (board[4] == playerAs){
                        aiPlayed = aiCornerPlay()
                        if (aiPlayed == false){
                            _ = aiMiddlePlay()
                        }
                    }
                }
            }
        }
        winner = checkWinner()
        declareWinner()
    }
    
    func aiSearching(target: String) -> Int{
        for combo in winningCombos{
            for ix in 0...2{
                if (board[combo[ix]] == " "){
                    for iy in 0...2{
                        for iz in 0...2{
                            if (iz != iy && board[combo[iy]] == board[combo[iz]] && board[combo[iz]] == target){
                                return (combo[ix]+1)
                            }}}}}}
        return 11
    }
    
    @IBAction func playAgain(_ sender: UIButton) {
        board = [" ", " ", " ", " ", " ", " ", " ", " ", " "]
        gameActive = true
        iCount = 0
        elements = 0
        playAgainbtn.isHidden = true
        statelbl.isHidden = true
        cornerSpots = [0,2,6,8]
        middleSpots = [1,3,5,7]
        for i in 1...9{
            let button = view.viewWithTag(i) as! UIButton
            button.setImage(nil, for: UIControlState())
        }
        if (bAiGoesFirst == true){
            bAiGoesFirst = false
        }else{
            bAiGoesFirst = true
            iRandomDelay = Double(arc4random_uniform(4))
            activityIndicator.startAnimating()
            UIApplication.shared.beginIgnoringInteractionEvents()
            iTimer = Timer.scheduledTimer(timeInterval: iRandomDelay, target: self, selector: #selector(aiGoesFirst), userInfo: nil, repeats: false)
        }
    }
    
    @IBAction func action(_ sender: UIButton) {
        if(gameActive == true){
            if (board[sender.tag-1] == " "){
                sender.setImage(UIImage(named: themeSelected + playerAs), for: UIControlState())
                board[sender.tag-1] = playerAs
                winner = checkWinner()
                declareWinner()
                if (winner == " "){
                    iRandomDelay = Double(arc4random_uniform(4))
                    activityIndicator.startAnimating()
                    UIApplication.shared.beginIgnoringInteractionEvents()
                    iTimer = Timer.scheduledTimer(timeInterval: iRandomDelay, target: self, selector: #selector(aiPlay), userInfo: nil, repeats: false)
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        boardHash.image = UIImage(named: "\(themeSelected)#")
        playerNamelbl.text = player1Name
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
