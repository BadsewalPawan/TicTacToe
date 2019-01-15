//
//  SelectionPageViewController.swift
//  TicTacToe
//
//  Created by Pawan Badsewal on 01/02/18.
//  Copyright © 2018 Pawan Badsewal. All rights reserved.
//

import UIKit
import AVFoundation

var themeSelected:String = "Chalk"
var firstTimeLoaded:Bool = true
var playerAs:String = "X"
var aiAs:String = "O"
var player1Name:String = "Player 1"
var player2Name:String = "Player 2"
var selectedThemeRowComponent:Int = 0

class SelectionPageViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate {
    
    var proAi:Bool? = false
    var AudioPlayer: AVAudioPlayer!
    var playerTime:Double!
    let themes = ["Chalk","Wooden","Neon"]
    
    @IBOutlet var beginnerBtn: UIButton!
    @IBOutlet var proBtn: UIButton!
    @IBOutlet var aiBtn: UIButton!
    @IBOutlet var friendBtn: UIButton!
    @IBOutlet var themePicker: UIPickerView!
    @IBOutlet var themePreview: UIImageView!
    @IBOutlet var friendlyPlayBtn: UIButton!
    @IBOutlet var beginneraiPlayBtn: UIButton!
    @IBOutlet var proaiPlayBtn: UIButton!
    @IBOutlet var segment: UISegmentedControl!
    @IBOutlet var player1NameTextField: UITextField!
    @IBOutlet var player2NameTextField: UITextField!
    @IBAction func unwindToSelectionVC(_ sender: UIStoryboardSegue) {}
    
    func playAudio(){
        let path = Bundle.main.path(forResource: "BackgroundMusic" , ofType: "mp3")!
        let url = URL(fileURLWithPath: path)
        do{
            AudioPlayer = try AVAudioPlayer(contentsOf: url)
            AudioPlayer.prepareToPlay()
        }
        catch let error as NSError{
            print(error.description)
        }
        AudioPlayer.numberOfLoops = -1
        AudioPlayer.play()
    }
    
    @IBAction func selection(_ sender: UIButton) {
        friendlyPlayBtn.isHidden = true
        beginneraiPlayBtn.isHidden = true
        proaiPlayBtn.isHidden = true
        player2NameTextField.isHidden = true
        switch sender.tag {
        case 1:
            friendBtn.isSelected = false
            aiBtn.isSelected = true
            beginnerBtn.isHidden = false
            proBtn.isHidden = false
        case 2:
            beginnerBtn.isHidden = true
            proBtn.isHidden = true
            aiBtn.isSelected = false
            beginnerBtn.isSelected = false
            proBtn.isSelected = false
            friendBtn.isSelected = true
            friendlyPlayBtn.isHidden = false
            player2NameTextField.isHidden = false
        case 3:
            proAi = false
            proBtn.isSelected = false
            beginnerBtn.isSelected = true
            beginneraiPlayBtn.isHidden = false
        case 4:
            beginnerBtn.isSelected = false
            proAi = true
            proBtn.isSelected = true
            proaiPlayBtn.isHidden = false
        default:
            break
        }
    }
    
    @IBAction func selectedSegment(_ sender: UISegmentedControl) {
        switch segment.selectedSegmentIndex{
        case 0:
            playerAs = "X"
            aiAs = "O"
        case 1:
            playerAs = "O"
            aiAs = "X"
        default:
            break
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        player1Name = player1NameTextField.text!
        player2Name = player2NameTextField.text!
        player1NameTextField.resignFirstResponder()
        player2NameTextField.resignFirstResponder()
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if (player1NameTextField.text != ""){
            player1Name = player1NameTextField.text!
        }
        if (player2NameTextField.text != ""){
            player2Name = player2NameTextField.text!
        }
        self.view.endEditing(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        themePreview.frame.size.width = themePreview.frame.size.height
        if (firstTimeLoaded == true){
            playAudio()
            firstTimeLoaded = false
        }else{
            player1NameTextField.text = player1Name
            player2NameTextField.text = player2Name
        }
        if (playerAs == "X"){
            segment.selectedSegmentIndex = 0
        }else{
            segment.selectedSegmentIndex = 1
        }
        player1NameTextField.delegate = self
        player2NameTextField.delegate = self
        themePreview.image = UIImage(named: "\(themeSelected)XO")
        themePicker.delegate = self
        themePicker.dataSource = self
        themePicker.selectedRow(inComponent: selectedThemeRowComponent)
    }
    
    
    public func numberOfComponents(in pickerView: UIPickerView) -> Int{
        return 1
    }
    
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
        return themes.count
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        return NSAttributedString(string:themes[row],attributes: [NSAttributedString.Key.foregroundColor:UIColor.white])
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        themePreview.image = UIImage(named:"\(themes[row])XO")
        themeSelected = themes[row]
        selectedThemeRowComponent = row
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
