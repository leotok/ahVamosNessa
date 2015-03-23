

#import <UIKit/UIKit.h>
#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>

@interface RankingViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (strong,nonatomic) AVAudioPlayer *audioPlayer;

@end
