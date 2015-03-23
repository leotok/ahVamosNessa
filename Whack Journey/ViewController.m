
#import "ViewController.h"
#import "ThirdViewController.h"
#import "SettingsViewController.h"
#import "RankingViewController.h"

@interface ViewController ()
@property (strong,nonatomic) UIImageView *YourImageView;
@property (strong,nonatomic) AVAudioPlayer *topeEffects;
@property UIImageView *faceShifter;
@property (nonatomic,strong) AVAudioPlayer *buttonSound;

@end

@implementation ViewController

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (!self.backgroundMusic)
    {
        NSURL *musicFile = [[NSBundle mainBundle] URLForResource:@"Main_Menu" withExtension:@"mp3"];
        self.backgroundMusic = [[AVAudioPlayer alloc] initWithContentsOfURL:musicFile error:nil];
        self.backgroundMusic.numberOfLoops = -1;
        [self.backgroundMusic play];
    }
    
    //    NSURL *musicFile2 = [[NSBundle mainBundle] URLForResource:@"IrSettings" withExtension:@"wav"];
    //    self.buttonSound = [[AVAudioPlayer alloc] initWithContentsOfURL:musicFile2 error:nil];
    //    self.buttonSound.delegate = self;
    //    self.buttonSound.numberOfLoops = 1;
    //    self.buttonSound.volume = 1;
    
}

- (void)viewDidAppear:(BOOL)animated
{
    
    // imagens
    
    UIImageView *background = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"background2.png"]];
    background.frame = self.view.frame;
    
    self.faceShifter = [[UIImageView alloc] initWithFrame:CGRectMake((self.view.frame.size.width/2)/3.1, self.view.frame.size.height/3.8, self.view.frame.size.width/1.48, self.view.frame.size.height/2.24)];
    
    if(self.tope.image)
    {
        self.faceShifter.image = self.tope.image;
    }
    else
    {
        [self.faceShifter setImage:[UIImage imageNamed:@"faceshifter.png"]];
    }
    
    [self.faceShifter setUserInteractionEnabled:YES];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(top)];
    tap.numberOfTapsRequired = 1;
    [self.faceShifter addGestureRecognizer:tap];
    
    UIImageView *nome = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.frame.size.width/32, self.view.frame.size.height/24, self.view.frame.size.width/1.065, self.view.frame.size.height/5.65)];
    [nome setImage:[UIImage imageNamed:@"nome2.png"]];
    
    
    
    // botões
    
    UIButton *jogar = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width/8, self.view.frame.size.height/1.385, self.view.frame.size.width/1.28, self.view.frame.size.height/7.1)];
    [jogar setImage:[UIImage imageNamed:@"play2.png"] forState:UIControlStateNormal];
    [jogar addTarget:self action:@selector(jogar:) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIButton *settings = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2.13, 1.7*self.view.center.y, self.view.frame.size.width/2.29, self.view.frame.size.height/9.5)];
    [settings setImage:[UIImage imageNamed:@"settings2.png"] forState:UIControlStateNormal];
    [settings addTarget:self action:@selector(settings:) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIButton *ranking = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width/8, 1.73*self.view.center.y, self.view.frame.size.width/2.29, self.view.frame.size.height/9.5)];
    [ranking setImage:[UIImage imageNamed:@"ranking2.png"] forState:UIControlStateNormal];
    [ranking addTarget:self action:@selector(ranking:) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    // adiciona tudo na view
    
    [self.view addSubview:background];
    [self.view addSubview:self.faceShifter];
    [self.view addSubview:nome];
    [self.view addSubview:jogar];
    [self.view addSubview:settings];
    [self.view addSubview:ranking];
    
}


// quando toca na toupeira

-(void)top
{
    NSURL *musicFile2 = [[NSBundle mainBundle] URLForResource:@"DieFaceShifter" withExtension:@"wav"];
    self.topeEffects = [[AVAudioPlayer alloc] initWithContentsOfURL:musicFile2 error:nil];
    self.topeEffects.delegate = self;
    self.topeEffects.numberOfLoops = 1;
    self.backgroundMusic.volume = 0.1;
    [self.topeEffects play];
}

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    if(player == self.topeEffects && flag == TRUE)
    {
        self.backgroundMusic.volume = 1;
    }
}

// botao de ranking
-(void)ranking:(id)sender
{
    //[self.buttonSound play];
    RankingViewController *rvc = [[RankingViewController alloc] init];
    [self presentViewController:rvc animated:NO completion:nil];
}

// botao play
- (void)jogar:(id)sender {
    [self.buttonSound play];
    ThirdViewController *tvc = [[ThirdViewController alloc] init];
    tvc.tope = self.tope;
    tvc.audioPlayer = self.audioPlayer;
    tvc.backgroundMusic = self.backgroundMusic;
    [self presentViewController:tvc animated:NO completion:nil];
}

// botao settings
-(void)settings:(id)sender{
    
    //[self.buttonSound play];
    SettingsViewController *setvc = [[SettingsViewController alloc] init];
    setvc.audioPlayer = self.audioPlayer;
    setvc.imageView = self.tope;
    [self.backgroundMusic stop];
    [self presentViewController:setvc animated:NO completion:nil];
}

@end