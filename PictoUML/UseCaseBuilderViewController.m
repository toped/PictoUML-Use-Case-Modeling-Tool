//
//  UseCaseBuilderViewController.m
//  PictoUML
//
//  Created by TopeD on 10/15/15.
//  Copyright © 2015 Tope Daramola. All rights reserved.
//

#import "UseCaseBuilderViewController.h"
#import "UMLTableViewCell.h"

@interface UseCaseBuilderViewController ()

@end

@implementation UseCaseBuilderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.edgesForExtendedLayout = UIRectEdgeNone;
    [[self navigationItem] setTitle:@"PictoUML"];
    
    if (self.currentUseCase == nil) {
        
        [self displayUseCaseTitleInput:self]; //This function also sets the title in UI
        self.useCaseEvents = [[NSMutableArray alloc] initWithObjects:@"[Add new event]", nil];
        
    }
    else {
        [self.useCaseTitleLabel setText:self.currentUseCase.title];
        self.useCaseEvents = [self.currentUseCase.events mutableCopy];
        if (self.useCaseEvents == nil) {
            self.useCaseEvents = [[NSMutableArray alloc] initWithObjects:@"[Add new event]", nil];
        }        
    }
    
    //Set up navigation bar button
    UIBarButtonItem *playButton = [[UIBarButtonItem alloc]
                                   initWithBarButtonSystemItem:UIBarButtonSystemItemPlay
                                   target:self
                                   action:@selector(playUseCase)];
    
    UIBarButtonItem *saveButton = [[UIBarButtonItem alloc]
                                   initWithBarButtonSystemItem:UIBarButtonSystemItemSave
                                   target:self
                                   action:@selector(saveAction:)];
    
    UIBarButtonItem *flowButton = [[UIBarButtonItem alloc]
                                       initWithImage:[UIImage imageNamed:@"flow_icon"]
                                       style:UIBarButtonItemStylePlain
                                       target:self
                                       action:@selector(displayAltFlowAlert:)];
    
    
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:playButton, saveButton, flowButton, nil];
    
}

- (void)displayUseCaseTitleInput:(id)sender{

    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"New Use Case"
                                                                   message:@"Enter name for your use case"
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK"
                                                 style:UIAlertActionStyleDefault
                                               handler:^(UIAlertAction * action) {
                                                   
                                                   //init self.currentUseCase
                                                   self.currentUseCase = [[UseCase alloc] initWithTitle:[[alert.textFields objectAtIndex:0] text]];
                                                   [self.useCaseTitleLabel setText:self.currentUseCase.title];
                                                   
                                               }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault
                                                   handler:^(UIAlertAction * action) {
                                                       [alert dismissViewControllerAnimated:YES completion:nil];
                                                       [self.navigationController popViewControllerAnimated:YES];
                                                   }];
    
    [alert addAction:ok];
    [alert addAction:cancel];
    
    
    [alert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder = @"Use Case Title";
    }];
    
    
    [self presentViewController:alert animated:YES completion:nil];
    
}

#pragma mark -
#pragma mark TableView Delegate Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [self.useCaseEvents count];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([[self.useCaseEvents objectAtIndex:indexPath.row] isKindOfClass:[UseCaseEvent class]]) {
        
        UseCaseEvent *currentRow = [self.useCaseEvents objectAtIndex:indexPath.row];
        if (currentRow.e_image != nil) {
            return 120;
        }
        return 43;
    }
    else {
        return 43;
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *simpleTableIdentifier = @"UMLTableViewCell";
    
    UMLTableViewCell *cell = (UMLTableViewCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:simpleTableIdentifier owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    if ([[self.useCaseEvents objectAtIndex:indexPath.row] isKindOfClass:[UseCaseEvent class]]) {
        
        UseCaseEvent *currentRow = [self.useCaseEvents objectAtIndex:indexPath.row];
        cell.eventLabel.text = currentRow.e_name;
        cell.eventDescription.text = currentRow.e_description;
        cell.eventImage.image = currentRow.e_image;
    }
    else{
        
        NSString *currentRow = [self.useCaseEvents objectAtIndex:indexPath.row];

        cell.eventLabel.text = currentRow;
        cell.eventLabel.textColor = [UIColor lightGrayColor];
    }
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row == [self.useCaseEvents count] - 1) {
        //Add a new event
        NSLog(@"time to add a new event");
        
        EventInputViewController *eventInputController = [[EventInputViewController alloc] init];
        [eventInputController setDelegate:self];
        [self.navigationController presentViewController:eventInputController animated:YES completion:nil];
        
    }
    else{
        
        UseCaseEvent *currentRow = [self.useCaseEvents objectAtIndex:indexPath.row];

        [self displayEventOptionsAlert:currentRow.e_name andDiscription:currentRow.e_description];
    }
    
}

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row != [self.useCaseEvents count] - 1) {
        return YES;
    }
    else{
        return NO;
    }
    
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //Nothing gets called here if you invoke `tableView:editActionsForRowAtIndexPath:` according to Apple docs so just leave this method blank
    
}

