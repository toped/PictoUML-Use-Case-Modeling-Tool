//
//  UseCase.h
//  PictoUML
//
//  Created by TopeD on 10/20/15.
//  Copyright © 2015 Tope Daramola. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UseCase : NSObject

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSMutableArray *events;
@property (nonatomic, strong) NSString *uuid;

- (instancetype) initWithTitle:(NSString *)usecase_title;


@end
