//
//  BFileMessageCell.h
//  Chat SDK
//
//  Created by Sherif Nasr on 14/09/2020.
//  Copyright © 2020 Ashraf Abu Bakr. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BMessageCell.h"

@interface BFileMessageCell : BMessageCell

@property (nonatomic, readwrite) UIImageView * imageView;
@property (nonatomic, readwrite) UILabel * label;
@property (nonatomic, readwrite) UIView * mainView;

@end
