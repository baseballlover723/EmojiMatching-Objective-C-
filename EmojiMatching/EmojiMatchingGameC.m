//
//  EmojiMatchingGameC.m
//  EmojiMatching
//
//  Created by Philip Ross on 1/29/15.
//  Copyright (c) 2015 CSSE Department. All rights reserved.
//

#import "EmojiMatchingGameC.h"

@implementation Emoji

-(id) init:(NSString *)name solved:(BOOL)solved shown:(BOOL)shown{
    self = [super init];
    if (self) {
        self.name = name;
        self.solved = solved;
        self.shown = shown;
    }
    return self;
}
-(id) init:(Emoji*) emoji {
    self = [super init];
    if (self) {
        self.name = emoji.name;
        self.solved = emoji.solved;
        self.shown = emoji.shown;
    }
    return self;
}

@end

@implementation EmojiMatchingGameC
-(id) init: (NSInteger) numbOfPairs {
    self = [super init];
    if (self) {
        NSArray* allCardBacks = [@"🎆,🎇,🌈,🌅,🌇,🌉,🌃,🌄,⛺,⛲,🚢,🌌,🌋,🗽" componentsSeparatedByString: @","];
        NSArray* allEmojiCharacters = [@"🚁,🐴,🐇,🐢,🐱,🐌,🐒,🐞,🐫,🐠,🐬,🐩,🐶,🐰,🐼,⛄,🌸,⛅,🐸,🐳,❄,❤,🐝,🌺,🌼,🌽,🍌,🍎,🍡,🏡,🌻,🍉,🍒,🍦,👠,🐧,👛,🐛,🐘,🐨,😃,🐻,🐹,🐲,🐊,🐙" componentsSeparatedByString: @","];
        NSMutableArray* emojiSymbolsUsed = [[NSMutableArray alloc] init];
        NSMutableArray* indexList = [[NSMutableArray alloc] init];
        while (emojiSymbolsUsed.count < numbOfPairs) {
            NSInteger randNumb = arc4random_uniform(numbOfPairs);
            NSString* symbol = allEmojiCharacters[randNumb];
            Emoji* emoji = [[Emoji alloc] init:symbol solved:NO shown:NO];
            // check which indexs i've selected
            if (![indexList containsObject:[NSNumber numberWithInteger:randNumb]]) {
                [emojiSymbolsUsed addObject:emoji];
                [indexList addObject:[NSNumber numberWithInteger:randNumb]];
            }
        }
        int length = emojiSymbolsUsed.count;
        // make a copy of each object to add the list
        for (int k=0; k<length;k++) {
            [emojiSymbolsUsed addObject:[[Emoji alloc] init:[emojiSymbolsUsed objectAtIndex:k]]];
        }
//        [emojiSymbolsUsed addObjectsFromArray:emojiSymbolsUsed];
        //shuffle
        for (int i =0; i<emojiSymbolsUsed.count; i++) {
            UInt32 j = arc4random_uniform(emojiSymbolsUsed.count - i) + i;
            [emojiSymbolsUsed exchangeObjectAtIndex:i withObjectAtIndex:j];
        }
        self.cards = [NSArray arrayWithArray:emojiSymbolsUsed];
        self.cardBack = allCardBacks[arc4random_uniform(allCardBacks.count)];
        self.syncronized = YES;
        
    }
    return self;
}
-(Emoji*) getEmojiAt: (NSInteger) index {
    return [self.cards objectAtIndex:index];
}
-(NSString*) getString {
    NSMutableString* str = [[NSMutableString alloc] init];
    for (int k=0; k<self.cards.count;) {
        for (int i=0; i<4;i++) {
            Emoji* emoji= [self.cards objectAtIndex:k];
            [str appendString:emoji.name];
            k++;
        }
        [str appendString:@"\n"];
    }
    return [NSString stringWithString:str];
}


-(NSString*) outputTitle {
    if (self.firstPick != nil) {
        return @"Please select another card";
    } else {
        return @"Please select a card";
    }
    
}

-(NSString*) getCardBack {
    return self.cardBack;
}

-(BOOL) pickCard: (int) index {
    if (!self.syncronized) {
        // fixes syncronization issues
        return NO;
    }
    Emoji* emoji =[self.cards objectAtIndex:index];
    if (emoji.solved) {
        // picked a solved card
        return NO;
    }
    if (self.firstPick != nil) {
        // second pick
        Emoji* pick = [self.cards objectAtIndex:index];
        if (self.firstPick == pick) {
            // picked the same card twice don't do anything
            return NO;
        }
        if (self.firstPick.name == pick.name) {
            pick.shown = true;
            self.syncronized = NO;
            [self performSelector:@selector(delayMatch:) withObject:pick afterDelay:1.2];
            return YES;
        } else {
            // picked 2 different cards and they don't match
            pick.shown = YES;
            self.syncronized = NO;
            //            SEL selector = NSSelectorFromString(@")
            [self performSelector:@selector(delayNoMatch:) withObject:pick afterDelay:1.2];
            return YES;
        }
    } else {
        // first pick
        self.firstPick = [self.cards objectAtIndex:index];
        self.firstPick.shown = YES;
        return NO;
    }
    return NO;
}
-(void) delayMatch: (Emoji*) pick {
    self.firstPick.solved = YES;
    pick.solved = YES;
    self.firstPick = nil;
    self.syncronized = YES;
}
-(void) delayNoMatch:(Emoji *) pick {
    self.firstPick.shown = NO;
    pick.shown = NO;
    self.firstPick = nil;
    self.syncronized = YES;
}

@end
