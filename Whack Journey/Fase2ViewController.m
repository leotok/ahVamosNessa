
#import "Fase2ViewController.h"

#import "FifthViewController.h"
#import "ThirdViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "SettingsViewController.h"

#define PLAYTAG 0
#define PAUSETAG 1

@interface Fase2ViewController ()

@property CGFloat translacao;
@property int edCount;
@property int edAcertou;
@property int contador;
@property int faceShifterAcertou;
@property int faceShifterCount;
@property int vidas;
@property int scoreToWin;
@property int marteloCount;

@property (strong,nonatomic) AVAudioPlayer *backgroundMusic;
@property (strong,nonatomic) NSArray *array;
@property NSMutableArray *scores;
@property NSMutableArray *nomes;
@property NSMutableDictionary *dict;
@property UITextField *highscoreName;
@property (strong,nonatomic) UILabel *label;

@property NSTimer *removeEdTimer;
@property NSTimer *removeFaceShifterTimer;
@property NSTimer *nave;
@property NSTimer *edTimer;
@property (strong,nonatomic) NSTimer *myTimer;

@property NSTimeInterval edTempo;
@property NSTimeInterval faceShifterTempo;

@property UIVisualEffectView *visualEffectView;
@property UIImageView *imagem;
@property UIImageView *popUp;
@property UIImageView *edImage;
@property UIImageView *martelo;
@property UIImageView *edHead1;
@property UIImageView *edHead2;
@property UIImageView *edHead3;
@property UIImageView *spaceship;
@property (strong, nonatomic) UIImageView *faceShifterImage;
@property (strong, nonatomic) UIImageView *faceShifterActualImage;

@property UIButton *play_pause;
@property UIButton *save;
@property UIButton *joga;
@property UIButton *restart;
@property UIButton *levels;

@end

