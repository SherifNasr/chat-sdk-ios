//
//  BFileChatOption.h
//  Pods
//
//  Created by Sherif Nasr on 13/9/2020.
//
//

#import <ChatSDK/BChatOption.h>

@class RXPromise;
@class BSelectFileAction;

@interface BFileChatOption : BChatOption {
    BSelectFileAction * _action;
}

@end
