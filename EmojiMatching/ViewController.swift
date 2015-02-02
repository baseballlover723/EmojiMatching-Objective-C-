//
//  ViewController.swift
//  EmojiMatching
//
//  Created by CSSE Department on 1/11/15.
//  Copyright (c) 2015 CSSE Department. All rights reserved.
//

import UIKit
class ViewController: UIViewController {

    @IBOutlet weak var ipadNavBar: UINavigationBar!
    
    @IBOutlet var buttons: [UIButton]!
    
    
    
    var game = EmojiMatchingGameC(10)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        updateview()
        // sets font size to 64 for iphones and 100 for ipads
        var buttonSize = UIDevice.currentDevice().userInterfaceIdiom == .Phone ? 64 : 100
        for button in buttons {
            var font = button.titleLabel?.font.fontWithSize(CGFloat(buttonSize))
            button.titleLabel?.font = font
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func pressedButton(sender: AnyObject) {
        var button = sender as UIButton
        var needAgain = game.pickCard((Int32)(button.tag))
        println("pressed button #\(button.tag): \(game.cards[button.tag].name)")
        updateview()
        // I know this is ugly, but I kinda ran short on time
        println(game.getString());
        if needAgain {
            delay(1.2) {
                self.updateview()
            }
        }
        
    }
    
    
    @IBAction func pressedNewGame(sender: AnyObject) {
        println("pressed new game")
        game = EmojiMatchingGameC(10)
        updateview()
        println(game.getString());
    }
    
    func updateview() {
        var index = 0
        for button in buttons {
            var emoji = game.getEmojiAt(index)
            var text = emoji.solved ? "" : (emoji.shown ? emoji.name : game.getCardBack())
            button.setTitle(text, forState: UIControlState.Normal)
            index++
        }
    }

    func delay(delay:Double, closure:()->()) {
        dispatch_after(
            dispatch_time(
                DISPATCH_TIME_NOW,
                Int64(delay * Double(NSEC_PER_SEC))
            ),
            dispatch_get_main_queue(), closure)
    }
}