@implementation Fase2ViewController

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self.backgroundMusic stop];
    
    // música do background
    
    NSURL *musicFile = [[NSBundle mainBundle] URLForResource:@"Level_1" withExtension:@"mp3"];
    self.backgroundMusic = [[AVAudioPlayer alloc] initWithContentsOfURL:musicFile error:nil];
    self.backgroundMusic.numberOfLoops = -1;
    self.backgroundMusic.volume = 0.5;
    [self.backgroundMusic play];
    
    // imagens e labels
    
    UIImageView *background = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Level_2_Background.png"]];
    background.frame = self.view.frame;
    
    self.label = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width/5.333, 0, self.view.frame.size.width/1.6, self.view.frame.size.height/9.467)];
    [self.label setFont:[UIFont fontWithName:@"MarkerFelt-Thin" size:30.0]];
    [self.label setText:[NSString stringWithFormat:@"+%d",self.contador]];
    self.label.textAlignment = NSTextAlignmentCenter;
    self.label.textColor = [UIColor whiteColor];
    self.label.backgroundColor = [UIColor clearColor];
    
    self.edHead1 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Level_1_EdHead.png"]];
    self.edHead1.frame = CGRectMake(self.view.frame.size.width/106.667, self.view.frame.size.height/37.867, self.view.frame.size.width/10.667, self.view.frame.size.height/18.933);
    
    self.edHead2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Level_1_EdHead.png"]];
    self.edHead2.frame = CGRectMake(self.view.frame.size.width/9.697, self.view.frame.size.height/37.867, self.view.frame.size.width/10.667, self.view.frame.size.height/18.933);
    
    self.edHead3 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Level_1_EdHead.png"]];
    self.edHead3.frame = CGRectMake(self.view.frame.size.width/5.079, self.view.frame.size.height/37.867, self.view.frame.size.width/10.667, self.view.frame.size.height/18.933);
    
   // self.spaceship = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Level_1_BackShip.png"]];
    
    // botões
    
    self.play_pause = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width/1.23, self.view.frame.size.height/37.867, self.view.frame.size.width/10.667, self.view.frame.size.height/18.933)];
    [self.play_pause setImage:[UIImage imageNamed:@"Level_1_PauseB.png"] forState:UIControlStateNormal];
    self.play_pause.tag = PLAYTAG;
    [self.play_pause addTarget:self action:@selector(start:) forControlEvents:UIControlEventTouchUpInside];
    
    
    // verifica se há som gravado
    
    if(self.audioPlayer == nil)
    {
        NSURL *musicFile = [[NSBundle mainBundle] URLForResource:@"DieFaceShifter" withExtension:@"wav"];
        self.audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:musicFile error:nil];
    }
    
    // verifica se há imagem tirada
    
    if(self.tope.image!=nil)
    {
        self.faceShifterActualImage = self.tope;
    }
    else
    {
        self.faceShifterActualImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"faceshifter.png"]];
    }
    
    
    // array com as possíveis posições da toupeira
    
    self.array = [NSArray arrayWithObjects:
                  [NSValue valueWithCGRect:CGRectMake(self.view.frame.size.width/14, self.view.frame.size.height/2.5,self.view.frame.size.width/4,self.view.frame.size.height/7.1)],
                  [NSValue valueWithCGRect:CGRectMake(self.view.frame.size.width/2.2, self.view.frame.size.height/3,self.view.frame.size.width/4,self.view.frame.size.height/7.1)],
                  [NSValue valueWithCGRect:CGRectMake(self.view.frame.size.width/1.4, self.view.frame.size.height/4.2,self.view.frame.size.width/4,self.view.frame.size.height/7.1)],
                  [NSValue valueWithCGRect:CGRectMake(self.view.frame.size.width/4.9, self.view.frame.size.height/1.83,self.view.frame.size.width/4,self.view.frame.size.height/7.1)],
                  [NSValue valueWithCGRect:CGRectMake(self.view.frame.size.width/1.6, self.view.frame.size.height/2.1,self.view.frame.size.width/4,self.view.frame.size.height/7.1)],
                  [NSValue valueWithCGRect:CGRectMake(self.view.frame.size.width/18, self.view.frame.size.height/1.46,self.view.frame.size.width/4,self.view.frame.size.height/7.1)],
                  [NSValue valueWithCGRect:CGRectMake(self.view.frame.size.width/1.83, self.view.frame.size.height/1.55,self.view.frame.size.width/4,self.view.frame.size.height/7.1)],
                  [NSValue valueWithCGRect:CGRectMake(self.view.frame.size.width/3.3, self.view.frame.size.height/1.28,self.view.frame.size.width/4,self.view.frame.size.height/7.1)],
                  [NSValue valueWithCGRect:CGRectMake(self.view.frame.size.width/1.47, self.view.frame.size.height/1.33,self.view.frame.size.width/4,self.view.frame.size.height/7.1)], nil];
    
    // adiciona tudo a view
    
    [self.view addSubview:background];
    [self.view addSubview:self.label];
    [self.view addSubview:self.play_pause];
    [self.view addSubview:self.edHead1];
    [self.view addSubview:self.edHead2];
    [self.view addSubview:self.edHead3];
    
    // crateras
    
    UIImageView *crateras = [[UIImageView alloc] initWithFrame:CGRectMake(14, 403/1.97, 610/2, 695/2)];
    [crateras setImage:[UIImage imageNamed:@"Level_2_FrontCat.png"]];
    [self.view addSubview:crateras];
    
   /* UIImageView *cratera1 = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.frame.size.width/22.07, self.view.frame.size.height/1.095,self.view.frame.size.width/3.44,self.view.frame.size.height/17.21)];
    [cratera1 setImage:[UIImage imageNamed:@"Crat_1.png"]];
    [self.view addSubview:cratera1];
    UIImageView *cratera2 = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2.819, self.view.frame.size.height/1.182, self.view.frame.size.width/3.44,self.view.frame.size.height/17.21)];
    [cratera2 setImage:[UIImage imageNamed:@"Crat_2.png"]];
    [self.view addSubview:cratera2];
    UIImageView *cratera3 = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.frame.size.width/1.48, self.view.frame.size.height/1.095, self.view.frame.size.width/3.44,self.view.frame.size.height/17.21)];
    [cratera3 setImage:[UIImage imageNamed:@"Crat_3.png"]];
    [self.view addSubview:cratera3];
    UIImageView *cratera4 = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.frame.size.width/47.06, self.view.frame.size.height/1.358, self.view.frame.size.width/3.44,self.view.frame.size.height/17.21)];
    [cratera4 setImage:[UIImage imageNamed:@"Crat_4.png"]];
    [self.view addSubview:cratera4];
    UIImageView *cratera5 = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2.819, self.view.frame.size.height/1.439, self.view.frame.size.width/3.44,self.view.frame.size.height/17.21)];
    [cratera5 setImage:[UIImage imageNamed:@"Crat_5.png"]];
    [self.view addSubview:cratera5];
    UIImageView *cratera6 = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.frame.size.width/1.458, self.view.frame.size.height/1.53, self.view.frame.size.width/3.44,self.view.frame.size.height/17.21)];
    [cratera6 setImage:[UIImage imageNamed:@"Crat_6.png"]];
    [self.view addSubview:cratera6];
    UIImageView *cratera7 = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.frame.size.width/6.35, self.view.frame.size.height/1.88, self.view.frame.size.width/3.44,self.view.frame.size.height/17.21)];
    [cratera7 setImage:[UIImage imageNamed:@"Crat_7.png"]];
    [self.view addSubview:cratera7];
    UIImageView *cratera8 = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2.57, self.view.frame.size.height/2.42, self.view.frame.size.width/3.44,self.view.frame.size.height/17.21)];
    [cratera8 setImage:[UIImage imageNamed:@"Crat_8.png"]];
    [self.view addSubview:cratera8];
    UIImageView *cratera9 = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.frame.size.width/1.47, self.view.frame.size.height/2.01, self.view.frame.size.width/3.44,self.view.frame.size.height/17.21)];
    [cratera9 setImage:[UIImage imageNamed:@"Crat_9.png"]];
    [self.view addSubview:cratera9];*/
}

