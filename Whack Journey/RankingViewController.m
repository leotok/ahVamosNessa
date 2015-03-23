

#import "RankingViewController.h"

@interface RankingViewController ()

@property NSMutableArray *scores;
@property NSMutableArray *nomes;
@property NSMutableDictionary *dict;


@end

@implementation RankingViewController

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // imagens
    
    UIImageView *background = [[UIImageView alloc]initWithFrame:self.view.frame];
    background.image = [UIImage imageNamed:@"Ranking_BG.png"];
    
    UIImageView *table = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width , self.view.frame.size.height/1.4)];
    [table setImage:[UIImage imageNamed:@"Ranking_Table.png"]];
    table.center = CGPointMake(self.view.center.x, self.view.frame.size.height/1.899);
    
    // botões
    
    UIButton *back = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width/32, self.view.frame.size.height/56.8, self.view.frame.size.width/10.667, self.view.frame.size.height/18.933)];
    back.layer.cornerRadius = 10;
    [back setImage:[UIImage imageNamed:@"Ranking_BackB.png"] forState:UIControlStateNormal];
    [back addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIButton *zeraRanking = [[UIButton alloc] initWithFrame:CGRectMake(self.view.center.x-25, 10, 60, 30)];
    zeraRanking.layer.cornerRadius = 10;
    [zeraRanking setTitle:@"Zerar" forState:UIControlStateNormal];
    zeraRanking.backgroundColor = [UIColor colorWithRed:139/255.0 green:136/255.0 blue:120/255.0 alpha:1.0];
    [zeraRanking addTarget:self action:@selector(zerar) forControlEvents:UIControlEventTouchUpInside];
    
    
    // tableview highscore
    
    UITableView *highScoreTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width/1.4, self.view.frame.size.height/2) style:UITableViewStylePlain];
    highScoreTableView.center = CGPointMake(self.view.center.x/1.05, self.view.frame.size.height/1.9);
    highScoreTableView.bounces = NO;
    highScoreTableView.delegate = self;
    highScoreTableView.dataSource = self;
    highScoreTableView.backgroundColor = [UIColor clearColor];
    highScoreTableView.allowsSelection = NO;
    
    //highScoreTableView.backgroundColor = [UIColor clearColor];
    
    
    
    // adiciona tudo a view
    
    [self.view addSubview:background];
    [self.view addSubview:table];
    [self.view addSubview:back];
    //[self.view addSubview:zeraRanking];
    [self.view addSubview:highScoreTableView];
    
    
    // Find out the path of ranking.plist
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *path = [documentsDirectory stringByAppendingPathComponent:@"RankingList.plist"];
    
    // Load the file content and read the data into arrays
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
    if ([self.scores count] == 0)
    {
        [self.scores addObject:@"0"];
        [self.nomes addObject:@"Tope"];
    }
    
}

// botão para zerar

-(void)zerar
{
    
    [self.scores removeAllObjects];
    [self.nomes removeAllObjects];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *path = [documentsDirectory stringByAppendingPathComponent:@"RankingList.plist"];
    
    [self.dict setObject:self.scores forKey:@"scores"];
    [self.dict setObject:self.nomes forKey:@"nomes"];
    
    [self.dict writeToFile:path atomically:YES];
    
}

// botão para voltar

- (void)back:(id)sender
{
    [self dismissViewControllerAnimated:NO completion:nil];
}


// delegate table view

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return self.view.frame.size.height/10.327;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.scores count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    // Set the data for this cell:
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.text = [NSString stringWithFormat:@" %@:  %@",[self.nomes objectAtIndex:indexPath.row],[self.scores objectAtIndex:indexPath.row]];
    [cell.textLabel setFont:[UIFont fontWithName:@"MarkerFelt-Thin" size:20.0]];
    // set the accessory view:
    
    return cell;
}

@end
