//
//  SavedUseCasesViewController.h
//  PictoUML
//
//  Created by TopeD on 10/22/15.
//  Copyright © 2015 Tope Daramola. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UseCase.h"

@interface SavedUseCasesViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) IBOutlet UITableView *useCaseListTable;
@property (strong, nonatomic) NSMutableArray *savedUseCases;

@end
