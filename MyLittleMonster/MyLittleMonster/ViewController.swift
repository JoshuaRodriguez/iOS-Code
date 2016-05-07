//
//  ViewController.swift
//  MyLittleMonster
//
//  Created by Joshua Rodriguez on 5/3/16.
//  Copyright © 2016 devslopes. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    
    @IBOutlet weak var monsterImg: MonsterImage!
    @IBOutlet weak var foodImg: DragImage!
    @IBOutlet weak var heartImg: DragImage!
    @IBOutlet weak var penaltyImg1: UIImageView!
    @IBOutlet weak var penaltyImg2: UIImageView!
    @IBOutlet weak var penaltyImg3: UIImageView!
    @IBOutlet weak var playAgainBtn: UIButton!

    let DIM_ALPHA: CGFloat = 0.2
    let OPAQUE: CGFloat = 1.0
    let MAX_PENALTIES = 3
    
    var musicPlayer: AVAudioPlayer!
    var sfxBite: AVAudioPlayer!
    var sfxHeart: AVAudioPlayer!
    var sfxDeath: AVAudioPlayer!
    var sfxSkull: AVAudioPlayer!
    
    var penalties = 0
    var timer: NSTimer!
    var monsterHappy = false
    var currentItem = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ViewController.itemDroppedOnCharacter(_:)), name: "onTargetDropped", object: nil)
        
        getSoundsReady()
        startGame()
    }
    
    @IBAction func playAgain(sender: AnyObject) {
        penalties = 0
        musicPlayer.currentTime = 0
        startGame()
        monsterImg.playIdleAnimation()
    }
    
    func itemDroppedOnCharacter(notif: AnyObject) {
        if(currentItem == 0) {
            sfxHeart.play()
        } else {
            sfxBite.play()
        }
        
        monsterHappy = true
        startTimer()
        
        foodImg.alpha = DIM_ALPHA
        foodImg.userInteractionEnabled = false
        
        heartImg.alpha = DIM_ALPHA
        heartImg.userInteractionEnabled = false
    }
    
    func startTimer() {
        if timer != nil {
            timer.invalidate()
        }
        
        timer = NSTimer.scheduledTimerWithTimeInterval(3.0, target: self, selector: #selector(ViewController.changeGameState), userInfo: nil, repeats: true)
    }
    
    func changeGameState() {
        if !monsterHappy {
            sfxSkull.play()
            
            penalties += 1
            
            if penalties == 1 {
                penaltyImg1.alpha = OPAQUE
                penaltyImg2.alpha = DIM_ALPHA
            } else if penalties == 2 {
                penaltyImg2.alpha = OPAQUE
                penaltyImg3.alpha = DIM_ALPHA
            } else if penalties >= 3 {
                penaltyImg3.alpha = OPAQUE
                gameOver()
            } else {
                penaltyImg1.alpha = DIM_ALPHA
                penaltyImg2.alpha = DIM_ALPHA
                penaltyImg3.alpha = DIM_ALPHA
            }
        }
        
        let rand = arc4random_uniform(2)
        
        if rand == 0 {
            foodImg.alpha = DIM_ALPHA
            foodImg.userInteractionEnabled = false
            
            heartImg.alpha = OPAQUE
            heartImg.userInteractionEnabled = true
        } else {
            foodImg.alpha = OPAQUE
            foodImg.userInteractionEnabled = true
            
            heartImg.alpha = DIM_ALPHA
            heartImg.userInteractionEnabled = false
        }
        
        currentItem = Int(rand)
        monsterHappy = false
    }
    
    func gameOver() {
        timer.invalidate()
        stopSound("bgMusic")
        playSound("death")
        monsterImg.playDeathAnimation()
        playAgainBtn.hidden = false
        playAgainBtn.userInteractionEnabled = true
    }
    
    func stopSound(soundName: String) {
        switch soundName {
            case "bgMusic":
                musicPlayer.stop()
            case "bite":
                sfxBite.stop()
            case "heart":
                sfxHeart.stop()
            case "death":
                sfxDeath.stop()
            case "skull":
                sfxSkull.stop()
            default:
                 print("Sound not found!")
        }
    }
    
    func playSound(soundName: String) {
        switch soundName {
            case "bgMusic":
                musicPlayer.play()
                musicPlayer.numberOfLoops = -1
            case "bite":
                sfxBite.play()
            case "heart":
                sfxHeart.play()
            case "death":
                sfxDeath.play()
            case "skull":
                sfxSkull.play()
            default:
                print("Sound not found!")
        }
    }
    
    func getSoundsReady() {
        do {
            let bgMusicUrl = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("bgMusic", ofType: "mp3")!)
            let sfxBiteUrl = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("bite", ofType: "wav")!)
            let sfxHeartUrl = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("heart", ofType: "wav")!)
            let sfxDeathUrl = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("death", ofType: "wav")!)
            let sfxSkullUrl = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("skull", ofType: "wav")!)
            
            try musicPlayer = AVAudioPlayer(contentsOfURL: bgMusicUrl)
            try sfxBite = AVAudioPlayer(contentsOfURL: sfxBiteUrl)
            try sfxHeart = AVAudioPlayer(contentsOfURL: sfxHeartUrl)
            try sfxDeath = AVAudioPlayer(contentsOfURL: sfxDeathUrl)
            try sfxSkull = AVAudioPlayer(contentsOfURL: sfxSkullUrl)
            
            musicPlayer.prepareToPlay()
            sfxBite.prepareToPlay()
            sfxHeart.prepareToPlay()
            sfxDeath.prepareToPlay()
            sfxSkull.prepareToPlay()
            
        } catch let err as NSError {
            print(err.description)
        }
    }
    
    func startGame() {
        playAgainBtn.userInteractionEnabled = false
        playAgainBtn.hidden = true
        
        playSound("bgMusic")
        
        foodImg.dropTarget = monsterImg
        heartImg.dropTarget = monsterImg
        
        penaltyImg1.alpha = DIM_ALPHA
        penaltyImg2.alpha = DIM_ALPHA
        penaltyImg3.alpha = DIM_ALPHA
        
        startTimer()
    }
}