- (void)viewDidAppear:(BOOL)animated
{
    
    self.contador=0;
    self.edCount = 0;
    self.edAcertou = 0;
    self.edTempo = 0;
    self.faceShifterCount = 0;
    self.faceShifterAcertou = 1;
    self.faceShifterTempo = 0;
    self.vidas = 3;
    self.scoreToWin = 400;
    self.marteloCount = 0;
    
    // verifica a dificuldade escolhida e define o tempo de aparição da toupeira
    
    if(self.difficulty == 0)
    {
        self.faceShifterTempo = 1.5;
        self.edTempo = 2.0;
    }
    else if(self.difficulty == 1)
    {
        self.faceShifterTempo = 1;
        self.edTempo = 1.5;
    }
    else
    {
        self.faceShifterTempo = 0.5;
        self.edTempo = 1;
    }
    
    // cria timers (actions) do faceshifter, ed e nave
    
    self.translacao = 1;
    //self.spaceship.frame = CGRectMake(0, self.view.frame.size.height/6.31, self.view.frame.size.width/3.555, self.view.frame.size.height/11.36);
    
    //self.nave = [NSTimer scheduledTimerWithTimeInterval:0.05 target:self selector:@selector(moveNave) userInfo:nil repeats:YES];
    self.myTimer = [NSTimer scheduledTimerWithTimeInterval:self.faceShifterTempo target:self selector:@selector(geraFaceShifter) userInfo:nil repeats:YES];
    self.edTimer = [NSTimer scheduledTimerWithTimeInterval:self.edTempo target:self selector:@selector(geraEd) userInfo:nil repeats:YES];
}


-(void)aumentaDificuldade
{
    NSLog(@"%f",self.faceShifterTempo);
    [self.myTimer invalidate];
    self.faceShifterTempo -= 0.1;
    if (self.edTempo > 0.8)
    {
        self.edTempo -= 0.1;
    }
    if (self.vidas > 0)
    {
        self.myTimer = [NSTimer scheduledTimerWithTimeInterval:self.faceShifterTempo target:self selector:@selector(geraFaceShifter) userInfo:nil repeats:YES];
    }
    
}

// CRIA A ANIMACAO DA NAVE QUE SE MOVE DURANTE O JOGO
/*
-(void) moveNave
{
    
    if(self.spaceship.center.x > self.view.frame.size.width)
        self.translacao = -self.translacao;
    else if(self.spaceship.center.x <= 0)
        self.translacao = -self.translacao;
    
    self.spaceship.center = CGPointMake(self.spaceship.center.x + self.translacao, self.spaceship.center.y);
    
    [self.view addSubview:self.spaceship];
    
}
*/
// METODOS USADOS PARA GERAR E TRATAR O ED

