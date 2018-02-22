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
    var randomSpot:Int!
    var aiPlayed:Bool = false
    var ix:Int = 0
    var iy:Int = 0
    var iz:Int = 0
    var iAiAttackingSpot:Int!
    var iAiDefendingSpot:Int!
    var iAiPlaySpot:Int!
    var aiGoFirst:Bool = false
    var iRemoveSpot:Int!
    
    @IBOutlet var statelbl: UILabel!
    @IBOutlet var playAgainbtn: UIButton!
    @IBOutlet var PlayerScorelbl: UILabel!
    @IBOutlet var drawScorelbl: UILabel!
    @IBOutlet var aiScorelbl: UILabel!
    @IBOutlet var boardHash: UIImageView!
    @IBOutlet var playerNamelbl: UILabel!
    
    func checkWinner() -> (String){
        for combo in winningCombos{
            if (board[combo[0]] != " " && board[combo[0]] == board[combo[1]] && board[combo[0]] == board[combo[2]]){
                gameActive = false
                playAgainbtn.isHidden = false
                statelbl.isHidden = false
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
    
    func aiPlay(){
        if (aiGoFirst == true ){
            while (aiPlayed == false){
                iRemoveSpot = Int(arc4random_uniform(UInt32(cornerSpots.count)))
                iAiPlaySpot = cornerSpots[iRemoveSpot]
                cornerSpots.remove(at: iRemoveSpot)
                if (board[iAiPlaySpot] == " "){
                    print("corenr play")
                    aiSpot = view.viewWithTag(iAiPlaySpot+1) as! UIButton
                    aiSpot.setImage(UIImage(named: themeSelected + aiAs), for: UIControlState())
                    board[iAiPlaySpot] = aiAs
                    aiPlayed = true
                }}
            aiPlayed = false
        }else{
            if (board[4] == " "){
                print("centre play")
                aiSpot = view.viewWithTag(5) as! UIButton
                aiSpot.setImage(UIImage(named: themeSelected + aiAs), for: UIControlState())
                board[4] = aiAs
            }else if (board[4] == aiAs) {
                while (aiPlayed == false){
                    iRemoveSpot = Int(arc4random_uniform(UInt32(middleSpots.count)))
                    if (iRemoveSpot > 0){
                        iAiPlaySpot = middleSpots[iRemoveSpot]
                        middleSpots.remove(at: iRemoveSpot)
                        if (board[iAiPlaySpot] == " "){
                            print("middle play")
                            aiSpot = view.viewWithTag(iAiPlaySpot+1) as! UIButton
                            aiSpot.setImage(UIImage(named: themeSelected + aiAs), for: UIControlState())
                            board[iAiPlaySpot] = aiAs
                            aiPlayed = true
                        }
                    }else{
                        iRemoveSpot = Int(arc4random_uniform(UInt32(cornerSpots.count)))
                        iAiPlaySpot = cornerSpots[iRemoveSpot]
                        cornerSpots.remove(at: iRemoveSpot)
                        if (board[iAiPlaySpot] == " "){
                            print("corenr play ai gofirst false")
                            aiSpot = view.viewWithTag(iAiPlaySpot+1) as! UIButton
                            aiSpot.setImage(UIImage(named: themeSelected + aiAs), for: UIControlState())
                            board[iAiPlaySpot] = aiAs
                            aiPlayed = true
                        }
                    }
                }
                aiPlayed = false
            }else if (board[4] == playerAs) {
                while (aiPlayed == false){
                    iRemoveSpot = Int(arc4random_uniform(UInt32(cornerSpots.count)))
                    iAiPlaySpot = cornerSpots[iRemoveSpot]
                    cornerSpots.remove(at: iRemoveSpot)
                    if (board[iAiPlaySpot] == " "){
                        print("corenr play")
                        aiSpot = view.viewWithTag(iAiPlaySpot+1) as! UIButton
                        aiSpot.setImage(UIImage(named: themeSelected + aiAs), for: UIControlState())
                        board[iAiPlaySpot] = aiAs
                        aiPlayed = true
                    }}
                aiPlayed = false
            }
        }
    }
    
    func aiSearching(target: String) -> Int{
        for combo in winningCombos{
            for ix in 0...2{
                if (board[combo[ix]] == " "){
                    for iy in 0...2{
                        for iz in 0...2{
                            if (iz != iy && board[combo[iy]] == board[combo[iz]] && board[combo[iz]] == target){
                                print(board)
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
        if (aiGoFirst == true){
            aiGoFirst = false
        }else{
            aiGoFirst = true
            aiPlay()
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
                    iAiAttackingSpot = aiSearching(target: aiAs)
                    if (iAiAttackingSpot<10){
                        print("attacking")
                        aiSpot = view.viewWithTag(iAiAttackingSpot) as! UIButton
                        aiSpot.setImage(UIImage(named: themeSelected + aiAs), for: UIControlState())
                        board[iAiAttackingSpot-1] = aiAs
                        print(board)
                    }else{
                        iAiDefendingSpot = aiSearching(target: playerAs)
                        if (iAiDefendingSpot<10){
                            print("defending")
                            aiSpot = view.viewWithTag(iAiDefendingSpot) as! UIButton
                            aiSpot.setImage(UIImage(named: themeSelected + aiAs), for: UIControlState())
                            board[iAiDefendingSpot-1] = aiAs
                            print(board)
                        }else{
                            aiPlay()
                            print(board)
                        }
                    }
                    winner = checkWinner()
                    declareWinner()
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
