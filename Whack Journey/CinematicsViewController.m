//
//  CinematicsViewController.m
//  Tap Tope
//
//  Created by Jordana Mecler on 09/02/15.
//  Copyright (c) 2015 Jordana Mecler. All rights reserved.
//

#import "CinematicsViewController.h"
#import "FourthViewController.h"

@interface CinematicsViewController ()
@property (nonatomic, strong) MPMoviePlayerController *player;
@property NSMutableArray *scores;
@property NSMutableArray *nomes;
@property NSMutableDictionary *dict;
@property NSMutableArray *settings;

@end

@implementation CinematicsViewController

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *path = [documentsDirectory stringByAppendingPathComponent:@"RankingList.plist"];
    
    // Load the file content and read the data into arrays
    self.dict = [[NSMutableDictionary alloc] initWithContentsOfFile:path];
    self.scores = [NSMutableArray array];
    self.nomes = [NSMutableArray array];
    self.settings = [NSMutableArray array];
    
    if(!self.dict)
    {
        self.dict = [[NSMutableDictionary alloc] init];
    }
    else
    {
        self.settings = [NSMutableArray arrayWithArray:[self.dict objectForKey:@"settings"]];
    }
    
    [self.settings replaceObjectAtIndex:0 withObject:@"1"];
    [self.dict setObject:self.settings forKey:@"settings"];
    [self.dict writeToFile:path atomically:YES];
    
    self.view.backgroundColor = [UIColor whiteColor];
    NSBundle *bundle = [NSBundle mainBundle];
    NSString *moviePath = [bundle pathForResource:@"Cine1" ofType:@"mov"];
    NSURL *movieURL = [NSURL fileURLWithPath:moviePath];
    self.player = [[MPMoviePlayerController alloc] initWithContentURL:movieURL];
    self.player.view.frame = self.view.frame;
    self.player.view.center = self.view.center;
    self.player.fullscreen = NO;
    self.player.controlStyle = MPMovieControlStyleDefault;
    self.player.shouldAutoplay = YES;
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(moviePlayBackDidFinish:)
                                                 name:MPMoviePlayerPlaybackDidFinishNotification
                                               object:self.player];
    [self.player prepareToPlay];
    self.player.movieSourceType = MPMovieSourceTypeFile;
    [self.view addSubview:self.player.view];
    
    
    [self.player play];
}

- (void) moviePlayBackDidFinish:(NSNotification*)notification {
    
    MPMoviePlayerController *player = [notification object];
    [[NSNotificationCenter defaultCenter]
     removeObserver:self
     name:MPMoviePlayerPlaybackDidFinishNotification
     object:player];
    
    FourthViewController *fvc = [[FourthViewController alloc] init];
    fvc.tope = self.tope;
    fvc.audioPlayer = self.audioPlayer;
    fvc.difficulty = self.difficulty;
    self.player.fullscreen = NO;
    [self.player.view removeFromSuperview];
    [self presentViewController:fvc animated:NO completion:nil];
}


@end
