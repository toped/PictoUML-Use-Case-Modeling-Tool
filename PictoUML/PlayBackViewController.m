//
//  PlayBackViewController.m
//  PictoUML
//
//  Created by TopeD on 10/21/15.
//  Copyright © 2015 Tope Daramola. All rights reserved.
//

#import "PlayBackViewController.h"

@interface PlayBackViewController ()

@end

@implementation PlayBackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [[self navigationItem] setTitle:self.playbackUseCase.title];
    
    [self playbackUseCaseVideos];
    
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    //stop the player
    [self.player pause];
    //[self.avPlayerLayer removefromsuperlayer];
    self.player = nil;
    
}

- (void)playbackUseCaseVideos {
    
    NSMutableArray *playbackVideos = [[NSMutableArray alloc] init];
    
    for (UseCaseEvent *event in self.playbackUseCase.events) {
        
        NSURL *videoURL = event.e_videoURL;
        AVPlayerItem *playerItem = nil;

        if (videoURL != nil) {
            playerItem = [AVPlayerItem playerItemWithURL: videoURL];
        }
        
        [playbackVideos addObject:playerItem];
    }
    
    self.player = [AVQueuePlayer queuePlayerWithItems:playbackVideos];
    
    AVPlayerLayer *layer = [AVPlayerLayer layer];
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    
    [layer setFrame:CGRectMake(0, 19, screenWidth, 400)];
    [layer setBackgroundColor:[UIColor clearColor].CGColor];
    [layer setVideoGravity:AVLayerVideoGravityResizeAspect];
    [layer setNeedsLayout];
    [layer setPlayer:self.player];
    [self.view.layer addSublayer:layer];
    
    // Notify me when a new player item begins and which one it is
    for (AVPlayerItem *playerItem in self.player.items) {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(currentItemIs:)
                                                 name:AVPlayerItemDidPlayToEndTimeNotification
                                               object:playerItem];
    }
    
    [self setUpUILabels];
    
    [self.player play];
    
}

- (void) setUpUILabels {
    
    self.curentEventIndex = 0;
    [self.curentEventLabel setText:[[self.playbackUseCase.events objectAtIndex:self.curentEventIndex] e_name]];
    [self.eventDescriptionLabel setText:[[self.playbackUseCase.events objectAtIndex:self.curentEventIndex] e_description]];
    
}


- (void)currentItemIs:(NSNotification *)notification {

    AVPlayerItem *p = [notification object];
    
    // get current asset
    AVAsset *currentPlayerAsset = p.asset;
    
    // make sure the current asset is an AVURLAsset
    if ([currentPlayerAsset isKindOfClass:AVURLAsset.class]){
        //NSLog([[(AVURLAsset *)currentPlayerAsset URL] absoluteString]);
        
        for (UseCaseEvent *event in self.playbackUseCase.events) {
            
            NSString *eventVideoURLString = [event.e_videoURL absoluteString];
            NSString *currentVideoURLString = [[(AVURLAsset *)currentPlayerAsset URL] absoluteString];
            
            if ([eventVideoURLString isEqualToString:currentVideoURLString]) {
                
                
                self.curentEventIndex++;
                
                //Protect from array out of bounds error
                if (self.curentEventIndex != [self.playbackUseCase.events count]) {
                    [self.curentEventLabel setText:[[self.playbackUseCase.events objectAtIndex:self.curentEventIndex] e_name]];
                    [self.eventDescriptionLabel setText:[[self.playbackUseCase.events objectAtIndex:self.curentEventIndex] e_description]];
                }
                else {
                    [self showCompletionAlert];
                }
                
                return;
            }
            else {
                [self.curentEventLabel setText:@"Complete"];
                [self.eventDescriptionLabel setText:@""];
            }
            
        }
    }

}

- (void)showCompletionAlert {
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Playback Complete"
                                                                   message:@"Your use case has executed successfully. Tap OK to continue."
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK"
                                                 style:UIAlertActionStyleDefault
                                               handler:^(UIAlertAction * action) {
                                                   
                                                   [alert dismissViewControllerAnimated:YES completion:nil];
                                                   [self.navigationController popViewControllerAnimated:YES];
                                                   
                                               }];
    
    [alert addAction:ok];
    
    [self presentViewController:alert animated:YES completion:nil];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
