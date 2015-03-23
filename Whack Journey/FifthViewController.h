

#import <UIKit/UIKit.h>
#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>

@interface FifthViewController : UIViewController <UITextFieldDelegate>
@property int acertos;
@property int dificuldade;
@property (strong,nonatomic) UIImageView *tope;
@property (strong,nonatomic) AVAudioPlayer *audioPlayer;
@property BOOL winOrLose;

@end
