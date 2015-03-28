//
//  ManagedParseUser.m
//  whoparty
//
//  Created by Werck Ayrton on 03/03/2015.
//  Copyright (c) 2015 Nyu Web Developpement. All rights reserved.
//

#import "ManagedParseUser.h"
#import "WPHelperConstant.h"
#import "Event.h"

@implementation ManagedParseUser

- (id)init
{
    self = [super init];
    if (self)
    {
        //On peut considérer un operation queue comme un pool de thread
        self.operationQueue = [[NSOperationQueue alloc] init];
        //On definit le maximum de thread par pool (par default j'ai mis le max que apple accepte
        [self.operationQueue setMaxConcurrentOperationCount:NSOperationQueueDefaultMaxConcurrentOperationCount];
    }
    return self;
}


+ (id) sharedInstance
{
    static ManagedParseUser    *sharedInstance = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}


+ (void) userWithUserName:(NSString*) username completionBlock:(void(^)(PFObject*))completion
{
    PFQuery *query = [[PFQuery alloc] initWithClassName:@"_User"];
    
    [query whereKey:@"username" equalTo:username];
    [query fromLocalDatastore];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error)
    {
        if (objects && objects.count == 1)
        {
            PFObject *user = [objects objectAtIndex:0];
            [user fetchIfNeededInBackgroundWithBlock:^(PFObject *object, NSError *error) {
                completion(object);
            }];
        }
        else
        {
            PFQuery *queryOnline = [[PFQuery alloc] initWithClassName:@"_User"];
            
            [queryOnline whereKey:@"username" equalTo:username];
            [queryOnline findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error)
             {
                if (objects && objects.count == 1)
                {
                    PFObject *user = [objects objectAtIndex:0];
                    [user fetchInBackgroundWithBlock:^(PFObject *object, NSError *error) {
                        if (error)
                            completion(nil);
                        else
                        {

                            if (![object objectForKey:@"profilePictureFile"] && [object objectForKey:@"profilePicture"])
                            {
                                    NSURL *url = [NSURL URLWithString:[object objectForKey:@"profilePicture"]];
                                    NSData *data = [NSData dataWithContentsOfURL:url];
                                    PFFile *picture = [PFFile fileWithData:data];
                                    [user setObject:picture forKey:@"profilePictureFile"];
                                    [user setObject:data forKey:@"test"];
                                    [user saveInBackground];
                                    [user pinInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                                        completion(object);
                                    }];
                            }
                            else
                                completion(object);
                        }
                    }];
                }
                else
                    completion(nil);
             }];
        }
        completion(nil);
    }];
    
}
    
+ (void) addOperationToQueue:(NSOperation*) op
{
    ManagedParseUser   *client = [ManagedParseUser sharedInstance];
    
    [client.operationQueue addOperation:op];
}


+ (void)fetchFriendsListForUser:(PFUser*) user target:(id)target selector:(SEL)selector
{
    PFQuery      *query = [[PFQuery alloc] initWithClassName:@"_User"];
    
    
    
    [query selectKeys:@[@"friendsId"]];
    [query whereKey:@"objectId" equalTo:user.objectId];
    [query findObjectsInBackgroundWithBlock:^(NSArray *results, NSError *error) {
        
        PFUser *user = (PFUser*)[results objectAtIndex:0];
        NSArray *friendsId = [user objectForKey:@"friendsId"];
        
        if ([target respondsToSelector:selector])
            [target performSelectorOnMainThread:selector withObject:friendsId waitUntilDone:YES];
        else
            NSLog(@"Error selector non declared in the target passed as parameters");
    }];
}

