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
        
        imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
        imageView.layer.cornerRadius = 10;
        imageView.clipsToBounds = YES;
        imageView.userInteractionEnabled = NO;

        label = [[UILabel alloc] init];
        label.font = BChatSDK.config.messageTextFont;
        label.backgroundColor = UIColor.clearColor;
        label.font = [UIFont systemFontOfSize:bDefaultFontSize];
        if(BChatSDK.config.messageTextFont) {
            label.font = BChatSDK.config.messageTextFont;
        }

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
    [mainView setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    [imageView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [imageView addConstraint:[NSLayoutConstraint constraintWithItem:imageView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute: NSLayoutAttributeNotAnAttribute multiplier:1 constant:50]];
    [imageView addConstraint:[NSLayoutConstraint constraintWithItem:imageView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute: NSLayoutAttributeNotAnAttribute multiplier:1 constant:50]];

    [imageView.superview addConstraint:[NSLayoutConstraint constraintWithItem:imageView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:imageView.superview attribute: NSLayoutAttributeLeading multiplier:1 constant:0]];
    [imageView.superview addConstraint:[NSLayoutConstraint constraintWithItem:imageView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:imageView.superview attribute: NSLayoutAttributeCenterY multiplier:1 constant:0]];
    
    [label setTranslatesAutoresizingMaskIntoConstraints:NO];
    [label.superview addConstraint:[NSLayoutConstraint constraintWithItem:label attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:imageView attribute: NSLayoutAttributeTrailing multiplier:1 constant:5]];
    
    [label.superview addConstraint:[NSLayoutConstraint constraintWithItem:label.superview attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:label attribute: NSLayoutAttributeTrailing multiplier:1 constant:0]];
    
    [label.superview addConstraint:[NSLayoutConstraint constraintWithItem:label attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:label.superview attribute: NSLayoutAttributeCenterY multiplier:1 constant:0]];
    
    [label.superview addConstraint:[NSLayoutConstraint constraintWithItem:label attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:label.superview attribute: NSLayoutAttributeTop multiplier:1 constant:0]];
    
    [label.superview addConstraint:[NSLayoutConstraint constraintWithItem:label attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:label.superview attribute: NSLayoutAttributeBottom multiplier:1 constant:0]];

    [self.bubbleImageView addConstraint:[NSLayoutConstraint constraintWithItem:mainView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.bubbleImageView attribute: NSLayoutAttributeLeading multiplier:1 constant:5]];
    [self.bubbleImageView addConstraint:[NSLayoutConstraint constraintWithItem:mainView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.bubbleImageView attribute: NSLayoutAttributeTop multiplier:1 constant:5]];
    [self.bubbleImageView addConstraint:[NSLayoutConstraint constraintWithItem:mainView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.bubbleImageView attribute: NSLayoutAttributeBottom multiplier:1 constant:-5]];
    [self.bubbleImageView addConstraint:[NSLayoutConstraint constraintWithItem:mainView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.bubbleImageView attribute: NSLayoutAttributeTrailing multiplier:1 constant:-5]];
}

-(void) setMessage: (id<PElmMessage>) message withColorWeight:(float)colorWeight {
    [super setMessage:message withColorWeight:colorWeight];
    
    NSString* fileName =  message.meta[bMessageText];
//    NSString* mimetype =  message.meta[bMessageMimeType];

    label.text = fileName;

    if(BChatSDK.config.messageTextColorMe && message.userModel.isMe) {
        label.textColor = [BCoreUtilities colorWithHexString:BChatSDK.config.messageTextColorMe];
    } else if(BChatSDK.config.messageTextColorReply && !message.userModel.isMe) {
        label.textColor = [BCoreUtilities colorWithHexString:BChatSDK.config.messageTextColorReply];
    } else {
        label.textColor = [BCoreUtilities colorWithHexString:bDefaultTextColor];
    }

    imageView.contentMode = UIViewContentModeScaleAspectFit;
    [imageView setImage:[NSBundle imageNamed:@"icn_50_github@2x.png" bundle:NSBundle.mainBundle.bundlePath]];
    [self setNeedsLayout];
    [self layoutIfNeeded];
}

-(UIView *) cellContentView {
    return self.mainView;
}

#pragma Cell sizing static methods

+(NSNumber *) messageContentHeight: (id<PElmMessage>) message maxWidth: (float) maxWidth {
    return @(MAX(bMinMessageHeight,[self getText: message.meta[bMessageText] heightWithFont:[UIFont systemFontOfSize:bDefaultFontSize] withWidth:[self messageContentWidth:message maxWidth:maxWidth].floatValue]));
}

+(NSNumber *) messageContentWidth: (id<PElmMessage>) message maxWidth: (float) maxWidth {
    return @(50 + 15 + [self textWidth:message.meta[bMessageText] maxWidth:maxWidth]); // 50 for image width && 25 for padding
}

+(NSValue *) messageBubblePadding: (id<PElmMessage>) message {
    return [NSValue valueWithUIEdgeInsets:UIEdgeInsetsMake(5.0, 5.0, 5.0, 5.0)];
}

#pragma Text size

+(float) getText: (NSString *) text heightWithFont: (UIFont *) font withWidth: (float) width {
    return [text boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX)
                              options:NSStringDrawingUsesLineFragmentOrigin
                           attributes:@{NSFontAttributeName: font}
                              context:Nil].size.height;
}

+(float) textWidth: (NSString *) text maxWidth: (float) maxWidth {
    if (text) {
        UIFont * font = [UIFont systemFontOfSize:bDefaultFontSize];
        if (font) {
            return [text boundingRectWithSize:CGSizeMake(maxWidth, CGFLOAT_MAX)
                                      options:NSStringDrawingUsesLineFragmentOrigin
                                   attributes:@{NSFontAttributeName: font}
                                      context:Nil].size.width;
        }
    }
    return 0;
}
@end
