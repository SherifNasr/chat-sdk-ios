//
//  BFileMessageCell.m
//  Chat SDK
//
//  Created by Sherif Nasr on 14/09/2020.
//  Copyright © 2020 Ashraf Abu Bakr. All rights reserved.
//

#import "BFileMessageCell.h"

#import <ChatSDK/Core.h>
#import <ChatSDK/PElmMessage.h>
#import <ChatSDK/UI.h>


@implementation BFileMessageCell

@synthesize imageView;
@synthesize label;
@synthesize mainView;

-(instancetype) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        imageView = [[UIImageView alloc] init];
        imageView.layer.cornerRadius = 10;
        imageView.clipsToBounds = YES;
        imageView.userInteractionEnabled = NO;

        label = [[UILabel alloc] init];
        label.font = BChatSDK.config.messageTextFont;

        mainView = [[UIView alloc] init];
        mainView.backgroundColor = UIColor.clearColor;
        
        [mainView addSubview:imageView];
        [mainView addSubview:label];
        
        [self.bubbleImageView addSubview:mainView];
        
        [self addconstarints];
    }
    return self;
}

-(void) addconstarints{
    // Width constraint
    [imageView addConstraint:[NSLayoutConstraint constraintWithItem:imageView
                                                          attribute:NSLayoutAttributeWidth
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:nil
                                                          attribute: NSLayoutAttributeNotAnAttribute
                                                         multiplier:1
                                                           constant:50]];

    // Height constraint
    [imageView addConstraint:[NSLayoutConstraint constraintWithItem:imageView
                                                          attribute:NSLayoutAttributeHeight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:nil
                                                          attribute: NSLayoutAttributeNotAnAttribute
                                                         multiplier:1
                                                           constant:50]];

    [imageView.superview addConstraint:[NSLayoutConstraint constraintWithItem:imageView
                                                          attribute:NSLayoutAttributeLeading
                                                          relatedBy:NSLayoutRelationEqual
                                                        toItem:imageView.superview
                                                          attribute: NSLayoutAttributeLeading
                                                         multiplier:1
                                                           constant:15]];

    [imageView.superview addConstraint:[NSLayoutConstraint constraintWithItem:imageView
                                                          attribute:NSLayoutAttributeCenterY
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:imageView.superview
                                                          attribute: NSLayoutAttributeCenterY
                                                         multiplier:1
                                                           constant:0]];

    [label.superview addConstraint:[NSLayoutConstraint constraintWithItem:label
                                                          attribute:NSLayoutAttributeCenterY
                                                          relatedBy:NSLayoutRelationEqual
                                                         toItem:label.superview
                                                          attribute: NSLayoutAttributeCenterY
                                                         multiplier:1
                                                           constant:0]];

    [imageView.superview addConstraint:[NSLayoutConstraint constraintWithItem:label
                                                          attribute:NSLayoutAttributeLeading
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:imageView
                                                          attribute: NSLayoutAttributeTrailing
                                                         multiplier:1
                                                           constant:8]];

    [label.superview addConstraint:[NSLayoutConstraint constraintWithItem:label.superview
                                                          attribute:NSLayoutAttributeTrailing
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:label
                                                          attribute: NSLayoutAttributeTrailing
                                                         multiplier:1
                                                           constant:8]];
}

-(void) setMessage: (id<PElmMessage>) message withColorWeight:(float)colorWeight {
    [super setMessage:message withColorWeight:colorWeight];
    
    // Get rid of the bubble for images
    self.bubbleImageView.image = Nil;
    NSString* fileName =  message.meta[bMessageText];
    NSString* fileURL =  message.meta[bMessageFileURL];
    NSString* mimetype =  message.meta[bMessageMimeType];

    [label setText:fileName];
    
    BOOL isDelivered = [message.delivered boolValue] || !message.senderIsMe;
    if (!isDelivered) {
        [self showActivityIndicator];
        imageView.alpha = 0.75;
        if(BChatSDK.config.messageTextColorMe){
            [label setTextColor:[BCoreUtilities colorWithHexString:BChatSDK.config.messageTextColorMe]];
        }
    }
    else {
        [self hideActivityIndicator];
        imageView.alpha = 1;
        if(BChatSDK.config.messageTextColorReply){
            [label setTextColor:[BCoreUtilities colorWithHexString:BChatSDK.config.messageTextColorReply]];
        }
    }
    
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    
    UIImage * placeholder = [UIImage imageWithData:message.placeholder];
    if (!placeholder) {
        placeholder = [NSBundle uiImageNamed:bDefaultPlaceholderImage];
    }
        
    [imageView sd_setImageWithURL:message.imageURL
                 placeholderImage:placeholder
                          options:SDWebImageLowPriority & SDWebImageScaleDownLargeImages
                        completed:nil];
}

-(UIView *) cellContentView {
    return self.mainView;
}

#pragma Cell sizing static methods

+(NSNumber *) messageContentHeight: (id<PElmMessage>) message maxWidth: (float) maxWidth {
    if (message.imageHeight > 0 && message.imageWidth > 0) {
        
        // We want the height to be less than the max height and more than the min height
        // First check if the calculated height is bigger than the max height, we take the smaller of these
        // Next we take the max of this value and the min value, this ensures the image is at least the min height
        return @(MAX(bMinMessageHeight, MIN([self messageContentWidth:message maxWidth:maxWidth].intValue * message.imageHeight / message.imageWidth, bMaxMessageHeight)));
    }
    return @(0);
}

+(NSValue *) messageBubblePadding: (id<PElmMessage>) message {
    return [NSValue valueWithUIEdgeInsets:UIEdgeInsetsMake(3.0, 3.0, 3.0, 3.0)];
}

@end