+ (void) fetchGoogleAddress:(MYGoogleAddress*)googleAddressTofetch target:(id)target selector:(SEL)selector
{
    if (!googleAddressTofetch)
    {
        if ([target respondsToSelector:selector])
            [target performSelectorOnMainThread:selector withObject:nil waitUntilDone:YES];
        else
            NSLog(@"Error selector non declared in the target passed as parameters");
    }
    [googleAddressTofetch fetchFromLocalDatastoreInBackgroundWithBlock:^(PFObject *object, NSError *error)
     {
         if (error)
         {
             NSLog(@"WPReceiveEventViewController-viewdidload-Error fetchinglocaldatastore trying server mygoogleaddress, error: %@", error);
             [googleAddressTofetch fetchInBackgroundWithBlock:^(PFObject *object, NSError *error)
              {
                  if (error)
                      NSLog(@"WPReceiveEventViewController-viewdidload-Error fetching online mygoogleaddress, error: %@", error);
                  else
                      [object pinInBackground];
                  if ([target respondsToSelector:selector])
                      [target performSelectorOnMainThread:selector withObject:object waitUntilDone:YES];
                  else
                      NSLog(@"Error selector non declared in the target passed as parameters");
              }];
         }
         else
         {
             if ([target respondsToSelector:selector])
                 [target performSelectorOnMainThread:selector withObject:object waitUntilDone:YES];
             else
                 NSLog(@"Error selector non declared in the target passed as parameters");
         }
     }];
}

+ (void)fetchFriendUserByUsername:(NSString*)username target:(id)target selector:(SEL)selector
{
    PFQuery      *query = [[PFQuery alloc] initWithClassName:@"_User"];
    
    
    [query selectKeys:@[@"username", @"friendsId"]];
    [query whereKey:@"username" equalTo:username];
    [query getFirstObjectInBackgroundWithBlock:^(PFObject *results, NSError *error) {
        
        if (results)
        {
            NSLog(@"user.username: %@", results[@"username"]);
        }
        else
            NSLog(@"No User found");
        if ([target respondsToSelector:selector])
            [target performSelectorOnMainThread:selector withObject:results waitUntilDone:YES];
        else
            NSLog(@"Error selector non declared in the target passed as parameters");
    }];
}

+ (void) sendNotificationPush:(NSString*)usernameDest data:(NSDictionary*)data completionBlock:(void(^)())success
{
    NSBlockOperation    *op = [[NSBlockOperation alloc] init];
    
    [op addExecutionBlock:^{
        NSError     *error;
        PFQuery *queryUser = [PFQuery queryWithClassName:@"_User"];
        
        [queryUser fromLocalDatastore];
        [queryUser whereKey:@"username" equalTo:usernameDest];
        PFObject *userDest = [queryUser getFirstObject:&error];
        if (error)
        {
            NSLog(@"error when fetching user fromlocal trying remotely- sendpushnotifmanageparseuser error: %@", error);
            error = nil;
            PFQuery *queryUserRemotely = [PFQuery queryWithClassName:@"_User"];
            [queryUserRemotely whereKey:@"username" equalTo:usernameDest];
            userDest = [queryUserRemotely getFirstObject:&error];
            [userDest pinInBackground];
        }
        if (!error)
        {
            NSString *channel = [CHANNELUSERPREFIX stringByAppendingString:userDest.objectId];
            
            error = nil;
            NSMutableDictionary *test = [[NSMutableDictionary alloc] init];
            [test setObject:channel forKey:@"channel"];
            [test setObject:data forKey:@"data"];
            [PFCloud callFunction:@"sendPush" withParameters:test error:&error];
            if (error)
                NSLog(@"Error cloud: %@", error);
            else
                NSLog(@"Successfully sent notification");
        }
        else
            NSLog(@"Error fetching user remotely notif not sent -sendpushnotifmanageparseuser error: %@", error);
    }];
    
    [op setCompletionBlock:^{
        success();
    }];
    [ManagedParseUser addOperationToQueue:op];
}

