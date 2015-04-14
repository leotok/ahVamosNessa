
#import "ThirdViewController.h"
#import "FourthViewController.h"
#import "ViewController.h"
#import "CinematicsViewController.h"
#import "Fase2ViewController.h"
#import "Fase3ViewController.h"

@interface ThirdViewController ()

@property NSMutableArray *scores;
@property NSMutableArray *nomes;
@property NSMutableDictionary *dict;
@property NSMutableArray *settings;

@end

@implementation ThirdViewController

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    
    // carregar plist
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *path = [documentsDirectory stringByAppendingPathComponent:@"RankingList.plist"];
    
    // Load the file content and read the data into arrays
    self.dict = [[NSMutableDictionary alloc] initWithContentsOfFile:path];
    self.settings = [NSMutableArray array];
    
    if(!self.dict)
        self.dict = [[NSMutableDictionary alloc] init];
    else
        self.settings = [NSMutableArray arrayWithArray:[self.dict objectForKey:@"settings"]];
    
    /* conserta crash do play*/
    if ([self.settings count] < 3)
    {
        if ([self.settings count] != 0)
        {
            [self.settings removeAllObjects];
        }
        [self.settings addObject:@"0"];   // 0 - primeira vez / 1 - ja viu cinematics
        [self.settings addObject:@"1"]; // 0 - nao liberou 2a fase / 1 - liberou
        [self.settings addObject:@"1"]; // 0 - nao liberou 3a fase / 1 - liberou
    }
    
    // imagens e labels
    
    if (!self.backgroundMusic)
    {
        NSURL *musicFile = [[NSBundle mainBundle] URLForResource:@"Main_Menu" withExtension:@"mp3"];
        self.backgroundMusic = [[AVAudioPlayer alloc] initWithContentsOfURL:musicFile error:nil];
        self.backgroundMusic.numberOfLoops = -1;
        [self.backgroundMusic play];
    }
    
    UIImageView *background = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Levels_BG.png"]];
    background.frame = self.view.frame;
    
    

    
    
    // botões
    
    UIButton *facil = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width/10.666, self.view.frame.size.height/3.463, self.view.frame.size.width/1.231, self.view.frame.size.height/5.68)];
    facil.tag = 0;
    [facil setImage:[UIImage imageNamed:@"Levels_FaseEdooine.png"] forState:UIControlStateNormal];
    [facil addTarget:self action:@selector(prox:) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    UIButton *medio = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width/10.666, self.view.frame.size.height/1.93, self.view.frame.size.width/1.231, self.view.frame.size.height/5.68)];
    medio.tag = 1;
    [medio addTarget:self action:@selector(prox:) forControlEvents:UIControlEventTouchUpInside];
    
    if([[self.settings objectAtIndex:1] integerValue] == 1)
    {
        [medio setImage:[UIImage imageNamed:@"Levels_Fase2Open_Button.png"] forState:UIControlStateNormal];
        medio.enabled = YES;
    }
    else
    {
        medio.enabled = NO;
        [medio setImage:[UIImage imageNamed:@"SlotLocked2.png"] forState:UIControlStateNormal];
    }
    
    UIButton *dificil = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width/10.666, self.view.frame.size.height/1.34, self.view.frame.size.width/1.231, self.view.frame.size.height/5.68)];
    dificil.tag = 2;
    [dificil addTarget:self action:@selector(prox:) forControlEvents:UIControlEventTouchUpInside];
    
    if([[self.settings objectAtIndex:2] integerValue] == 1)
    {
        [dificil setImage:[UIImage imageNamed:@"Levels_Fase3Open_Button.png"] forState:UIControlStateNormal];
        dificil.enabled = YES;
    }
    else
    {
        dificil.enabled = NO;
        [dificil setImage:[UIImage imageNamed:@"SlotLocked3.png"] forState:UIControlStateNormal];
    }    
    
    
    UIButton *back = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width/32, self.view.frame.size.height/56.8, self.view.frame.size.width/10.667, self.view.frame.size.height/18.933)];
    [back addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    // adiciona tudo a view
    
    [self.view addSubview:background];
    [self.view addSubview:facil];
    [self.view addSubview:medio];
    [self.view addSubview:dificil];
    [self.view addSubview:back];
    
}

// ação que leva para o jogo

- (void)prox:(UIButton *)sender {
    
    if ([[self.settings objectAtIndex:0] integerValue] == 0)
    {
       // [self.settings replaceObjectAtIndex:0 withObject:@"1"];
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString *path = [documentsDirectory stringByAppendingPathComponent:@"RankingList.plist"];

        [self.dict setObject:self.settings forKey:@"settings"];
        
        [self.dict writeToFile:path atomically:YES];
        
        CinematicsViewController *cvc = [[CinematicsViewController alloc] init];
        cvc.difficulty = (int)sender.tag;
        cvc.tope = self.tope;
        cvc.audioPlayer = self.audioPlayer;
        [self.backgroundMusic stop];
        
        [self presentViewController:cvc animated:NO completion:nil];
    }
    else if ([[self.settings objectAtIndex:0] integerValue] == 1)
    {
        if(sender.tag == 0)
        {
            FourthViewController *fvc = [[FourthViewController alloc] init];
            fvc.difficulty =  (int)sender.tag;
            fvc.tope = self.tope;
            fvc.audioPlayer = self.audioPlayer;
            [self.backgroundMusic stop];
            [self presentViewController:fvc animated:NO completion:nil];
        }
        else if(sender.tag == 1)
        {
            Fase2ViewController *fvc = [[Fase2ViewController alloc] init];
            fvc.difficulty =  (int)sender.tag;
            fvc.tope = self.tope;
            fvc.audioPlayer = self.audioPlayer;
            [self.backgroundMusic stop];
            [self presentViewController:fvc animated:NO completion:nil];
        }
        else
        {
            Fase3ViewController *fvc = [[Fase3ViewController alloc]init];
            fvc.difficulty =  (int)sender.tag;
            fvc.tope = self.tope;
            fvc.audioPlayer = self.audioPlayer;
            [self.backgroundMusic stop];
            [self presentViewController:fvc animated:NO completion:nil];
        }
    }
}


// volta para a tela anterior

- (void)back:(id)sender {
    ViewController *vc = [[ViewController alloc] init];
    vc.audioPlayer = self.audioPlayer;
    vc.tope = self.tope;
    vc.backgroundMusic = self.backgroundMusic;
    [self presentViewController:vc animated:NO completion:nil];
}


@end