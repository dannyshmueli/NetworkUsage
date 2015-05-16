//
//  ViewController.m
//  NetworkDataStats
//
//  Created by Danny Shmueli on 5/15/15.
//  Copyright (c) 2015 omdan. All rights reserved.
//

#import "ViewController.h"
#import "StatsManager.h"
#import "NSURLConnection+Blocks.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UILabel *wifiSentLabel;
@property (weak, nonatomic) IBOutlet UILabel *wifiReceivedLabel;
@property (weak, nonatomic) IBOutlet UILabel *wanSentLabel;
@property (weak, nonatomic) IBOutlet UILabel *wanReceivedLabel;

@property (weak, nonatomic) IBOutlet UILabel *lastRebootLabel;
@property (weak, nonatomic) IBOutlet UILabel *countingSinceLabel;

@property (weak, nonatomic) IBOutlet UIButton *downloadSomethingButton;

@end

@implementation ViewController

#pragma mark - Events

- (IBAction)didPressResetButton:(id)sender
{
    [StatsManager reset];
    [self updateUi];
}

- (IBAction)didPressDownloadSomethingButton:(id)sender
{
    self.downloadSomethingButton.enabled = NO;
    
    NSURLRequest *req = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://dannyshmueli.com/images/heroBack.jpg"] cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:300];
    [NSURLConnection connectionWithRequest:req onCompletion:^(NSData *data, NSInteger statusCode )
    {
        self.downloadSomethingButton.enabled = YES;
    } onFail:^(NSError *error, NSInteger statusCode)
    {
        self.downloadSomethingButton.enabled = YES;
    }];
}

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self updateUi];
    [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(refreshUI) userInfo:nil repeats:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Private
-(void)refreshUI
{
    [StatsManager update];
    [self updateUi];
}

-(NSString *)formatBytesToString:(NSNumber *)sizeInBytes
{
    float sizeInKBytes = sizeInBytes.integerValue / 1000;
    if ((NSInteger)sizeInKBytes / 1000 == 0)
    {
        return [NSString stringWithFormat:@"%.0f KBytes", @(sizeInKBytes).floatValue];
    }else
    {
        return [NSString stringWithFormat:@"%.2f MBytes", @(sizeInKBytes/1000).floatValue];
    }
}

-(void)updateUi
{
    NSDictionary *stats = [StatsManager getStats];
    self.wifiSentLabel.text = [NSString stringWithFormat:@"Wifi Sent: %@", [self formatBytesToString:stats[@"wifiSent"]]];
    self.wifiReceivedLabel.text = [NSString stringWithFormat:@"Wifi Received: %@",[ self formatBytesToString:stats[@"wifiReceived"]]];
    
    self.wanSentLabel.text = [NSString stringWithFormat:@"3G Sent: %@", [self formatBytesToString:stats[@"WWanSent"]]];
    self.wanReceivedLabel.text = [NSString stringWithFormat:@"3G Received: %@", [self formatBytesToString:stats[@"WWantReceived"]]];
    
    self.lastRebootLabel.text = [NSString stringWithFormat:@"Last Reboot: %@", [[StatsManager lastRebootDate]];
    self.countingSinceLabel.text = [NSString stringWithFormat:@"Counting Since: %@", [StatsManager countingSince]];
}


@end
