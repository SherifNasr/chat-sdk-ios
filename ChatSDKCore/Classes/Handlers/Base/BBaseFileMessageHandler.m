//
//  BBaseFileMessageHandler.m
//  Pods
//
//  Created by Sherif Nasr on 14/9/2020.
//
//

#import "BBaseFileMessageHandler.h"
#import "BFileMessageCell.h"
#import <ChatSDK/Core.h>

@implementation BBaseFileMessageHandler

- (RXPromise *)sendMessageWithFile:(NSDictionary *)file andThreadEntityID:(NSString *)threadID {
        [BChatSDK.db beginUndoGroup];
    
        id<PMessage> message = [BChatSDK.db createMessageEntity];
    
        message.type = @(bMessageTypeFile);
        id<PThread> thread = [BChatSDK.db fetchEntityWithID:threadID withType:bThreadEntity];
        message.date = [NSDate date];
        message.userModel = BChatSDK.currentUser;
        [message setDelivered:@NO];
        [message setRead:@YES];
        message.flagged = @NO;

        [thread addMessage: message];

    NSString* name = file[bMessageText];
    NSString* mimeType = file[bMessageMimeType];
    NSURL* url = file[bMessageFileURL];
    
    NSData* fileData = [[NSFileManager defaultManager] contentsAtPath:url.path];
    
    return [BChatSDK.upload uploadFile:fileData  withName:name mimeType:mimeType].thenOnMain(^id(NSDictionary * info) {
 
        [message setMeta:@{bMessageFileURL: info[bFilePath] ? info[bFilePath] : @"",
                           bMessageText: info[bMessageText] ? info[bMessageText] : @"",
                           bMessageMimeType: info[bMessageMimeType] ? info[bMessageMimeType] : @""}];
        
        [BHookNotification notificationMessageDidUpload: message];

        return [BChatSDK.core sendMessage:message];
    }, Nil);

}


- (Class)cellClass {
    return BFileMessageCell.class;
}



@end
