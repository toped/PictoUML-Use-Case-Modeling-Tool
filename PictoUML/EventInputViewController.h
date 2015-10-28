//
//  EventInputViewController.h
//  PictoUML
//
//  Created by TopeD on 10/20/15.
//  Copyright © 2015 Tope Daramola. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UseCaseEvent.h"
#import <MobileCoreServices/UTCoreTypes.h>
#import "AVFoundation/AVFoundation.h"

@protocol EventInputDelegate <NSObject>

-(void) didFinishEventInputWithName:(NSString *)eventName eventDescription:(NSString *)eventDescription eventVideoURL:(NSURL *)eventVideoURL eventImage:(UIImage *)eventImage andUUID:(NSString *)eventUUID;

@end


@interface EventInputViewController : UIViewController<UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (strong, nonatomic) IBOutlet UIImageView *eventImageView;
@property (strong, nonatomic) IBOutlet UITextView *eventDesctiptionTextView;
@property (strong, nonatomic) IBOutlet UITextField *eventNameField;
@property (strong, nonatomic) NSURL *videoURL;
@property (strong, nonatomic) NSString *eventUUID;
@property (strong, nonatomic) UseCaseEvent *editingEvent;

- (IBAction)dismissView:(id)sender;

@property (nonatomic, weak) id <EventInputDelegate> delegate;

@end