-(void)geraEd
{
    self.marteloCount = 0;
    self.edCount = 0;
    [self.edImage removeFromSuperview];
    self.edAcertou = 0;
    self.edImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"ED_SF3"]];
    NSValue *val = [self.array objectAtIndex:arc4random()%9];
    CGRect p = [val CGRectValue];
    while((p.origin.x == self.faceShifterImage.frame.origin.x )&& (p.origin.y == self.faceShifterImage.frame.origin.y))
    {
        val = [self.array objectAtIndex:arc4random()%9];
        p = [val CGRectValue];
    }
    self.edImage.frame = p;
    [self.view addSubview:self.edImage];
    self.edImage.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(edHit)];
    tap.numberOfTapsRequired = 1;
    [self.edImage addGestureRecognizer:tap];
    
}

-(void)edHit
{
    self.edAcertou = 1;
    
    if(self.edCount == 0)
    {
        self.edCount = 1;
        self.removeEdTimer =[NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(shouldRemoveEd) userInfo:nil repeats:YES];
    }
    
    self.martelo = [[UIImageView alloc] initWithFrame:CGRectMake(self.edImage.center.x,self.edImage.center.y-90,90,90)];
    self.martelo.animationImages = [NSArray arrayWithObjects:
                                    [UIImage imageNamed:@"LH_F1.png"],
                                    [UIImage imageNamed:@"LH_F2.png"],
                                    [UIImage imageNamed:@"LH_F3.png"],
                                    [UIImage imageNamed:@"LH_F4.png"],
                                    [UIImage imageNamed:@"LH_F5.png"],
                                    [UIImage imageNamed:@"LH_F6.png"],
                                    [UIImage imageNamed:@"LH_F7.png"],
                                    [UIImage imageNamed:@"LH_F8.png"],
                                    [UIImage imageNamed:@"LH_F9.png"],
                                    [UIImage imageNamed:@"LH_F9.png"],
                                    [UIImage imageNamed:@"LH_F9.png"],
                                    [UIImage imageNamed:@"LH_F9.png"],
                                    [UIImage imageNamed:@"LH_F9.png"],
                                    [UIImage imageNamed:@"LH_F9.png"],
                                    [UIImage imageNamed:@"LH_F9.png"],
                                    [UIImage imageNamed:@"LH_F9.png"],nil];
    
    // all frames will execute in 1.75 seconds
    self.martelo.animationDuration = 0.2;
    // repeat the animation forever
    self.martelo.animationRepeatCount = 1;
    // start animating
    [self.view addSubview:self.martelo];
    self.marteloCount = 1;
    [self.martelo startAnimating];
    
    self.edImage.image = [UIImage imageNamed:@"ED_SF7.png"];
    
    
    
}

-(void)shouldRemoveEd
{
    if(![self.martelo isAnimating] && self.marteloCount == 1)
    {
        [self.removeEdTimer invalidate];
        [self.edImage removeFromSuperview];
        [self perdeVida];
    }
}


// METODOS USADOS PARA GERAR E TRATAR O FACESHIFTER

-(void)geraFaceShifter
{
    self.marteloCount = 0;
    
    if (self.faceShifterAcertou == 0)
    {
        [self.faceShifterImage removeFromSuperview];
        [self perdeVida];
    }
    
    if (self.vidas > 0)
    {
        if (self.contador  % 65 == 0 && self.faceShifterTempo > 0.6)
        {
            [self aumentaDificuldade];
        }
        
        self.faceShifterCount = 0;
        [self.faceShifterImage removeFromSuperview];
        self.faceShifterAcertou = 0;
        self.faceShifterImage = [[UIImageView alloc]initWithImage:self.faceShifterActualImage.image ];
        NSValue *val = [self.array objectAtIndex:arc4random()%9];
        CGRect p = [val CGRectValue];
        while((p.origin.x == self.edImage.frame.origin.x )&& (p.origin.y == self.edImage.frame.origin.y))
        {
            val = [self.array objectAtIndex:arc4random()%9];
            p = [val CGRectValue];
        }

        
        self.faceShifterImage.frame = p;
        [self.view addSubview:self.faceShifterImage];
        self.faceShifterImage.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(faceShifterHit)];
        tap.numberOfTapsRequired = 1;
        [self.faceShifterImage addGestureRecognizer:tap];
    }
}

