
#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>

@interface ViewController : UIViewController <AVAudioPlayerDelegate>

@property (strong,nonatomic) UIImageView *tope;
@property AVAudioPlayer *backgroundMusic;
@property (strong,nonatomic) AVAudioPlayer *audioPlayer;

@end

