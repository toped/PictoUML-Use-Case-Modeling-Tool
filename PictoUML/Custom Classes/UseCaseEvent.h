//
//  UseCaseEvent.h
//  PictoUML
//
//  Created by TopeD on 10/20/15.
//  Copyright © 2015 Tope Daramola. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface UseCaseEvent : NSObject

@property (nonatomic, strong) NSString *e_name;
@property (nonatomic, strong) NSString *e_description;
@property (nonatomic, strong) UIImage *e_image;
@property (nonatomic, strong) NSURL *e_videoURL;
@property (nonatomic, strong) NSString *e_uuid;

- (instancetype) initWithName:(NSString *)event_name eventDescription:(NSString *)event_description eventVideoURL:(NSURL *)event_url andImage:(UIImage *)event_image;

@end
