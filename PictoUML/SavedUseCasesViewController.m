//
//  SavedUseCasesViewController.m
//  PictoUML
//
//  Created by TopeD on 10/22/15.
//  Copyright © 2015 Tope Daramola. All rights reserved.
//

#import "SavedUseCasesViewController.h"
#import "UseCaseBuilderViewController.h"

@interface SavedUseCasesViewController ()

@end

@implementation SavedUseCasesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"PictoUML";
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    // check if user has added any properties
    if([defaults boolForKey:@"hasUseCases"] == YES) {
        
        self.savedUseCases = [[NSMutableArray alloc] init];
        for (NSData *data in [defaults objectForKey:@"savedUseCases"]) {
            
            UseCase *useCaseItem = [NSKeyedUnarchiver unarchiveObjectWithData:data];
            [self.savedUseCases addObject:useCaseItem];
            
        }
        
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark TableView Delegate Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    //number of rows determined by items in categories array
    return [self.savedUseCases count];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    // Return the number of sections.
    if (self.savedUseCases) {
        
        tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        return 1;
        
    } else {
        
        // Display a message when the table is empty
        UILabel *messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
        
        messageLabel.text = @"No use cases have been created yet. Tap the 'Get Started' button on the home screen to create your first use case.";
        messageLabel.textColor = [UIColor blackColor];
        messageLabel.numberOfLines = 0;
        messageLabel.textAlignment = NSTextAlignmentCenter;
        messageLabel.font = [UIFont fontWithName:@"Palatino-Italic" size:20];
        [messageLabel sizeToFit];
        
        tableView.backgroundView = messageLabel;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
    }
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    UITableViewCell *cell = [[ UITableViewCell alloc ] initWithStyle : UITableViewCellStyleSubtitle reuseIdentifier : @"UITableViewCell" ];
    
    //customize the table cell text
    [[cell textLabel] setText:[[self.savedUseCases objectAtIndex:indexPath.row] title]];
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSString *selectedCell = nil;
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    selectedCell = cell.textLabel.text;
    
    NSLog(@"%@", selectedCell);
    
    UseCase *selectedUseCase = [self.savedUseCases objectAtIndex:indexPath.row];
    UseCaseBuilderViewController *useCaseBuilder = [[UseCaseBuilderViewController alloc] init];
    [useCaseBuilder setCurrentUseCase:selectedUseCase];
    [[self navigationController] pushViewController:useCaseBuilder animated:YES];
    
}

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return YES;
    
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //Nothing gets called here if you invoke `tableView:editActionsForRowAtIndexPath:` according to Apple docs so just leave this method blank
    
}

-(NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewRowAction *delete = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault
                                                                      title:@"Delete" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
                                                                          
                                                                          NSString *selectedCell = nil;
                                                                          UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
                                                                          selectedCell = cell.textLabel.text;
                                                                          NSLog(@"%@", selectedCell);
                                                                          
                                                                          //update NSUserDefaults
                                                                          NSUserDefaults *userAppData = [NSUserDefaults standardUserDefaults];
                                                                          NSMutableArray *useCaseArray = [[userAppData objectForKey:@"savedUseCases"] mutableCopy];
                                                                          [useCaseArray removeObjectAtIndex:indexPath.row];
                                                                          [userAppData setObject:useCaseArray forKey:@"savedUseCases"];
                                                                          [userAppData synchronize];
                                                                          
                                                                          //update array for tableView
                                                                          [self.savedUseCases removeObjectAtIndex:indexPath.row];
                                                                          
                                                                          if (([self.savedUseCases count] > 0) == false) {
                                                                              self.savedUseCases = nil;
                                                                              [userAppData setBool:NO forKey:@"hasUseCases"];
                                                                              [userAppData synchronize];
                                                                              
                                                                              // Section is now completely empty, so delete the entire section.
                                                                              [tableView deleteSections:[NSIndexSet indexSetWithIndex:indexPath.section]
                                                                                       withRowAnimation:UITableViewRowAnimationFade];
                                                                          }
                                                                          else{
                                                                              
                                                                              [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                                                                                               withRowAnimation:UITableViewRowAnimationFade];
                                                                          }

                                                                          
                                                                      }];
    delete.backgroundColor = [UIColor redColor];
    
    UITableViewRowAction *more = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@" Edit "
                                                                  handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
                                                                      
                                                                  }];
    
    more.backgroundColor = [UIColor colorWithRed:0.188 green:0.514 blue:0.984 alpha:1];
    
    return @[delete, more]; //array with all the buttons you want. 1,2,3, etc...
}



@end
