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
             if (object)
             {
                 if ([target respondsToSelector:selector])
                     [target performSelectorOnMainThread:selector withObject:object waitUntilDone:YES];
                 else
                     NSLog(@"Error selector non declared in the target passed as parameters");
             }
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

+ (void) updateEvent:(NSString*)eventId target:(id)target selector:(SEL)selector data:(NSDictionary*)data
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
        if ([target respondsToSelector:selector])
            [target performSelectorOnMainThread:selector withObject:lRet waitUntilDone:YES];
        else
            NSLog(@"Error selector non declared in the target passed as parameters");
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

+ (void) fetchNewEvent:(id)target selector:(SEL)selector
{
    NSBlockOperation *operation = [[NSBlockOperation alloc] init];
    __block NSArray          *lRet;
    
    [operation setCompletionBlock:^{
        if ([target respondsToSelector:selector])
            [target performSelectorOnMainThread:selector withObject:lRet waitUntilDone:YES];
        else
            NSLog(@"Error selector non declared in the target passed as parameters");
        
    }];
    //TODO: fetch also on the server if there is new event
    //[query fromLocalDatastore];
    
    NSBlockOperation *fetchEventsOp = [[NSBlockOperation alloc] init];
    [fetchEventsOp addExecutionBlock:^{
        
        NSError *error;
        PFQuery      *query1 = [[PFQuery alloc] initWithClassName:@"Event"];
        [query1 whereKey:@"receivinguser" equalTo:[PFUser currentUser].username];
        PFQuery      *query2 = [[PFQuery alloc] initWithClassName:@"Event"];
        [query2 whereKey:@"sendinguser" equalTo:[PFUser currentUser].username];
        NSLog(@"Current user:%@", [PFUser currentUser]);
        PFQuery *query = [PFQuery orQueryWithSubqueries:@[query1,query2]];
        [query orderByAscending:@"createdDate"];
        
        NSArray *results = [query findObjects:&error];
        if (error)
            NSLog(@"Error fetching data in fetchLocalEvents: %@", error);
        else
        {
            for (int i = 0; i < results.count; ++i)
            {
                Event  *event = [results objectAtIndex:i];
                
                [event pin];
                [event saveEventually];
            }
            [query fromLocalDatastore];
            lRet = [query findObjects];
        }
    }];
    [operation addDependency:fetchEventsOp];
    [ManagedParseUser addOperationToQueue:fetchEventsOp];
    [ManagedParseUser addOperationToQueue:operation];
}



+ (void) fetchAllEvents:(id)target selector:(SEL)selector
{
    NSBlockOperation *operation = [[NSBlockOperation alloc] init];
    __block NSArray          *lRet;
    
    [operation setCompletionBlock:^{
        if ([target respondsToSelector:selector])
            [target performSelectorOnMainThread:selector withObject:lRet waitUntilDone:YES];
        else
            NSLog(@"Error selector non declared in the target passed as parameters");
        
    }];
    
    NSBlockOperation *fetchEventsOp = [[NSBlockOperation alloc] init];
    [fetchEventsOp addExecutionBlock:^{
        
        NSError *error;
        
        PFQuery *query = [ManagedParseUser getPFQueryForEvent];
        
        [query orderByDescending:@"createdAt"];
        
        [query fromLocalDatastore];
        NSArray *localResults = [query findObjects:&error];
        
        [PFObject fetchAllIfNeededInBackground:localResults block:^(NSArray *objects, NSError *error) {
           if (error)
               NSLog(@"error fetching all in background if needed fetchallevent");
            else
            {
                [PFObject pinAllInBackground:objects block:^(BOOL succeeded, NSError *error) {
                    
                }];
            }
            
        }];
        for (PFObject *o in localResults)
        {
            //[o[@"sendinguser"] isEqualToString:[PFUser currentUser].username] &&
            if (o[@"isReceived"] == [NSNumber numberWithBool:NO])
            {
                NSBlockOperation *fetchToServer = [[NSBlockOperation alloc] init];
                
                [fetchToServer addExecutionBlock:^{
                    [o fetch];
                    [o pin];
                }];
                [ManagedParseUser addOperationToQueue:fetchToServer];
                [operation addDependency:fetchToServer];
            }
        }
        if (error)
            NSLog(@"Error fetching data in fetchLocalEvents: %@", error);
        error = nil;
        NSMutableArray *idsToExclude = [[NSMutableArray alloc] init];
        NSArray *remoteResults = nil;
        PFQuery *queryOnServer = [ManagedParseUser getPFQueryForEvent];
        
        [queryOnServer orderByDescending:@"createdAt"];
        
        for (int i = 0; i < localResults.count; ++i)
            [idsToExclude addObject:[[localResults objectAtIndex:i] objectId]];
        if (idsToExclude.count > 0)
            [queryOnServer whereKey:@"objectId" notContainedIn:idsToExclude];
        remoteResults = [queryOnServer findObjects:&error];
        if (error)
            NSLog(@"Error %@", error);
        NSLog(@"Remote: %@", remoteResults);
        for (int i = 0; i < remoteResults.count; ++i)
        {
            Event  *event = [remoteResults objectAtIndex:i];
            NSLog(@"Event: %@", event);
            NSBlockOperation *pinEvent  = [[NSBlockOperation alloc] init];
            
            [pinEvent addExecutionBlock:^{
                [event pin];
                [event saveEventually];
            }];
            [ManagedParseUser addOperationToQueue:pinEvent];
            [operation addDependency:pinEvent];
        }
    }];
    [operation addExecutionBlock:^{
        PFQuery      *query1 = [[PFQuery alloc] initWithClassName:@"Event"];
        [query1 whereKey:@"receivinguser" equalTo:[PFUser currentUser].username];
        
        PFQuery      *query2 = [[PFQuery alloc] initWithClassName:@"Event"];
        [query2 whereKey:@"sendinguser" equalTo:[PFUser currentUser].username];
        
        PFQuery     *query3 = [[PFQuery alloc] initWithClassName:@"Event"];
        [query3 whereKey:@"usersConcerned" equalTo:[PFUser currentUser].username];
        
        NSLog(@"Current user:%@", [PFUser currentUser]);
        PFQuery *query = [PFQuery orQueryWithSubqueries:@[query1,query2, query3]];
        [query orderByDescending:@"createdAt"];
        
        [query fromLocalDatastore];
        lRet = [query findObjects];
        //NSLog(@"Lret: %@", lRet);
    }];

    
    [operation addDependency:fetchEventsOp];
    [ManagedParseUser addOperationToQueue:fetchEventsOp];
    [ManagedParseUser addOperationToQueue:operation];
}


