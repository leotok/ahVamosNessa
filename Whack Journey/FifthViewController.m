
#import "FifthViewController.h"
#import "FourthViewController.h"
#import "ThirdViewController.h"
#import "RankingViewController.h"
#import "ViewController.h"
#import "Fase2ViewController.h"

@interface FifthViewController ()
@property (strong, nonatomic) AVAudioPlayer *backgroundMusic;
@property (strong, nonatomic) UIImageView *scoreBox;
@property NSMutableDictionary *dict;
@property NSMutableArray *settings;


@end

@implementation FifthViewController
{
    int scoreToWin;
}

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
    self.settings = [NSMutableArray array];
    
    self.settings = [NSMutableArray arrayWithArray:[self.dict objectForKey:@"settings"]];
    
    scoreToWin = 800;
    if(self.acertos >= scoreToWin)
    {
        [self.settings replaceObjectAtIndex:1 withObject:@"1"];
        [self.dict setObject:self.settings forKey:@"settings"];
        [self.dict writeToFile:path atomically:YES];
    }
    
    

    
    
    // música
    
    NSURL *musicFile = [[NSBundle mainBundle] URLForResource:@"Victorious" withExtension:@"mp3"];
    self.backgroundMusic = [[AVAudioPlayer alloc] initWithContentsOfURL:musicFile error:nil];
    self.backgroundMusic.numberOfLoops = -1;
    [self.backgroundMusic play];
    
    // imagens e labels
    
    
    UILabel *aviso = [[UILabel alloc] init];
    [aviso setText:[NSString stringWithFormat:@"%d",self.acertos]];
    [aviso setFont:[UIFont fontWithName:@"MarkerFelt-Thin" size:25.0]];
    aviso.textAlignment = NSTextAlignmentCenter;
    
    
    UIImage *imgBackground = [[UIImage alloc] init];
    if(self.winOrLose == YES)
    {
        aviso.frame = CGRectMake(self.view.frame.size.width/1.55, self.view.frame.size.height/2.57, self.view.frame.size.width/2.667, self.view.frame.size.height/11.36);
        imgBackground = [UIImage imageNamed:@"Victorious_BG.png"];
    }
    else
    {
        aviso.frame = CGRectMake(self.view.frame.size.width/1.67, self.view.frame.size.height/3.4, self.view.frame.size.width/2.667, self.view.frame.size.height/11.36);
        imgBackground = [UIImage imageNamed:@"Defeated_BG.png"];
        self.scoreBox = [[UIImageView alloc] initWithImage:[UIImage imageNamed: @"Defeated_Score.png"]];
        self.scoreBox.frame = CGRectMake(self.view.frame.size.width/1.777, self.view.frame.size.height/5, 222/1.5, 211/1.5);
    }
    
    UIImageView *background = [[UIImageView alloc] initWithImage:imgBackground];
    background.frame = self.view.frame;
    [self.view addSubview:background];
    [self.view addSubview:self.scoreBox];
    
    
    // botões
    
    UIButton *jogarNovamente = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2, self.view.frame.size.height/1.17, self.view.frame.size.width/2.176, self.view.frame.size.height/8.477)];
    [jogarNovamente setImage:[UIImage imageNamed:@"Victorious_PlayAgainB.png"] forState:UIControlStateNormal];
    [jogarNovamente addTarget:self action:@selector(jogarNovamente:) forControlEvents:UIControlEventTouchUpInside];
    
    /*UIButton *mudarDificuldade = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width/4, self.view.center.y, self.view.frame.size.width/2, self.view.frame.size.height/11.36)];
     mudarDificuldade.layer.cornerRadius = 10;
     [mudarDificuldade setTitle:@"Change difificulty" forState:UIControlStateNormal];
     mudarDificuldade.backgroundColor = [UIColor colorWithRed:139/255.0 green:136/255.0 blue:120/255.0 alpha:1.0];
     [mudarDificuldade addTarget:self action:@selector(mudarDificuldade:) forControlEvents:UIControlEventTouchUpInside];
     
     
     UIButton *ranking = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2.91, self.view.frame.size.height/1.479, self.view.frame.size.width/3.2, self.view.frame.size.height/11.36)];
     ranking.layer.cornerRadius = 10;
     [ranking setTitle:@"Ranking" forState:UIControlStateNormal];
     ranking.backgroundColor = [UIColor colorWithRed:139/255.0 green:136/255.0 blue:120/255.0 alpha:1.0];
     [ranking addTarget:self action:@selector(ranking:) forControlEvents:UIControlEventTouchUpInside];*/
    
    UIButton *inicio = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width/16, self.view.frame.size.height/1.17, self.view.frame.size.width/2.176, self.view.frame.size.height/8.477)];
    [inicio setImage:[UIImage imageNamed:@"Victorious_MenuB.png"] forState:UIControlStateNormal];
    [inicio addTarget:self action:@selector(inicio:) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    // adiciona tudo na view
    
    [self.view addSubview:aviso];
    [self.view addSubview:jogarNovamente];
    [self.view addSubview:inicio];
    
}


// botão pro ranking
/*
 -(void)ranking:(id)sender
 {
 RankingViewController *rvc = [[RankingViewController alloc]init];
 rvc.audioPlayer = self.audioPlayer;
 [self presentViewController:rvc animated:NO completion:nil];
 }
 */
// botão pra tela de início

-(void)inicio:(id)sender
{
    ViewController *vc = [[ViewController alloc]init];
    vc.audioPlayer = self.audioPlayer;
    vc.tope = self.tope;
    vc.audioPlayer = self.audioPlayer;
    [self.backgroundMusic stop];
    [self presentViewController:vc animated:NO completion:nil];
}

// botão para jogar novamente

- (void)jogarNovamente:(id)sender {
    if(self.dificuldade)
    {
        Fase2ViewController *fvc = [[Fase2ViewController alloc] init];
        fvc.difficulty = self.dificuldade;
        fvc.tope = self.tope;
        fvc.audioPlayer = self.audioPlayer;
        [self.backgroundMusic stop];
        [self presentViewController:fvc animated:NO completion:nil];
    }
    else
    {
        FourthViewController *fvc = [[FourthViewController alloc] init];
        fvc.difficulty = self.dificuldade;
        fvc.tope = self.tope;
        fvc.audioPlayer = self.audioPlayer;
        [self.backgroundMusic stop];
        [self presentViewController:fvc animated:NO completion:nil];
    }
}

// botão para mudar a dificuldade
/*
 - (void)mudarDificuldade:(id)sender {
 ThirdViewController *tvc = [[ThirdViewController alloc] init];
 tvc.tope = self.tope;
 tvc.audioPlayer = self.audioPlayer;
 [self.backgroundMusic stop];
 [self presentViewController:tvc animated:NO completion:nil];
 }
 */
@end