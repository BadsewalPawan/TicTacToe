//
//  TapWarActionVC.swift
//  TicTacToe!
//
//  Created by Pawan Badsewal on 10/02/19.
//  Copyright © 2019 Pawan Badsewal. All rights reserved.
//

import UIKit

extension Double {
    
    /// Returns a random floating point number between 0.0 and 1.0, inclusive.
    public static var random: Double {
        return Double(arc4random()) / 0xFFFFFFFF
    }
    
    /// Random double between 0 and n-1.
    ///
    /// - Parameter n:  Interval max
    /// - Returns:      Returns a random double point number between 0 and n max
    public static func random(min: Double, max: Double) -> Double {
        return Double.random * (max - min) + min
    }
}

extension Array where Element: Equatable {
    func indexes(of element: Element) -> [Int] {
        return self.enumerated().filter({ element == $0.element }).map({ $0.offset })
    }
}

class TapWarActionVC: UIViewController {

    var iPhoneFontSize:CGFloat = 30
    var iPadFontSize:CGFloat = 40
    var fontToUse:CGFloat!
    var timer:Timer = Timer()
    var numberOfRounds:Int!
    var roundTime:Double!
    var transitionTime:Double!
    var timeSpent:Double! = 0
    var playerBtns = [UIButton]()
    var gameActive:Bool = false
    var playerScores:Array<Int> = [0]
    var winningScore:Int!
    
    @IBOutlet var player1Btn: UIButton!
    @IBOutlet var player2Btn: UIButton!
    @IBOutlet var player3Btn: UIButton!
    @IBOutlet var player4Btn: UIButton!
    @IBOutlet var timerlbl: UILabel!
    @IBOutlet var backgroundView: UIView!
    
    
    func setBtnTitle(targetPlayer:Int){
        let targetWord = "Tap Here"
        let btnString = "Player \(targetPlayer + 1) \n Tap Here \n \n \n Score \(playerScores[targetPlayer])"
        let targetWordRange = (btnString as NSString).range(of: targetWord)
        let attributedString = NSMutableAttributedString(string: btnString, attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: fontToUse - 10)])
        attributedString.setAttributes([NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: fontToUse)], range: targetWordRange)
        playerBtns[targetPlayer].titleLabel?.numberOfLines = 0
        playerBtns[targetPlayer].setAttributedTitle(attributedString, for: .normal)
        playerBtns[targetPlayer].titleLabel?.textAlignment = .center
    }
    
    func reset(){
        timeSpent = 0
        timerlbl.textColor = .black
        backgroundView.backgroundColor = .white
        gameActive = true
        for btn in playerBtns{
            btn.backgroundColor = .clear
        }
    }
    
    func generateTime(){
        roundTime = Double(arc4random_uniform(5)) + 6  // num btwn 6-10
        repeat {
            transitionTime = round(Double.random(min: 2.0, max: 8.0) * 100) / 100
        }while !(roundTime - transitionTime >= 2)
    }
    
    func checkWinner(score1:Int, score2:Int, titleToSet:String){
        if (score1 < score2){
            timerlbl.text = titleToSet
            winningScore = score2
        }else if (winningScore == score2){
            timerlbl.text = "Draw!"
            winningScore = score2
        }
    }
    
    @objc func timerAction(){
        timeSpent += 0.01
        timerlbl.text = String(round((roundTime - timeSpent) * 100) / 100)
    }
    
    @objc func startNextRound(){
        reset()
        generateTime()
        timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(timerAction), userInfo: nil, repeats: true)
        UIView.animate(withDuration: transitionTime, delay: 0, options: UIView.AnimationOptions.allowUserInteraction, animations: {
            self.backgroundView.backgroundColor = .black
        }, completion: nil)
        
    }
    
    @objc func goToSelectionVC(){
        performSegue(withIdentifier: "tapWarActionUnwindSegue", sender: Any?.self)
    }
    
    @objc func animateWinner(){
        let whoWon = playerScores.indexes(of: playerScores.max()!)
        if (whoWon.count == 1){
            timerlbl.text = "Player \(whoWon[0]+1) Won!"
        }else{
            timerlbl.text = "Draw"
        }
        timerlbl.transform = CGAffineTransform(scaleX: 0.6, y: 0.6)
        UIView.animate(withDuration: 2.0, delay: 0, usingSpringWithDamping: CGFloat(0.20), initialSpringVelocity: CGFloat(6.0), options: UIView.AnimationOptions.curveEaseIn, animations: {
            self.timerlbl.transform = CGAffineTransform.identity
        }, completion: { _ in()  }
        )
        timer = Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(goToSelectionVC), userInfo: nil, repeats: false)
    }
    
    
    
    @IBAction func playerBtnAction(_ sender: UIButton) {
        if(gameActive){
            gameActive = false
            timerlbl.textColor = .white
            timer.invalidate()
            for btn in playerBtns{
                if (btn.tag == sender.tag){
                    if (round((roundTime - timeSpent) * 100) / 100 > 0){
                        btn.backgroundColor = UIColor(red: 190/255, green: 55/255, blue: 41/255, alpha: 1)
                        playerScores[sender.tag] -= 1
                        setBtnTitle(targetPlayer: sender.tag)
                    }else{
                        btn.backgroundColor = UIColor(red: 88/255, green: 187/255, blue: 92/255, alpha: 1)
                        playerScores[sender.tag] += 1
                        setBtnTitle(targetPlayer: sender.tag)
                    }
                }
            }
            if(numberOfRounds > 0){
                timer = Timer.scheduledTimer(timeInterval: 1.3, target: self, selector: #selector(startNextRound), userInfo: nil, repeats: false)
                numberOfRounds -= 1
            }else{
                //compare score
                timer = Timer.scheduledTimer(timeInterval: 1.3, target: self, selector: #selector(animateWinner), userInfo: nil, repeats: false)
            }
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        player1Btn.transform = CGAffineTransform(rotationAngle: .pi)
        player3Btn.transform = CGAffineTransform(rotationAngle: .pi)
        playerBtns = [player1Btn, player2Btn, player3Btn, player4Btn]
        for _ in 0...tapWarGameMode{
            playerScores.append(0)}
        if (UIDevice.current.userInterfaceIdiom == .phone){
            fontToUse = iPhoneFontSize
        }else{
            fontToUse = iPadFontSize
        }
        if (tapWarNumberOfRounds == 0){
            numberOfRounds = 3
        }else if (tapWarNumberOfRounds == 1){
            numberOfRounds = 5
        }else if (tapWarNumberOfRounds == 2){
            numberOfRounds = 7
        }else{
            numberOfRounds = 10
        }
        timer = Timer.scheduledTimer(timeInterval: 1.3, target: self, selector: #selector(startNextRound), userInfo: nil, repeats: false)
            numberOfRounds -= 1
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        for i in (0...tapWarGameMode+1){
            setBtnTitle(targetPlayer: i)
        }
        if (tapWarGameMode == 0){
            player1Btn.frame.size.width = UIScreen.main.bounds.width - 32
            player2Btn.frame.size.width = UIScreen.main.bounds.width - 32
            player3Btn.isHidden = true
            player4Btn.isHidden = true
        }else if (tapWarGameMode == 1){
            player2Btn.frame.size.width = UIScreen.main.bounds.width - 32
            player4Btn.isHidden = true
        }
            
    }

}
