#import "SettingsViewController.h"
#import "ViewController.h"
#import "ThirdViewController.h"


@interface SettingsViewController ()

@property (nonatomic) UIButton *botaoCamera;
@property (nonatomic) UIButton *botaoImagem;
@property (nonatomic) UIButton *botaoMicrophone;
@property (nonatomic) UIButton *botaoPlay;
@property (nonatomic) UIButton *botaoVoltar;
@property (nonatomic) UIImageView *tope;
@property (strong,nonatomic) AVAudioPlayer *backgroundMusic;
@property int displayTimer;
@property NSTimer *myTimer;
@property UIImageView *display;
@property UIImageView *tempoDisplay;
@property UIImageView *camera;
@property UIImagePickerController *picker;

@end

@implementation SettingsViewController

@synthesize audioPlayer;
@synthesize audioRecorder;
@synthesize botaoMicrophone;
@synthesize botaoCamera;
@synthesize botaoPlay;
@synthesize botaoVoltar;
@synthesize botaoImagem;

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.displayTimer = 0;
    // som do background
    
    NSURL *musicFile = [[NSBundle mainBundle] URLForResource:@"Main_Menu" withExtension:@"mp3"];
    self.backgroundMusic = [[AVAudioPlayer alloc] initWithContentsOfURL:musicFile error:nil];
    //self.backgroundMusic.volume = 1;
    self.backgroundMusic.numberOfLoops = -1;
    [self.backgroundMusic play];
    
    // imagem e label
    
    UIImageView *background = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"settingsBackground.png"]];
    background.frame = self.view.frame;
    
    UIImageView *tube = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [tube setImage:[UIImage imageNamed:@"Settings_TubeB.png"]];
    
    
    self.display = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.frame.size.width/1.523, self.view.frame.size.height/1.16, self.view.frame.size.width/5.818, self.view.frame.size.height/10.327)];
    [self.display setImage:[UIImage imageNamed:@"Settings_Display.png"]];
    
    self.tope = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0,  self.view.frame.size.width/1.48, self.view.frame.size.height/2.254)];
    self.tope.center = self.view.center;
    self.tope.image = [UIImage imageNamed:@"faceshifter_no_face.png"];
    
    self.imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width/1.48, self.view.frame.size.height/2.254)];
    self.imageView.center = CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height/2);
    
    
    // botões
    
    //[botaoCamera setSelected:YES];
    
    
    self.camera = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2.875, self.view.frame.size.height/3.33, self.view.frame.size.width/3.368, self.view.frame.size.height/4.76)];
    self.camera.animationImages = [NSArray arrayWithObjects:[UIImage imageNamed:@"Faceshifter_BlankFace.png"],[UIImage imageNamed:@"Faceshifter_GlowFace.png"], nil];
    self.camera.animationDuration = 1;
    self.camera.animationRepeatCount = -1;
    [self.camera startAnimating];
    self.camera.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(takePhoto:)];
    tap.numberOfTapsRequired = 1;
    [self.camera addGestureRecognizer:tap];
    
    
    //botaoCamera = [[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.size.width/2.875, self.view.frame.size.height/3.33, self.view.frame.size.width/3.368, self.view.frame.size.height/4.76)];
    //[botaoCamera setImage:[UIImage imageNamed:@"Faceshifter_BlankFace.png"] forState:UIControlStateNormal];
    //[botaoCamera setImage:[UIImage imageNamed:@"Faceshifter_GlowFace.png"] forState:UIControlStateSelected | UIControlStateHighlighted];
    //[botaoCamera addTarget:self action:@selector(takePhoto:) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    botaoMicrophone = [[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.size.width/2.415, self.view.frame.size.height/1.147, self.view.frame.size.width/5.818, self.view.frame.size.height/10.327)];
    [botaoMicrophone setImage:[UIImage imageNamed:@"Settings_RecB.png"] forState:UIControlStateNormal];
    [botaoMicrophone addTarget:self action:@selector(recordAudio) forControlEvents:UIControlEventTouchUpInside];
    
    botaoPlay = [[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.size.width/5.565, self.view.frame.size.height/1.16, self.view.frame.size.width/5.818, self.view.frame.size.height/10.327)];
    [botaoPlay setImage:[UIImage imageNamed:@"Settings_PlayRecB.png"] forState:UIControlStateNormal];
    [botaoPlay addTarget:self action:@selector(playAudio) forControlEvents:UIControlEventTouchUpInside];
    botaoPlay.enabled = NO;
    
    botaoVoltar = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width/32, self.view.frame.size.height/56.8, self.view.frame.size.width/10.667, self.view.frame.size.height/18.933)];
    [botaoVoltar setImage:[UIImage imageNamed:@"Settings_BackB.png"] forState:UIControlStateNormal];
    [botaoVoltar addTarget:self action:@selector(playAction) forControlEvents:UIControlEventTouchUpInside];
    
    
    // adiciona tudo a view
    
    [self.view addSubview:background];
    [self.view addSubview:tube];
    //  [self.view addSubview:titulo];
    //[self.view addSubview:botaoCamera];
    [self.view addSubview:botaoMicrophone];
    [self.view addSubview:botaoPlay];
    [self.view addSubview:self.imageView];
    [self.view addSubview:self.tope];
    //[self.view addSubview:noFace];
    [self.view addSubview:botaoVoltar];
    [self.view addSubview:self.display];
    [self.view addSubview:self.camera];
    //[self.view addSubview:botaoImagem];
    
    // código do audio recorder
    
    NSArray *dirPaths;
    NSString *docsDir;
    
    dirPaths = NSSearchPathForDirectoriesInDomains(
                                                   NSDocumentDirectory, NSUserDomainMask, YES);
    docsDir = [dirPaths objectAtIndex:0];
    NSString *soundFilePath = [docsDir
                               stringByAppendingPathComponent:@"sound.caf"];
    
    NSURL *soundFileURL = [NSURL fileURLWithPath:soundFilePath];
    
    NSDictionary *recordSettings = [NSDictionary
                                    dictionaryWithObjectsAndKeys:
                                    [NSNumber numberWithInt:AVAudioQualityMin],
                                    AVEncoderAudioQualityKey,
                                    [NSNumber numberWithInt:16],
                                    AVEncoderBitRateKey,
                                    [NSNumber numberWithInt: 2],
                                    AVNumberOfChannelsKey,
                                    [NSNumber numberWithFloat:44100.0],
                                    AVSampleRateKey,
                                    nil];
    
    NSError *error = nil;
    
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    [audioSession setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
    
   //[audioSession setActive:YES error:nil];
    
//    UInt32 audioRouteOverride = kAudioSessionOverrideAudioRoute_Speaker;
//    AudioSessionSetProperty(kAudioSessionProperty_OverrideAudioRoute,               // trecho de código que resolveu problema do som
//                            sizeof(audioRouteOverride), &audioRouteOverride);
    
    NSError *setCategoryError = nil;
    if (![audioSession setCategory:AVAudioSessionCategoryPlayback
                  withOptions:AVAudioSessionCategoryOptionMixWithOthers
                        error:&setCategoryError]) {
        // handle error
    }
    
    audioRecorder = [[AVAudioRecorder alloc]
                     initWithURL:soundFileURL
                     settings:recordSettings
                     error:&error];
    audioRecorder.delegate = self;
    
    if (error)
    {
        NSLog(@"error: %@", [error localizedDescription]);
        
    } else {
        [audioRecorder prepareToRecord];
    }
    //fim do audio recorder
    
}



