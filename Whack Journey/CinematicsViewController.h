//
//  CinematicsViewController.h
//  Tap Tope
//
//  Created by Jordana Mecler on 09/02/15.
//  Copyright (c) 2015 Jordana Mecler. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
@import MediaPlayer;

@interface CinematicsViewController : UIViewController
@property int difficulty;
@property (strong,nonatomic) UIImageView *tope;
@property (strong,nonatomic) AVAudioPlayer *audioPlayer;

@end