-(NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewRowAction *delete = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault
                                                                      title:@"Delete" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
                                                                          
                                                                          [self.useCaseEvents removeObjectAtIndex:indexPath.row];
                                                                          [self.currentUseCase.events removeObjectAtIndex:indexPath.row];
                                                                          [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                                                                                           withRowAnimation:UITableViewRowAnimationFade];
                                                                          
                                                                      }];
    delete.backgroundColor = [UIColor redColor];
    
    UITableViewRowAction *edit = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@" Edit "
                                                                  handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
                                                                      
                                                                      NSLog(@"time to edit a previous event");
                                                                      
                                                                      UseCaseEvent *currentRow = [self.useCaseEvents objectAtIndex:indexPath.row];
                                                                      
                                                                      EventInputViewController *eventInputController = [[EventInputViewController alloc] init];
                                                                      [eventInputController setDelegate:self];
                                                                      [eventInputController setEditingEvent:currentRow];
                                                                      [self.navigationController presentViewController:eventInputController animated:YES completion:nil];
                                                                      
                                                                  }];
    
    edit.backgroundColor = [UIColor colorWithRed:0.188 green:0.514 blue:0.984 alpha:1];
    
    return @[delete, edit]; //array with all the buttons you want. 1,2,3, etc...
}

- (void) didFinishEventInputWithName:(NSString *)eventName eventDescription:(NSString *)eventDescription eventVideoURL:(NSURL *)eventVideoURL eventImage:(UIImage *)eventImage andUUID:(NSString *)eventUUID {
    
    
    UseCaseEvent* returnedEvent = [[UseCaseEvent alloc] initWithName:eventName
                                                    eventDescription:eventDescription
                                                       eventVideoURL:eventVideoURL
                                                            andImage:eventImage];
    
    if (eventUUID == nil) {
        
        [self.useCaseEvents insertObject:returnedEvent atIndex:[self.useCaseEvents count] - 1];
        
    }
    else {
        
        returnedEvent.e_uuid = eventUUID;
        
        NSUInteger count = 0;
        for (UseCaseEvent *event in [self.useCaseEvents mutableCopy]) {
            if ([event isKindOfClass:[UseCaseEvent class]] && [returnedEvent.e_uuid isEqualToString:event.e_uuid]) {
                [self.useCaseEvents removeObject:event];
                [self.useCaseEvents insertObject:returnedEvent atIndex:count];
            }
            count++;
        }
        
    }
    
    self.currentUseCase.events = [[NSMutableArray alloc] init];
    self.currentUseCase.events = [self.useCaseEvents mutableCopy];
    
    [self.useCaseTable reloadData];
}

- (void)displayEventOptionsAlert:(NSString*) event_name andDiscription:(NSString *) event_description{
    
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:event_name
                                                                   message:event_description
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleCancel
                                                   handler:^(UIAlertAction * action) {
                                                       [alert dismissViewControllerAnimated:YES completion:nil];
                                                   }];
    
    [alert addAction:cancel];
    
    [self presentViewController:alert animated:YES completion:nil];
    
}

-(void) displayAltFlowAlert:(id) sender{
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Select at which event to start the alternative flow"
                                                                   message:nil
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    for (UseCaseEvent *event in self.useCaseEvents) {
        
        if ([event isKindOfClass:[UseCaseEvent class]]) {
            
            UIAlertAction *eventAlert = [UIAlertAction actionWithTitle:[NSString stringWithFormat:@"@%@", event.e_name]
                                                                 style:UIAlertActionStyleDefault
                                                               handler:^(UIAlertAction * action) {
                                                                   [alert dismissViewControllerAnimated:YES completion:nil];
                                                                   
                                                                   //push view to create alt flow
                                                                   
                                                               }];
            
            [alert addAction:eventAlert];
        }
        
    }
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel
                                                   handler:^(UIAlertAction * action) {
                                                       [alert dismissViewControllerAnimated:YES completion:nil];
                                                   }];
    
    [alert addAction:cancel];
    
    [self presentViewController:alert animated:YES completion:nil];
    
}

-(void)playUseCase {
    
    PlayBackViewController *playBackView = [[PlayBackViewController alloc] init];
    
    UseCase *modifiedUseCase = [[UseCase alloc] initWithTitle:self.currentUseCase.title];
    [modifiedUseCase setEvents:[self.currentUseCase.events mutableCopy]];
    [modifiedUseCase.events removeObjectAtIndex:[modifiedUseCase.events count] - 1];
    
    [playBackView setPlaybackUseCase:modifiedUseCase];
    [self.navigationController pushViewController:playBackView animated:YES];
    
}

-(void) saveAction:(id) sender{
    
    //Store user data to NSUserDefaults
    NSUserDefaults *userAppData = [NSUserDefaults standardUserDefaults];
    NSMutableArray *savedUseCases = [[userAppData objectForKey:@"savedUseCases"] mutableCopy];
    
    if(savedUseCases == nil) {
        savedUseCases = [[NSMutableArray alloc] init];
    }
    
    //remove original if applicable
    NSUInteger count = 0;
    bool foundMatch = false;
    
    for (NSData *data in [savedUseCases mutableCopy]) {
        
        UseCase *useCaseItem = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        if ([useCaseItem.uuid isEqualToString:self.currentUseCase.uuid]) {
            [savedUseCases removeObject:data];
            
            //add updated usecase
            NSData *useCaseEncodedObject = [NSKeyedArchiver archivedDataWithRootObject:self.currentUseCase];
            [savedUseCases insertObject:useCaseEncodedObject atIndex:count];
            foundMatch = true;
        }
        
        count++;
    }
    
    
    
    if (foundMatch == false) {
        NSData *useCaseEncodedObject = [NSKeyedArchiver archivedDataWithRootObject:self.currentUseCase];
        [savedUseCases addObject:useCaseEncodedObject];
    }
    
    [userAppData setObject:savedUseCases forKey:@"savedUseCases"];
    [userAppData setBool:YES forKey:@"hasUseCases"];
    [userAppData synchronize];
    
    [[self navigationController] popViewControllerAnimated:YES];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
