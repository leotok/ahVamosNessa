

#import <UIKit/UIKit.h>
#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>

@interface Fase2ViewController : UIViewController <UITextFieldDelegate>
@property int difficulty;
@property (strong,nonatomic) UIImageView *tope;
@property (strong,nonatomic) AVAudioPlayer *audioPlayer;

@end