+ (void) sendNotificationPushSync:(NSArray*)userConcerned data:(NSDictionary*)data
{
    
    
    for (NSString *usernameDest in userConcerned)
    {
        NSError     *error;
        PFQuery *queryUser = [PFQuery queryWithClassName:@"_User"];
        
        [queryUser fromLocalDatastore];
        [queryUser whereKey:@"username" equalTo:usernameDest];
        PFObject *userDest = [queryUser getFirstObject:&error];
        if (error)
        {
            NSLog(@"error when fetching user fromlocal trying remotely- sendpushnotifmanageparseuser error: %@", error);
            error = nil;
            PFQuery *queryUserRemotely = [PFQuery queryWithClassName:@"_User"];
            [queryUserRemotely whereKey:@"username" equalTo:usernameDest];
            userDest = [queryUserRemotely getFirstObject:&error];
            [userDest pinInBackground];
        }
        if (!error)
        {
            NSString *channel = [CHANNELUSERPREFIX stringByAppendingString:userDest.objectId];
            
            error = nil;
            NSMutableDictionary *test = [[NSMutableDictionary alloc] init];
            [test setObject:channel forKey:@"channel"];
            [test setObject:data forKey:@"data"];
            [PFCloud callFunction:@"sendPush" withParameters:test error:&error];
            if (error)
                NSLog(@"Error cloud: %@", error);
            else
                NSLog(@"Successfully sent notification");
        }
        else
            NSLog(@"Error fetching user remotely notif not sent -sendpushnotifmanageparseuser error: %@", error);
    }
}



#pragma mark ->Event

+ (void) updateEventWithCompletionBlock:(NSString*)eventId success:(void(^)(PFObject *event))success data:(NSDictionary*)data
{
    NSBlockOperation *op = [[NSBlockOperation alloc] init];
    __block  PFObject *lRet;
    
    [op addExecutionBlock:^{
        PFQuery      *query = [[PFQuery alloc] initWithClassName:@"Event"];
        [query fromLocalDatastore];
        [query whereKey:@"objectId" equalTo:eventId];
        PFObject *eventObject = [query getFirstObject];
        
        for (NSString *key in [data allKeys])
            [eventObject setObject:[data objectForKey:key] forKey:key];
        [eventObject pin];
        lRet = eventObject;
    }];
    
    [op setCompletionBlock:^{
        success(lRet);
    }];
    [ManagedParseUser addOperationToQueue:op];
}

+ (PFQuery*) getPFQueryForEvent
{
    PFQuery      *query1 = [[PFQuery alloc] initWithClassName:@"Event"];
    [query1 whereKey:@"receivinguser" equalTo:[PFUser currentUser].username];
    
    PFQuery      *query2 = [[PFQuery alloc] initWithClassName:@"Event"];
    [query2 whereKey:@"sendinguser" equalTo:[PFUser currentUser].username];
    
    PFQuery     *query3 = [[PFQuery alloc] initWithClassName:@"Event"];
    [query3 whereKey:@"usersConcerned" equalTo:[PFUser currentUser].username];
    
    PFQuery *query = [PFQuery orQueryWithSubqueries:@[query1,query2, query3]];
    
    
    return query;
}

