#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface SettingsViewController : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate, AVAudioRecorderDelegate, AVAudioPlayerDelegate, UINavigationControllerDelegate>

@property (strong,nonatomic) UIImageView *imageView;
@property (strong,nonatomic) AVAudioRecorder *audioRecorder;
@property (strong,nonatomic) AVAudioPlayer *audioPlayer;

-(void)recordAudio;
-(void)playAudio;

@end

