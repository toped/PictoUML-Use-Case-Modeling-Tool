//
//  EventInputViewController.m
//  PictoUML
//
//  Created by TopeD on 10/20/15.
//  Copyright © 2015 Tope Daramola. All rights reserved.
//

#import "EventInputViewController.h"

@interface EventInputViewController ()

@end

@implementation EventInputViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    [self registerTapGuesters];
    
    //if user is editing an event
    if(self.editingEvent != nil){
        
        self.eventNameField.text = self.editingEvent.e_name;
        self.eventImageView.image = self.editingEvent.e_image;
        self.eventDesctiptionTextView.text = self.editingEvent.e_description;
        self.videoURL = self.editingEvent.e_videoURL;
        self.eventUUID = self.editingEvent.e_uuid;
        
    }

}

-(void)registerTapGuesters {
    
    //Gesture on view
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                          action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:tap];
    
    //Gesture on eventImageView
    UITapGestureRecognizer *imageTap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                               action:@selector(setEventImage)];
    
    [self.eventImageView addGestureRecognizer:imageTap];
    
}

-(void)dismissKeyboard {
    
    [self.eventNameField resignFirstResponder];
    [self.eventDesctiptionTextView resignFirstResponder];
    
}

-(void)setEventImage {
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Set Event Image"
                                                                   message:@""
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cameraAction = [UIAlertAction actionWithTitle:@"Take Photo"
                                                           style:UIAlertActionStyleDefault
                                                         handler:^(UIAlertAction * action) {
                                                             
                                                             UIImagePickerController *picker = [[UIImagePickerController alloc] init];
                                                             picker.delegate = self;
                                                             [picker setSourceType:UIImagePickerControllerSourceTypeCamera];
                                                             [self presentViewController:picker animated:YES completion:NULL];
                                                             
                                                         }];
    
    UIAlertAction *libraryAction = [UIAlertAction actionWithTitle:@"Choose Video From Library" style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {
                                                              
                                                              UIImagePickerController *picker = [[UIImagePickerController alloc] init];
                                                              picker.delegate = self;
                                                              [picker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
                                                              
                                                              picker.mediaTypes = [[NSArray alloc] initWithObjects:(NSString *)kUTTypeMovie, nil];
                                                              
                                                              
                                                              [self presentViewController:picker animated:YES completion:NULL];
                                                              
                                                          }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel
                                                          handler:^(UIAlertAction * action) {
                                                              
                                                              [alert dismissViewControllerAnimated:YES completion:nil];
                                                              
                                                          }];
    
    
    //[alert addAction:cameraAction];
    [alert addAction:libraryAction];
    
    if (self.eventImageView.image != nil) {
        UIAlertAction *removeAction = [UIAlertAction actionWithTitle:@"Remove Photo" style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction * action) {
                                                                  
                                                                  self.eventImageView.image = [UIImage imageNamed:@"photo_icon"];
                                                                  
                                                              }];
        
        //[alert addAction:removeAction];

    }
    
    [alert addAction:cancelAction];
    
    [self presentViewController:alert animated:YES completion:nil];
    
}


-(void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    /*self.eventImageView.image = [info objectForKey:UIImagePickerControllerOriginalImage];*/
    NSString *mediaType = [info objectForKey: UIImagePickerControllerMediaType];
    
    if (CFStringCompare ((__bridge CFStringRef) mediaType, kUTTypeMovie, 0) == kCFCompareEqualTo) {
        
        self.videoURL = [info objectForKey:UIImagePickerControllerMediaURL];
        
        
        //Create Thumbnail
        AVAsset *asset = [AVAsset assetWithURL:self.videoURL];
        AVAssetImageGenerator *imageGenerator = [[AVAssetImageGenerator alloc]initWithAsset:asset];
        CMTime time = CMTimeMake(1, 1);
        CGImageRef imageRef = [imageGenerator copyCGImageAtTime:time actualTime:NULL error:NULL];
        UIImage *thumbnail = [UIImage imageWithCGImage:imageRef];
        
        self.eventImageView.image = thumbnail;
        CGImageRelease(imageRef);
    
    }

    [self dismissViewControllerAnimated:YES completion:NULL];
    
}

-(void) imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self dismissViewControllerAnimated:YES completion:NULL];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)dismissView:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

- (IBAction)saveAnddismissView:(id)sender {
    
    //I should probably validate the text here, but I think I'll do it later
    
    
    //PASS DATA BACK TO PARENT VIEWCONTROLLER
    [self.delegate didFinishEventInputWithName:[self.eventNameField text]
                              eventDescription:[self.eventDesctiptionTextView text]
                                 eventVideoURL:self.videoURL
                                      eventImage:[self.eventImageView image]
                                       andUUID:self.eventUUID];
     
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

@end