-(void)faceShifterHit
{
    self.faceShifterAcertou = 1;
    [self.label removeFromSuperview];
    
    if(self.faceShifterCount == 0)
    {
        self.contador+=13;
        [self.audioPlayer play];
        self.faceShifterCount = 1; // não permite martelar + de 1 vez
        self.removeFaceShifterTimer =[NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(shouldRemoveFaceShifter) userInfo:nil repeats:YES];
        
    }
    [self.label setText:[NSString stringWithFormat:@"+%d",self.contador]];
    [self.view addSubview:self.label];
    
    self.martelo = [[UIImageView alloc] initWithFrame:CGRectMake(self.faceShifterImage.center.x,self.faceShifterImage.center.y-90,90,90)];
    self.martelo.animationImages = [NSArray arrayWithObjects:
                                    [UIImage imageNamed:@"LH_F1.png"],
                                    [UIImage imageNamed:@"LH_F2.png"],
                                    [UIImage imageNamed:@"LH_F3.png"],
                                    [UIImage imageNamed:@"LH_F4.png"],
                                    [UIImage imageNamed:@"LH_F5.png"],
                                    [UIImage imageNamed:@"LH_F6.png"],
                                    [UIImage imageNamed:@"LH_F7.png"],
                                    [UIImage imageNamed:@"LH_F8.png"],
                                    [UIImage imageNamed:@"LH_F9.png"],
                                    [UIImage imageNamed:@"LH_F9.png"],
                                    [UIImage imageNamed:@"LH_F9.png"],
                                    [UIImage imageNamed:@"LH_F9.png"],
                                    [UIImage imageNamed:@"LH_F9.png"],
                                    [UIImage imageNamed:@"LH_F9.png"],
                                    [UIImage imageNamed:@"LH_F9.png"],
                                    [UIImage imageNamed:@"LH_F9.png"],nil];
    
    self.martelo.animationDuration = 0.2;
    self.martelo.animationRepeatCount = 1;
    [self.view addSubview:self.martelo];
    self.marteloCount = 1;
    [self.martelo startAnimating];
    
    self.faceShifterImage.image = [UIImage imageNamed:@"MF_SF8.png"];
    
    
}

-(void)shouldRemoveFaceShifter
{
    if(![self.martelo isAnimating] && self.marteloCount == 1)
    {
        [self.removeFaceShifterTimer invalidate];
        [self.faceShifterImage removeFromSuperview];
    }
    
}

// METODOS AUXILIARES

-(void)perdeVida
{
    self.vidas--;
    NSLog(@"vidas: %d",self.vidas);
    if (self.vidas == 2)
        [self.edHead3 removeFromSuperview];
    else if (self.vidas == 1)
        [self.edHead2 removeFromSuperview];
    else
    {
        [self.edHead1 removeFromSuperview];
        [self gameOver];
    }
}

-(void)gameOver
{
    NSLog(@"Gameover");
    [self.myTimer invalidate];
    [self.edTimer invalidate];
    [self.nave invalidate];
    //testa o score atual com o highscore
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *path = [documentsDirectory stringByAppendingPathComponent:@"RankingList.plist"];
    
    self.dict = [[NSMutableDictionary alloc] initWithContentsOfFile:path];
    self.scores = [NSMutableArray array];
    self.nomes = [NSMutableArray array];
    
    if(!self.dict)
    {
        self.dict = [[NSMutableDictionary alloc] init];
    }
    else
    {
        self.scores = [NSMutableArray arrayWithArray:[self.dict objectForKey:@"scores"]];
        self.nomes = [NSMutableArray arrayWithArray:[self.dict objectForKey:@"nomes"]];
    }
    
    int highTemp;
    int qtdScores = (int)[self.scores count];
    
    if (qtdScores == 0)
    {
        highTemp = 0;
        
    }
    else if ( qtdScores < 5)
    {
        highTemp = 0;
    }
    else
    {
        highTemp = [[self.scores objectAtIndex:4] intValue];
    }
    
    if(self.contador > highTemp)
    {
        [self.myTimer invalidate];
        UIVisualEffect *blurEffect;
        blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
        self.visualEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
        self.visualEffectView.frame = self.view.frame;
        [self.view addSubview:self.visualEffectView];
        
        self.imagem = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 482/1.8, 69/1.8)];
        self.imagem.center = CGPointMake(self.view.center.x, self.view.frame.size.height/5);
        self.imagem.image = [UIImage imageNamed:@"New Highscore.png"];
        [self.view addSubview:self.imagem];
        
        self.highscoreName = [[UITextField alloc]initWithFrame:CGRectMake(0,0, self.view.frame.size.width/2.133, self.view.frame.size.height/18.933)];
        self.highscoreName.center = CGPointMake(self.view.center.x, self.view.frame.size.height/3);
        self.highscoreName.delegate = self;
        self.highscoreName.placeholder = @"Your name";
        self.highscoreName.borderStyle = UITextBorderStyleRoundedRect;
        self.highscoreName.clearButtonMode = YES;
        [self.view addSubview:self.highscoreName];
        
        self.save = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 20)];
        self.save.center = CGPointMake(self.view.center.x, self.view.frame.size.height/2);
        [self.save setTitle:@"Save" forState:UIControlStateNormal];
        self.save.backgroundColor = [UIColor clearColor];
        [self.save setTitleColor:[UIColor colorWithRed:49/255.0 green:79/255.0 blue:79/255.0 alpha:1.0] forState:UIControlStateNormal];
        [self.view addSubview:self.save];
        [self.save addTarget:self action:@selector(salva) forControlEvents:UIControlEventTouchUpInside];
    }
    else
        [self quitGame];
    
}

