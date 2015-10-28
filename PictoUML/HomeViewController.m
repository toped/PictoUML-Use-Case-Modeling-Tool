//
//  HomeViewController.m
//  PictoUML
//
//  Created by TopeD on 10/15/15.
//  Copyright © 2015 Tope Daramola. All rights reserved.
//

#import "HomeViewController.h"
#import "UseCaseBuilderViewController.h"
#import "SavedUseCasesViewController.h"

@interface HomeViewController ()

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.edgesForExtendedLayout = UIRectEdgeNone;
    [[self navigationItem] setTitle:@"PictoUML"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)pushUseCaseBuilder:(id)sender {
    
    UseCaseBuilderViewController *builderView = [[UseCaseBuilderViewController alloc] init];
    [self.navigationController pushViewController:builderView animated:YES];
    
}

- (IBAction)pushSavedUseCaseView:(id)sender {
    
    SavedUseCasesViewController *saveUseCasesView = [[SavedUseCasesViewController alloc] init];
    [[self navigationController] pushViewController:saveUseCasesView animated:YES];

}
@end
