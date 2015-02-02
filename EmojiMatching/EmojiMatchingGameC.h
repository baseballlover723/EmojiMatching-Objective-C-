//
//  EmojiMatchingGameC.h
//  EmojiMatching
//
//  Created by Philip Ross on 1/29/15.
//  Copyright (c) 2015 CSSE Department. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Emoji : NSObject
@property (nonatomic) NSString* name;
@property (nonatomic) BOOL solved;
@property (nonatomic) BOOL shown;
-(id) init: (NSString*) name solved: (BOOL) solved shown: (BOOL) shown;
-(id) init:(Emoji*) emoji;
@end

@interface EmojiMatchingGameC : NSObject

-(id) init: (NSInteger) numbOfPairs;
-(NSString*) outputTitle;
-(NSString*) getCardBack;
-(BOOL) pickCard: (int) index;
-(void) delayMatch: (Emoji*) pick;
-(void) delayNoMatch: (Emoji*) pick;
-(Emoji*) getEmojiAt: (NSInteger) index;
-(NSString*) getString;

@property (nonatomic) NSArray* cards;
@property (nonatomic) Emoji* firstPick;
@property (nonatomic) BOOL syncronized;
@property (nonatomic) NSString* cardBack;

@end