-(void)salva
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *path = [documentsDirectory stringByAppendingPathComponent:@"RankingList.plist"];
    
    if ([self.scores count] > 4)
    {
        [self.scores removeLastObject];
        [self.nomes removeLastObject];
    }
    
    [self.scores addObject:[NSString stringWithFormat:@"%d",self.contador]];
    [self.nomes addObject:self.highscoreName.text];
    [self sortArray:self.scores andArray:self.nomes];
    [self.dict setObject:self.scores forKey:@"scores"];
    [self.dict setObject:self.nomes forKey:@"nomes"];
    
    [self.dict writeToFile:path atomically:YES];
    
    [self.popUp removeFromSuperview];
    [self.highscoreName removeFromSuperview];
    [self.save removeFromSuperview];
    [self.imagem removeFromSuperview];
    
    [self quitGame];
}

-(void)quitGame
{
    double delayInSeconds = 0.3;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void)
                   {
                       FifthViewController *fvc = [[FifthViewController alloc] init];
                       fvc.acertos = self.contador;
                       if(self.contador >= self.scoreToWin)
                           fvc.winOrLose = YES;
                       else
                           fvc.winOrLose = NO;
                       fvc.dificuldade = self.difficulty;
                       //fvc.tope = self.faceShifterImage;
                       fvc.tope = self.tope;
                       fvc.audioPlayer = self.audioPlayer;
                       [self.backgroundMusic stop];
                       [self presentViewController:fvc animated:NO completion:nil];
                   });
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    return YES;
    
}

-(void) sortArray:(NSMutableArray*)a1 andArray:(NSMutableArray*)a2
{
    int fim,i,troca;
    
    for (fim = [a1 count]-1; fim > 0 ; fim--)
    {
        troca = 0;
        for(i = 0; i < fim; i++)
        {
            int ordem = [self compare:[a1 objectAtIndex:i] with:[a1 objectAtIndex:i+1]];
            if (ordem)
            {
                
                NSObject *new = [a1 objectAtIndex:i];
                [a1 replaceObjectAtIndex:i withObject:[a1 objectAtIndex:i+1]];
                [a1 replaceObjectAtIndex:i+1 withObject:new];
                
                new = [a2 objectAtIndex:i];
                [a2 replaceObjectAtIndex:i withObject:[a2 objectAtIndex:i+1]];
                [a2 replaceObjectAtIndex:i+1 withObject:new];
                troca = 1;
            }
        }
        if(troca == 0) return;
    }
}

-(int) compare:(id)num1 with:(id)num2
{
    int v1 = [num1 intValue];
    int v2 = [num2 intValue];
    
    if (v1 < v2)
    {
        return 1;
    }
    return 0;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    // Prevent crashing undo bug – see note below.
    if(range.length + range.location > textField.text.length)
    {
        return NO;
    }
    
    NSUInteger newLength = [textField.text length] + [string length] - range.length;
    return (newLength > 10) ? NO : YES;
}


