//
//  ViewController.swift
//  tapper-extreme
//
//  Created by Joshua Rodriguez on 4/22/16.
//  Copyright © 2016 devslopes. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    /* * * * * * * * * * * * * * * * * */
    /*                                 */
    /*            Properties           */
    /*                                 */
    /* * * * * * * * * * * * * * * * * */
    
    var maxTaps = 0;
    var currentTaps = 0;
    
    /* * * * * * * * * * * * * * * * * */
    /*                                 */
    /*              Outlets            */
    /*                                 */
    /* * * * * * * * * * * * * * * * * */
    
    @IBOutlet weak var logoImg: UIImageView!
    @IBOutlet weak var howManyTapsTxt: UITextField!
    @IBOutlet weak var playBtn: UIButton!
    
    @IBOutlet weak var tapBtn: UIButton!
    @IBOutlet weak var tapsLbl: UILabel!
    
    /* * * * * * * * * * * * * * * * * */
    /*                                 */
    /*              Actions            */
    /*                                 */
    /* * * * * * * * * * * * * * * * * */
    
    @IBAction func onCoinTapped(sender: UIButton!) {
        currentTaps = currentTaps + 1
        updateTapsLbl()
        
        if isGameOver() {
            restartGame()
        }
    }
    
    @IBAction func onPlayButtonPressed(sender: UIButton) {
        if howManyTapsTxt.text != nil && howManyTapsTxt.text != "" {
            
            hideAssets(true)
            
            maxTaps = Int(howManyTapsTxt.text!)!;
            currentTaps = 0
            
            updateTapsLbl()
        }
    }
    
    @IBAction func closeKeyboard(sender: AnyObject) {
        howManyTapsTxt.resignFirstResponder()
    }
    
    /* * * * * * * * * * * * * * * * * */
    /*                                 */
    /*             Functions           */
    /*                                 */
    /* * * * * * * * * * * * * * * * * */
    
    func hideAssets(hide: Bool) {
        logoImg.hidden = hide
        playBtn.hidden = hide
        howManyTapsTxt.hidden = hide
        
        tapBtn.hidden = !hide
        tapsLbl.hidden = !hide
    }
    
    func restartGame() {
        maxTaps = 0;
        howManyTapsTxt.text = ""
        hideAssets(false)
    }
    
    func isGameOver() -> Bool {
        if currentTaps >= maxTaps {
            return true
        } else {
            return false
        }
    }
    
    func updateTapsLbl() {
        tapsLbl.text = "\(currentTaps) Taps"
    }
}

