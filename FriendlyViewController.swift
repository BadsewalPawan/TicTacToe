//
//  FriendlyViewController.swift
//  
//
//  Created by Pawan Badsewal on 18/02/18.
//

import UIKit

class FriendlyViewController: UIViewController {

    var playerActive:Bool = true
    var board = [" ", " ", " ", " ", " ", " ", " ", " ", " "]
    let winningCombos = [ [0,1,2] , [3,4,5] , [6,7,8] , [0,3,6] , [1,4,7] , [2,5,8] , [0,4,8] , [2,4,6] ]
    var gameActive:Bool = true
    var winner:String?
    var iCount:Int = 0
    var elements:Int = 0
    var iPlayer1Count:Int = 0
    var iDrawCount:Int = 0
    var iPlayer2Count:Int = 0
    
    @IBOutlet var statelbl: UILabel!
    @IBOutlet var playAgainbtn: UIButton!
    @IBOutlet var Player1Scorelbl: UILabel!
    @IBOutlet var drawScorelbl: UILabel!
    @IBOutlet var Player2Scorelbl: UILabel!
    @IBOutlet var boardHash: UIImageView!
    @IBOutlet var player1Namelbl: UILabel!
    @IBOutlet var player2Namelbl: UILabel!
    
    func checkWinner() -> (String){
        for combo in winningCombos{
            if (board[combo[0]] != " " && board[combo[0]] == board[combo[1]] && board[combo[0]] == board[combo[2]]){
                gameActive = false
                playAgainbtn.isHidden = false
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
            return "Draw"
        }
        return " "
    }
    
    @IBAction func playAgain(_ sender: UIButton) {
        board = [" ", " ", " ", " ", " ", " ", " ", " ", " "]
        gameActive = true
        iCount = 0
        elements = 0
        playAgainbtn.isHidden = true
        if (playerActive == false){
            statelbl.text = "\(player2Name)'s turn"
        }else{
            statelbl.text = "\(player1Name)'s turn"
        }
        for i in 1...9{
            let button = view.viewWithTag(i) as! UIButton
            button.setImage(nil, for: UIControlState())
        }
    }
    
    @IBAction func action(_ sender: UIButton) {
        if(gameActive == true){
                if (board[sender.tag-1] == " "){
                    if (playerActive == true){
                        sender.setImage(UIImage(named: themeSelected + playerAs), for: UIControlState())
                        board[sender.tag-1] = playerAs
                        playerActive = false
                        statelbl.text = "\(player2Name)'s turn"
                    }else{
                        sender.setImage(UIImage(named: themeSelected + aiAs), for: UIControlState())
                        board[sender.tag-1] = aiAs
                        playerActive = true
                        statelbl.text = "\(player1Name)'s turn"
                    }
                }
                winner = checkWinner()
                switch winner{
                case playerAs?:
                    iPlayer1Count+=1
                    Player1Scorelbl.text = "\(iPlayer1Count)"
                    statelbl.text = "\(player1Name) won!"
                case aiAs?:
                    iPlayer2Count+=1
                    Player2Scorelbl.text = "\(iPlayer2Count)"
                    statelbl.text = "\(player2Name) won!"
                case "Draw"?:
                    iDrawCount+=1
                    drawScorelbl.text = "\(iDrawCount)"
                    statelbl.text = "Draw"
                default:
                    break
                }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        boardHash.image = UIImage(named: "\(themeSelected)#")
        statelbl.text = "\(player1Name)'s turn"
        player1Namelbl.text = player1Name
        player2Namelbl.text = player2Name
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
