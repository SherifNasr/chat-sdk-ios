//
//  BFileChatOption.m
//  Pods
//
//  Created by Sherif Nasr on 13/9/2020.
//
//

#import "BFileChatOption.h"
#import <ChatSDK/Core.h>
#import <ChatSDK/UI.h>

@implementation BFileChatOption

-(UIImage *) icon {
    return [NSBundle uiImageNamed:@"icn_60_file.png"];
}

-(NSString *) title {
    return [NSBundle t:bFile];
}

- (RXPromise * ) execute: (UIViewController *) viewController threadEntityID: (NSString *) threadEntityID {
    if(_action == Nil) {
        _action = [[BSelectFileAction alloc] initWithViewController: viewController];
    }
    return [_action execute].thenOnMain(^id(id fileInfo) {
        return [BChatSDK.fileMessage sendMessageWithFile:fileInfo andThreadEntityID: threadEntityID];
    }, Nil);
}

@end