// botão play/pause

- (void)start:(id)sender
{
    if(self.play_pause.tag == PLAYTAG)
    {
        UIVisualEffect *blurEffect;
        blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
        self.visualEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
        self.visualEffectView.frame = self.view.frame;
        [self.view addSubview:self.visualEffectView];
        
        self.joga = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2.157, self.view.frame.size.height/3, 30, 30)];
        [self.joga setImage:[UIImage imageNamed:@"Button_Play.png"] forState:UIControlStateNormal];
        [self.view addSubview:self.joga];
        [self.joga addTarget:self action:@selector(play) forControlEvents:UIControlEventTouchUpInside];
        
        self.restart = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2.164, self.view.frame.size.height/2, 30, 30)];
        [self.restart setImage:[UIImage imageNamed:@"Button_Restart.png"] forState:UIControlStateNormal];
        [self.view addSubview:self.restart];
        [self.restart addTarget:self action:@selector(recomeca) forControlEvents:UIControlEventTouchUpInside];
        
        self.levels = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2.164, 2*self.view.frame.size.height/3, 30, 30)];
        [self.levels setImage:[UIImage imageNamed:@"Button_LevelsMenu.png"] forState:UIControlStateNormal];
        [self.view addSubview:self.levels];
        [self.levels addTarget:self action:@selector(volta) forControlEvents:UIControlEventTouchUpInside];
        
        self.faceShifterImage.userInteractionEnabled = NO;
        
        [self.nave invalidate];
        [self.myTimer invalidate];
        [self.edTimer invalidate];
    }
}

-(void)volta
{
    ThirdViewController *tvc = [[ThirdViewController alloc] init];
    [self.backgroundMusic stop];
    tvc.tope = self.tope;
    tvc.audioPlayer = self.audioPlayer;
    [self presentViewController:tvc animated:NO completion:nil];
}

-(void)recomeca
{
    self.vidas = 3;
    [self.label removeFromSuperview];
    [self.visualEffectView removeFromSuperview];
    [self.joga removeFromSuperview];
    [self.restart removeFromSuperview];
    [self.levels removeFromSuperview];
    self.spaceship.frame = CGRectMake(0, self.view.frame.size.height/6.31, self.view.frame.size.width/3.555, self.view.frame.size.height/11.36);
    [self.view addSubview:self.edHead1];
    [self.view addSubview:self.edHead2];
    [self.view addSubview:self.edHead3];
    self.faceShifterImage.userInteractionEnabled = YES;
    self.play_pause.tag = PLAYTAG;
    self.contador = 0;
    [self.label setFont:[UIFont fontWithName:@"MarkerFelt-Thin" size:30.0]];
    [self.label setText:[NSString stringWithFormat:@"+%d",self.contador]];
    self.label.textAlignment = NSTextAlignmentCenter;
    self.label.textColor = [UIColor whiteColor];
    self.label.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.label];
    self.myTimer = [NSTimer scheduledTimerWithTimeInterval:self.faceShifterTempo target:self selector:@selector(geraFaceShifter) userInfo:nil repeats:YES];
   // self.nave = [NSTimer scheduledTimerWithTimeInterval:0.05 target:self selector:@selector(moveNave) userInfo:nil repeats:YES];
    self.edTimer = [NSTimer scheduledTimerWithTimeInterval:self.edTempo target:self selector:@selector(geraEd) userInfo:nil repeats:YES];
}

-(void)play
{
    [self.visualEffectView removeFromSuperview];
    [self.joga removeFromSuperview];
    [self.restart removeFromSuperview];
    [self.levels removeFromSuperview];
    self.faceShifterImage.userInteractionEnabled = YES;
    self.play_pause.tag = PLAYTAG;
    self.myTimer = [NSTimer scheduledTimerWithTimeInterval:self.faceShifterTempo target:self selector:@selector(geraFaceShifter) userInfo:nil repeats:YES];
  //  self.nave = [NSTimer scheduledTimerWithTimeInterval:0.05 target:self selector:@selector(moveNave) userInfo:nil repeats:YES];
    self.edTimer = [NSTimer scheduledTimerWithTimeInterval:self.edTempo target:self selector:@selector(geraEd) userInfo:nil repeats:YES];
}


- (void) viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [self.myTimer invalidate];
}


@end