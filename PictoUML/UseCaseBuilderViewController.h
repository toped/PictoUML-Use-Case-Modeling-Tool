//
//  UseCaseBuilderViewController.h
//  PictoUML
//
//  Created by TopeD on 10/15/15.
//  Copyright © 2015 Tope Daramola. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UseCase.h"
#import "UseCaseFlow.h"
#import "UseCaseEvent.h"
#import "EventInputViewController.h"
#import "PlayBackViewController.h"

@interface UseCaseBuilderViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, EventInputDelegate>

@property (strong, nonatomic) IBOutlet UILabel *useCaseTitleLabel;
@property (nonatomic, strong) IBOutlet UITableView *useCaseTable;

@property (nonatomic, strong) UseCase *currentUseCase;
@property (nonatomic, strong) NSMutableArray *useCaseEvents;



@end
