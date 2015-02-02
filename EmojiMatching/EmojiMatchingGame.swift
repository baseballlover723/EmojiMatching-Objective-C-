// Playground - noun: a place where people can play

import UIKit
import Foundation

// Here are the card backs and emoji symbols you shoud use.
let allCardBacks = Array("🎆🎇🌈🌅🌇🌉🌃🌄⛺⛲🚢🌌🌋🗽")
var allEmojiCharacters = Array("🚁🐴🐇🐢🐱🐌🐒🐞🐫🐠🐬🐩🐶🐰🐼⛄🌸⛅🐸🐳❄❤🐝🌺🌼🌽🍌🍎🍡🏡🌻🍉🍒🍦👠🐧👛🐛🐘🐨😃🐻🐹🐲🐊🐙")


class EmojiMatchingGame : Printable {
    var cards : [Emoji]
    var firstPick : Emoji?
    var cardBack : Character
    var syncronized : Bool
    
    init(numbOfPairs: Int) {
        self.syncronized = true
        self.cards = [Emoji]()
        for k in Range(0..<numbOfPairs) {
            "hellpo"
            var numbOfEmoji = allEmojiCharacters.count
            var index = Int(arc4random_uniform(UInt32(numbOfEmoji)))
            var randEmoji = allEmojiCharacters[index]
            allEmojiCharacters.removeAtIndex(index)
            self.cards.append(Emoji(name: randEmoji))
            self.cards.append(Emoji(name: randEmoji))
        }
        self.cards.shuffle()
        
        var numbOfCardBacks = allCardBacks.count
        self.cardBack = allCardBacks[Int(arc4random_uniform(UInt32(numbOfCardBacks)))]
        
    }
    var description : String {
        var returnString = ""
        for emoji in self.cards {
            returnString += emoji.description
        }
        return returnString
    }
    
    func outputTitle() -> String {
        if (firstPick != nil) {
            return "Please select another card"
        }
        return "Please select a card"
    }
    
    func getCardBack() -> Character {
        return self.cardBack
    }
    
    func pickCard(index: Int) -> Bool{
        if (!syncronized) {
            // solves syncryonization issues
            return false
        }
        if cards[index].solved {
            // you picked a solved card
            return false
        }
        if ((firstPick) != nil) {
            // second pick
            var pick = cards[index]
            if (firstPick === pick) {
                // if you clicked the same one
                // don't do anything
                return false
            }
            if firstPick?.name == pick.name {
                // different cards, but a match
                pick.shown = true
                self.syncronized = false
                delay(1.2) {
                    self.firstPick?.solved = true
                    pick.solved = true
                    self.firstPick = nil
                    self.syncronized = true
                }
                
                return true
                
            } else {
                // you picked 2 different cards but they don't match
                pick.shown = true
                self.syncronized = false;
                delay(1.2) {
                    self.firstPick?.shown = false
                    pick.shown = false
                    // reset the first pick
                    self.firstPick = nil
                    self.syncronized = true
                }
                return true
            }
        } else {
            // this is the first pick
            firstPick = cards[index]
            firstPick?.shown = true
            return false;
        }
    }
}

class Emoji : Printable {
    var name : Character
    var solved : Bool
    var shown : Bool
    
    init(name: Character) {
        self.name = name
        self.solved = false
        self.shown = false
    }
    
    var description : String {
        return String(self.name) + " is "  + (self.shown ? "shown" : " not shown") + " and is " + (self.solved ? "solved" : "not solved")
    }
}

/* ------ Code snippet #1 --------- */
// Helper method to randomize the order of an Array. See usage later.  Copied from:
// http://stackoverflow.com/questions/24026510/how-do-i-shuffle-an-array-in-swift
extension Array {
    mutating func shuffle() {
        for i in 0..<(count - 1) {
            let j = Int(arc4random_uniform(UInt32(count - i))) + i
            swap(&self[i], &self[j])
        }
    }
}

