//
//  UseCaseEvent.m
//  PictoUML
//
//  Created by TopeD on 10/20/15.
//  Copyright © 2015 Tope Daramola. All rights reserved.
//

#import "UseCaseEvent.h"

@implementation UseCaseEvent

- (instancetype) initWithName:(NSString *)event_name eventDescription:(NSString *)event_description eventVideoURL:(NSURL *)event_url andImage:(UIImage *)event_image {
    
    self = [super init];
    if (self) {
        
        self.e_name = event_name;
        self.e_description = event_description;
        self.e_image = event_image;
        self.e_videoURL = event_url;
        self.e_uuid = [[NSUUID UUID] UUIDString];
        
    }
    
    return self;
    
}


- (void)encodeWithCoder:(NSCoder *)coder {
    
    [coder encodeObject:self.e_name forKey:@"_name"];
    [coder encodeObject:self.e_description forKey:@"_description"];
    [coder encodeObject:self.e_image forKey:@"_image"];
    [coder encodeObject:self.e_videoURL forKey:@"_videoURL"];
    [coder encodeObject:self.e_uuid forKey:@"_uuid"];
    
}

- (id)initWithCoder:(NSCoder *)coder {
    self = [super init];
    if (self) {
        self.e_name = [coder decodeObjectForKey:@"_name"];
        self.e_description = [coder decodeObjectForKey:@"_description"];
        self.e_image = [coder decodeObjectForKey:@"_image"];
        self.e_videoURL = [coder decodeObjectForKey:@"_videoURL"];
        self.e_uuid = [coder decodeObjectForKey:@"_uuid"];
    }
    return self;
}

@end