// botão começa o jogo

-(void) playAction
{
    ViewController *vc = [[ViewController alloc] init];
    vc.tope = self.imageView;
    vc.audioPlayer = self.audioPlayer;
    [self.backgroundMusic stop];
    
    [self presentViewController:vc animated:NO completion:nil];
}

-(void) tempo
{
    [self.botaoMicrophone setEnabled:NO];
    if(self.displayTimer > 0)
        [self.tempoDisplay removeFromSuperview];
    self.displayTimer++;
    self.tempoDisplay = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width/16, self.view.frame.size.height/28.4)];
    self.tempoDisplay.center = CGPointMake(self.display.center.x, self.display.center.y-1.5);
    [self.tempoDisplay setImage:[UIImage imageNamed:[NSString stringWithFormat:@"Settings_N%d",-self.displayTimer+4]]];
    [self.view addSubview:self.tempoDisplay];
    
    if(self.displayTimer > 3)
    {
        NSLog(@"Recording");
        self.backgroundMusic.volume = 0;
        [self.myTimer invalidate];
        if (!audioRecorder.recording)
        {
            if(![audioRecorder recordForDuration:0.8])
                NSLog(@"Fail to record audio");
            
        }
        else
            NSLog(@"Fail to record audio.");
    }
}

-(void) recordAudio
{
    botaoPlay.enabled = NO;
    botaoMicrophone.enabled = NO;
    self.myTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(tempo) userInfo:nil repeats:YES];
    
}

-(void) playAudio
{
    NSLog(@"Playing");
    
    
    if (!audioRecorder.recording)
    {
        NSError *error;
        
        audioPlayer = [[AVAudioPlayer alloc]
                       initWithContentsOfURL:audioRecorder.url
                       error:&error];
        
        audioPlayer.delegate = self;
        
        if (error)
            NSLog(@"Error: %@",
                  [error localizedDescription]);
        else
        {
            self.backgroundMusic.volume = 0.1;
            [audioPlayer play];
            audioPlayer.volume = 1;
        }
    }
}

-(void)audioPlayerDidFinishPlaying:
(AVAudioPlayer *)player successfully:(BOOL)flag
{
    botaoMicrophone.enabled = YES;
    self.backgroundMusic.volume = 1;
}

-(void)audioPlayerDecodeErrorDidOccur:
(AVAudioPlayer *)player
                                error:(NSError *)error
{
    NSLog(@"Decode Error occurred");
}