+ (void) fetchLocalEvents:(id)target selector:(SEL)selector
{
    NSBlockOperation *operation = [[NSBlockOperation alloc] init];
    __block NSArray          *lRet;
    
    [operation setCompletionBlock:^{
        if ([target respondsToSelector:selector])
            [target performSelectorOnMainThread:selector withObject:lRet waitUntilDone:YES];
        else
            NSLog(@"Error selector non declared in the target passed as parameters");
    }];
    
    [operation addExecutionBlock:^{
        PFQuery      *query1 = [[PFQuery alloc] initWithClassName:@"Event"];
        [query1 whereKey:@"receivinguser" equalTo:[PFUser currentUser].username];
        
        PFQuery      *query2 = [[PFQuery alloc] initWithClassName:@"Event"];
        [query2 whereKey:@"sendinguser" equalTo:[PFUser currentUser].username];
        
        PFQuery     *query3 = [[PFQuery alloc] initWithClassName:@"Event"];
        [query3 whereKey:@"usersConcerned" equalTo:[PFUser currentUser].username];
        
        NSLog(@"Current user:%@", [PFUser currentUser]);
        PFQuery *query = [PFQuery orQueryWithSubqueries:@[query1,query2]];
        [query orderByDescending:@"createdAt"];
        
        [query fromLocalDatastore];
        lRet = [query findObjects];
        //NSLog(@"Lret: %@", lRet);
    }];
    [ManagedParseUser addOperationToQueue:operation];
}

+ (void) createEvent:(NSArray*)userConcerned comment:(NSString*)comment groupName:(NSString*)groupName address:(MYGoogleAddress*)address success:(void(^)())success
{
    NSBlockOperation *mainOp = [[NSBlockOperation alloc] init];
    
    [mainOp setCompletionBlock:^{
        success();
    }];
    Event   *event = [[Event alloc] initWithClassName:@"Event"];
    [event addUniqueObject:@"empty" forKey:@"usersAccepted"];
    [event addUniqueObject:@"empty" forKey:@"usersDeclined"];
    if (userConcerned.count > 1)
    {
        event.usersConcerned = userConcerned;
        event.groupName = groupName;
    }
    else
        event.receivinguser = [userConcerned objectAtIndex:0];
    [mainOp addExecutionBlock:^{
        
        NSError *error;
        
        if (address)
        {
            [address save:&error];
            if (error)
                NSLog(@"error saving address: %@", error);
            else
            {
                event.mygoogleaddress = address;
                [address saveEventually];
            }
        }
        event.comment = comment;
        event.sendinguser = [PFUser currentUser].username;
        event.isReceived = NO;
        event.isAccepted = NO;
        error = nil;
        [event save:&error];
        if (error)
            NSLog(@"Error saving event: %@", error);
        else
            [event pin];
        NSMutableDictionary *data = [[NSMutableDictionary alloc] init];
        NSString *alert = [NSString stringWithFormat:@"%@ just sent you an event !",[PFUser currentUser].username];
        [data setObject:alert forKey:@"alert"];
        [data setObject:@"createEvent" forKey:@"eventType"];
        [data setObject:@"default" forKey:@"sound"];
        [data setObject:event.objectId forKey:@"eventId"];
        [ManagedParseUser sendNotificationPushSync:userConcerned
                                              data:data];
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
