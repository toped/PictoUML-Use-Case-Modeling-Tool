//
//  PlayBackViewController.h
//  PictoUML
//
//  Created by TopeD on 10/21/15.
//  Copyright © 2015 Tope Daramola. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MobileCoreServices/UTCoreTypes.h>
#import <QuartzCore/QuartzCore.h>
#import "AVFoundation/AVFoundation.h"
#import "UseCase.h"
#import "UseCaseEvent.h"    

@interface PlayBackViewController : UIViewController

@property (nonatomic, strong) UseCase *playbackUseCase;
@property (nonatomic, strong) AVQueuePlayer *player;
@property (strong, nonatomic) IBOutlet UILabel *curentEventLabel;
@property (strong, nonatomic) IBOutlet UITextView *eventDescriptionLabel;
@property (nonatomic) NSInteger curentEventIndex;

@end