/* ------ Code snippet #2 --------- */
// Helper method to create a time delay. Copied from:
// http://stackoverflow.com/questions/24034544/dispatch-after-gcd-in-swift/24318861#24318861
// See answer with most votes for usage examples (VERY easy) delay(1.2) { ... }
// Copy this snippet to your ViewController file (not realy useful in the model).
// This is *one* way to solve the 1.2 second delay requirement.
func delay(delay:Double, closure:()->()) {
    dispatch_after(
        dispatch_time(
            DISPATCH_TIME_NOW,
            Int64(delay * Double(NSEC_PER_SEC))
        ),
        dispatch_get_main_queue(), closure)
}

/* ------ Code snippet #3 --------- */
// Examples of getting random cards from the emoji symbol array (could go into init)
//var cards : [Character]
//var cardBack : Character
//
//// Randomly select emojiSymbols
//var emojiSymbolsUsed = [Character]()
//while emojiSymbolsUsed.count < 4 {
//    var index = Int(arc4random_uniform(UInt32(allEmojiCharacters.count)))
//    var symbol = allEmojiCharacters[index]
//    if !contains(emojiSymbolsUsed, symbol) {
//        emojiSymbolsUsed.append(symbol)
//    }
//}
//cards = emojiSymbolsUsed + emojiSymbolsUsed
//cards.shuffle()
//
//// Randomly select a card back for this round
//var index = Int(arc4random_uniform(UInt32(allCardBacks.count)))
//cardBack = allCardBacks[index]


// ------------------------------------------------
//  Completely optional test code if you choose to
//  use a Playground to develop the model object.
// ------------------------------------------------

////// Real game to see random values
//var game = EmojiMatchingGame(numbOfPairs: 10)
//game.description
//game.cards
//game.cards[0]
////game.cardStates
////game.cardStates[0].rawValue
////game.cardBack
////game.gameState.simpleDescription()
////game.description
////
////// Playing with non-random cards (better for testing)
//var array = Array(arrayLiteral: Emoji(name: "0"), Emoji(name: "1"), Emoji(name: "2"), Emoji(name: "3"), Emoji(name: "4"), Emoji(name: "5"), Emoji(name: "6"), Emoji(name: "7"), Emoji(name: "8"), Emoji(name: "9"), Emoji(name: "0"), Emoji(name: "1"), Emoji(name: "2"), Emoji(name: "3"), Emoji(name: "4"), Emoji(name: "5"), Emoji(name: "6"), Emoji(name: "7"), Emoji(name: "8"), Emoji(name: "9"))
//game.cards = array
////
////// Making a match
//game.cards[2]
//game.cards[12]
////game.cardStates[2].rawValue
////game.cardStates[12].rawValue
////game.gameState.simpleDescription()
//game.pickCard(2)
//game.cards[2]
////game.cardStates[12].rawValue
////game.gameState.simpleDescription()
//game.pickCard(12)
//game.cards[2]
//game.cards[12]
////game.gameState.simpleDescription()
////game.startNewTurn()
////game.cardStates[2].rawValue
////game.cardStates[12].rawValue
////game.gameState.simpleDescription()
////
////// Non-match
//game.cards[1]
//game.cards[15]
//game.firstPick
//game.pickCard(1)
//game.cards[1]
//game.firstPick
//
//game.pickCard(15)
//game.cards[1]
//game.cards[15]
////game.cardStates[1].rawValue
////game.cardStates[15].rawValue
////game.gameState.simpleDescription()
////game.pressedCard(atIndex: 1)
////game.cardStates[1].rawValue
////game.cardStates[15].rawValue
////game.gameState.simpleDescription()
////game.pressedCard(atIndex: 15)
////game.cardStates[1].rawValue
////game.cardStates[15].rawValue
////game.gameState.simpleDescription()
////game.startNewTurn()
////game.cardStates[1].rawValue
////game.cardStates[15].rawValue
////game.gameState.simpleDescription()