-(void)audioRecorderDidFinishRecording:
(AVAudioRecorder *)recorder
                          successfully:(BOOL)flag
{
    self.displayTimer = 0;
    [self.tempoDisplay removeFromSuperview];
    botaoPlay.enabled = YES;
    botaoMicrophone.enabled = YES;
    self.backgroundMusic.volume = 1;
}

-(void)audioRecorderEncodeErrorDidOccur:
(AVAudioRecorder *)recorder
                                  error:(NSError *)error
{
    NSLog(@"Encode Error occurred");
}

- (void)takePhoto:(UIButton *)sender {
    
    self.picker = [[UIImagePickerController alloc] init];
    self.picker.delegate = self;
    self.picker.allowsEditing = YES;
    self.picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    self.picker.showsCameraControls = YES;
    UIImageView *toupeira = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width/1.48, self.view.frame.size.height/2.254)];
    toupeira.center = CGPointMake(self.view.center.x -10, self.view.center.y);
    toupeira.image = [UIImage imageNamed:@"faceshifter_no_face.png"];
    UIGestureRecognizer *takePicButton = [[UIGestureRecognizer alloc]initWithTarget:self action:@selector(overlayTakePic)];
    [toupeira addGestureRecognizer:takePicButton];
    self.picker.cameraOverlayView = toupeira;
    
    [self presentViewController:self.picker animated:YES completion:NULL];
}

- (void) overlayTakePic
{
    [self.picker takePicture];
}


- (UIImage*) maskImage:(UIImage *)image withMask:(UIImage *)maskImage {
    
    CGImageRef maskRef = maskImage.CGImage;
    
    CGImageRef mask = CGImageMaskCreate(CGImageGetWidth(maskRef),
                                        CGImageGetHeight(maskRef),
                                        CGImageGetBitsPerComponent(maskRef),
                                        CGImageGetBitsPerPixel(maskRef),
                                        CGImageGetBytesPerRow(maskRef),
                                        CGImageGetDataProvider(maskRef), NULL, TRUE);
    
    CGImageRef masked = CGImageCreateWithMask([image CGImage], mask);
    return [UIImage imageWithCGImage:masked];
    
}

- (UIImage*)mergeImage:(UIImage*)first withImage:(UIImage*)second
{
    // get size of the first image
    CGImageRef firstImageRef = first.CGImage;
    CGFloat firstWidth = CGImageGetWidth(firstImageRef);
    CGFloat firstHeight = CGImageGetHeight(firstImageRef);
    
    // get size of the second image
    //CGImageRef secondImageRef = second.CGImage;
    //CGFloat secondWidth = CGImageGetWidth(secondImageRef);
    //CGFloat secondHeight = CGImageGetHeight(secondImageRef);
    
    // build merged size
    CGSize mergedSize = CGSizeMake(self.view.frame.size.width/1.48, self.view.frame.size.height/2.254);
    
    // capture image context ref
    UIGraphicsBeginImageContext(mergedSize);
    
    //[second drawInRect:CGRectMake(firstWidth, 0, secondWidth, secondHeight)];
    [second drawInRect:CGRectMake(0,0,self.view.frame.size.width/1.48, self.view.frame.size.height/2.254)];  // second é o rosto!!
    
    //Draw images onto the context
    [first drawInRect:CGRectMake(-(self.view.frame.size.width/6.8), -(self.view.frame.size.height/7.573), self.view.frame.size.width/0.9697, self.view.frame.size.height/1.775)];
    NSLog(@"%f%f",firstWidth,firstHeight);
    
    // assign context to new UIImage
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // end context
    UIGraphicsEndImageContext();
    
    return newImage;
    
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    [self.tope removeFromSuperview];
    
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
    UIImage *maskedImage = [self maskImage:chosenImage withMask:[UIImage imageNamed:@"blackface.png"]];
    
    UIImage *mergedImage = [self mergeImage:maskedImage withImage:[UIImage imageNamed:@"faceshifter_no_face.png"]];
    self.imageView.image = mergedImage;
    
    [self.camera stopAnimating];
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}

-(void) getPhoto:(id) sender {
    
    UIImagePickerController * picker = [[UIImagePickerController alloc] init];
    
    // Don't forget to add UIImagePickerControllerDelegate in your .h
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    
    
    [self presentViewController:picker animated:YES completion:nil];
}

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if ( [navigationController.viewControllers count] == 2 ) {
        UIImageView *toupeira = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width/1.48, self.view.frame.size.height/2.254)];
        toupeira.image = [UIImage imageNamed:@"faceshifter_no_face.png"];
        
        [viewController.view addSubview:toupeira];
        
        [UIView beginAnimations:@"animateTableView" context:nil];
        [UIView setAnimationDuration:0];
        [toupeira setFrame:CGRectMake(self.view.frame.size.width/8.666, self.view.frame.size.height/3.993, self.view.frame.size.width/1.48, self.view.frame.size.height/2.254)];
        [UIView commitAnimations];
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end