+ (void) fetchAllEvents:(id)target selector:(SEL)selector
{
    NSBlockOperation *operation = [[NSBlockOperation alloc] init];
    
    [operation addExecutionBlock:^{
        PFQuery *query = [ManagedParseUser getPFQueryForEvent];
        
        [query orderByDescending:@"createdAt"];
        [query fromLocalDatastore];
        //Find locals objects
        [query findObjectsInBackgroundWithBlock:^(NSArray *objectsLocal, NSError *error) {
            
            //Update GUI with existing objects
            if ([target respondsToSelector:selector])
                [target performSelectorOnMainThread:selector withObject:objectsLocal waitUntilDone:YES];
            else
                NSLog(@"Error selector non declared in the target passed as parameters");
            //Update locals objects
            [PFObject fetchAllInBackground:objectsLocal block:^(NSArray *objectsLocalUpdated, NSError *error) {
                if (error)
                    NSLog(@"error fetching all in background fetchallevent");
                else
                {   //Save new updated objects
                    [PFObject pinAllInBackground:objectsLocalUpdated block:^(BOOL succeeded, NSError *error) {
                        if (succeeded)
                        {
                            //Find new events and exclude already fetched one
                            NSMutableArray *idsToExclude = [[NSMutableArray alloc] init];
                            for (int i = 0; i < objectsLocalUpdated.count; ++i)
                                [idsToExclude addObject:[[objectsLocalUpdated objectAtIndex:i] objectId]];
                            //setup query
                            PFQuery *queryOnServer = [ManagedParseUser getPFQueryForEvent];
                            if (idsToExclude.count > 0)
                                [queryOnServer whereKey:@"objectId" notContainedIn:idsToExclude];
                            [queryOnServer orderByDescending:@"createdAt"];
                            //Find new event
                            __block NSArray *objectToMerge = [NSArray arrayWithArray:objectsLocalUpdated];
                            [queryOnServer findObjectsInBackgroundWithBlock:^(NSArray *objectsServer, NSError *error) {
                                
                                if (objectsServer.count > 0)
                                {
                                    //Save new event if there is new event
                                    [PFObject pinAllInBackground:objectsServer block:^(BOOL succeeded, NSError *error) {
                                        //Update gui with new event
                                        NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"createdAt" ascending:NO];
                                        NSArray *sortDescriptor = [NSArray arrayWithObject:sort];
                                        
                                        objectToMerge = [objectToMerge arrayByAddingObjectsFromArray:objectsServer];
                                        objectToMerge = [objectToMerge sortedArrayUsingDescriptors:sortDescriptor];
                                        
                                        if ([target respondsToSelector:selector])
                                            [target performSelectorOnMainThread:selector withObject:objectToMerge waitUntilDone:YES];
                                        else
                                            NSLog(@"Error selector non declared in the target passed as parameters");
                                    }];
                                    
                                }
                            }];
                        }
                    }];
                }
                
            }];
        }];
    }];
    [ManagedParseUser addOperationToQueue:operation];
}


+ (void) fetchLocalEvents:(id)target selector:(SEL)selector
{
    PFQuery *query = [ManagedParseUser getPFQueryForEvent];
    [query orderByDescending:@"createdAt"];
    
    [query fromLocalDatastore];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        
        if ([target respondsToSelector:selector])
            [target performSelectorOnMainThread:selector withObject:objects waitUntilDone:YES];
        else
            NSLog(@"Error selector non declared in the target passed as parameters");
    }];
}

+ (void) fetchEvent:(PFObject*)event completionBlock:(void(^)(PFObject* obj))completionBlock
{
    [event fetchInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        [object pinInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            completionBlock(object);
        }];
    }];
}


+ (void) createEvent:(PFObject*)event success:(void(^)())success
{
    NSBlockOperation *mainOp = [[NSBlockOperation alloc] init];
    
    [mainOp setCompletionBlock:^{
        success();
    }];
    
    [mainOp addExecutionBlock:^
    {
        [event[@"mygoogleaddress"] saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (error)
                NSLog(@"fail saving event google address:%@", error);
            
            [event saveEventually:^(BOOL succeeded, NSError *error) {
                if (succeeded)
                    NSLog(@"Successed save new event");
                else
                    NSLog(@"Error saving new event: %@", error);
                NSMutableDictionary *data = [[NSMutableDictionary alloc] init];
                NSString *alert = [NSString stringWithFormat:@"%@ just sent you an event !",[PFUser currentUser].username];
                [data setObject:alert forKey:@"alert"];
                [data setObject:@"createEvent" forKey:@"eventType"];
                [data setObject:@"default" forKey:@"sound"];
                [data setObject:event.objectId forKey:@"eventId"];
                [ManagedParseUser sendNotificationPushSync:event[@"usersConcerned"]
                                                      data:data];
                success();
                
            }];
    }];
        
    }];
    [ManagedParseUser addOperationToQueue:mainOp];
}

+ (void) sendErrorReport:(NSError*)error
{
    if (error)
    {
        NSString *codeString = [NSString stringWithFormat:@"%d", [error code]];
        [PFAnalytics trackEvent:@"error" dimensions:@{ @"code": codeString }];
    }
}

@end
