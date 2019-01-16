//
//  aiBeginnerViewController.swift
//  TicTacToe!
//
//  Created by Pawan Badsewal on 18/02/18.
//  Copyright © 2018 Pawan Badsewal. All rights reserved.
//

import UIKit

class aiBeginnerViewController: UIViewController {
    
    var board = [" ", " ", " ", " ", " ", " ", " ", " ", " "]
    let winningCombos = [ [0,1,2] , [3,4,5] , [6,7,8] , [0,3,6] , [1,4,7] , [2,5,8] , [0,4,8] , [2,4,6] ]
    var gameActive:Bool = true
    var winner:String?
    var iCount:Int = 0
    var elements:Int = 0
    var iPlayerCount:Int = 0
    var iDrawCount:Int = 0
    var iAiCount:Int = 0
    var aiSpot:UIButton!
    var iRandomSpot:Int!
    var aiPlayed:Bool = false
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
                            aiSpot = view.viewWithTag(iCount) as? UIButton
                            aiSpot.setImage(UIImage(named: themeSelected + playerAs + "Dull"), for: UIControl.State())
                        }else if (board[iCount-1] == aiAs) {
                            aiSpot = view.viewWithTag(iCount) as? UIButton
                            aiSpot.setImage(UIImage(named: themeSelected + aiAs + "Dull"), for: UIControl.State())
                        }
                    }else{
                        let btn = view.viewWithTag(iCount) as? UIButton
                        btn!.transform = CGAffineTransform(scaleX: 0.6, y: 0.6)
                        UIView.animate(withDuration: 2.0,
                                       delay: 0,
                                       usingSpringWithDamping: CGFloat(0.20),
                                       initialSpringVelocity: CGFloat(6.0),
                                       options: UIView.AnimationOptions.curveEaseIn,
                                       animations: {
                                        btn!.transform = CGAffineTransform.identity
                        },
                                       completion: { Void in()  }
                        )
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
                        aiSpot = view.viewWithTag(iCount) as? UIButton
                        aiSpot.setImage(UIImage(named: themeSelected + playerAs + "Dull"), for: UIControl.State())
                    }else if (board[iCount-1] == aiAs) {
                        aiSpot = view.viewWithTag(iCount) as? UIButton
                        aiSpot.setImage(UIImage(named: themeSelected + aiAs + "Dull"), for: UIControl.State())
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
    
    @objc func aiPlay(){
        activityIndicator.stopAnimating()
        UIApplication.shared.endIgnoringInteractionEvents()
        while (aiPlayed == false){
            iRandomSpot = Int(arc4random_uniform(9))
            if (board[iRandomSpot] == " "){
                aiSpot = view.viewWithTag(iRandomSpot+1) as? UIButton
                aiSpot.setImage(UIImage(named: themeSelected + aiAs), for: UIControl.State())
                board[iRandomSpot] = aiAs
                aiPlayed = true
            }
        }
        aiPlayed = false
        winner = checkWinner()
        declareWinner()
    }
    
    @IBAction func playAgain(_ sender: UIButton) {
        board = [" ", " ", " ", " ", " ", " ", " ", " ", " "]
        gameActive = true
        iCount = 0
        elements = 0
        playAgainbtn.isHidden = true
        statelbl.isHidden = true
        for i in 1...9{
            let button = view.viewWithTag(i) as! UIButton
            button.setImage(nil, for: UIControl.State())
        }
        if (playerAs == winner){
            iRandomDelay = Double(arc4random_uniform(4))
            activityIndicator.startAnimating()
            UIApplication.shared.beginIgnoringInteractionEvents()
            iTimer = Timer.scheduledTimer(timeInterval: iRandomDelay, target: self, selector: #selector(aiPlay), userInfo: nil, repeats: false)
        }
    }
    
    @IBAction func action(_ sender: UIButton) {
        if(gameActive == true){
            if (board[sender.tag-1] == " "){
                sender.setImage(UIImage(named: themeSelected + playerAs), for: UIControl.State())
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
        playerNamelbl.adjustsFontSizeToFitWidth = true
        statelbl.adjustsFontSizeToFitWidth = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

