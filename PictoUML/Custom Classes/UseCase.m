//
//  UseCase.m
//  PictoUML
//
//  Created by TopeD on 10/20/15.
//  Copyright © 2015 Tope Daramola. All rights reserved.
//

#import "UseCase.h"

@implementation UseCase

- (instancetype) initWithTitle:(NSString *)usecase_title{
    
    self = [super init];
    if (self) {
        
        self.title = usecase_title;
        self.uuid = [[NSUUID UUID] UUIDString];
    }
    
    return self;

}

- (void)encodeWithCoder:(NSCoder *)coder {
    
    [coder encodeObject:self.title forKey:@"_title"];
    [coder encodeObject:self.events forKey:@"_events"];
    [coder encodeObject:self.uuid forKey:@"_uuid"];

}

- (id)initWithCoder:(NSCoder *)coder {
    self = [super init];
    if (self) {
        self.title = [coder decodeObjectForKey:@"_title"];
        self.events = [coder decodeObjectForKey:@"_events"];
        self.uuid = [coder decodeObjectForKey:@"_uuid"];
    }
    return self;
}


@end
