//
//  WPLoginViewController.m
//  whoparty
//
//  Created by Werck Ayrton on 01/03/2015.
//  Copyright (c) 2015 Nyu Web Developpement. All rights reserved.
//

#import <Parse/Parse.h>
#import "WPLoginViewController.h"
#import "WPHelperConstant.h"
#import "AlertView.h"
#import <ParseFacebookUtils/PFFacebookUtils.h>

#define LEFTVIEWWIDTH 25

@interface WPLoginViewController ()

- (IBAction)login:(id)sender;
- (IBAction)registerUser:(id)sender;
- (IBAction)loginFaceBook:(id)sender;


@end

@implementation WPLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receivePushNotification:) name:HASRECEIVEDPUSHNOTIFICATION object:nil];
    //TO DELETE
    PFUser *user = [PFUser currentUser];
    if (user)
    {
        self.textFieldLogin.text = user.username;
    }
    else
    {
        self.textFieldPassword1.text = @"";
        self.textFieldLogin.text = @"";
    }
    // Do any additional setup after loading the view.
}


#pragma mark ->Receive Notification Push

- (void) receivePushNotification:(NSDictionary*) userInfo
{
    NSLog(@"Login-ViewController-userinfo receive push notification: %@", userInfo);
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    PFUser *user = [PFUser currentUser];
    if (user)
    {
        self.textFieldLogin.text = user.username;
        self.textFieldPassword1.text = user.password;
        PFInstallation *currentInstallation = [PFInstallation currentInstallation];
        NSString *channel = [CHANNELUSERPREFIX stringByAppendingString:user.objectId];
        [currentInstallation setChannels:[NSArray arrayWithObject:channel]];
        [currentInstallation saveInBackground];
        
        [self performSegueWithIdentifier:@"loginSuccess" sender:self];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    NSLog(@"memory login");
    // Dispose of any resources that can be recreated.
}

- (void) registering
{
    self.hud.labelText = @"Registering";
    
    NSString *error = nil;
    if ((error = [super validateFormRegister]))
    {
        FUIAlertView *alertView = [AlertView getDefaultAlertVIew:@"Oops !" message:error];
        
        [alertView show];
        return;
    }
    else
    {
        self.hud.hidden = FALSE;
        PFUser *user = [[PFUser alloc] init];
        
        user.email = self.textFieldEmail.text;
        user.username = self.textFieldLogin.text;
        user.password = self.textFieldPassword1.text;
        [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error)
         {
             self.hud.hidden = TRUE;
             if (error)
                 [super connectionFailed:[error localizedDescription]];
             else
             {
                 NSLog(@"User successfully signup");
                 //RegisterChannel for this user
                 PFInstallation *currentInstallation = [PFInstallation currentInstallation];
                 currentInstallation.channels = @[ @"global", [CHANNELUSERPREFIX stringByAppendingString:user.objectId]];
                 [currentInstallation saveEventually];
                 // [WPHelperConstant saveUserCredentialsToKeyChain:user.username password:user.password];
                 [self performSegueWithIdentifier:@"loginSuccess" sender:self];
             }
         }];
    }
}


- (IBAction)loginWithFB:(id)sender
{
    NSArray *permissionsArray = @[ @"user_about_me", @"user_relationships", @"user_birthday", @"user_location"];
    
    // Login PFUser using Facebook
    [PFFacebookUtils logInWithPermissions:permissionsArray block:^(PFUser *user, NSError *error)
     {
        if (user)
        {
            FBRequest *request = [FBRequest requestForMe];
            [request startWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error)
             {
                if (!error)
                {
                    // result is a dictionary with the user's Facebook data
                    NSDictionary *userData = (NSDictionary *)result;
                    
                    NSString *facebookID = userData[@"id"];
                    user.username = userData[@"first_name"];
                    user.email = userData[@"email"];
                    NSURL *pictureURL = [NSURL URLWithString:[NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=large&return_ssl_resources=1", facebookID]];
                    user[@"profilePicture"] = [pictureURL absoluteString];
                    NSLog(@"FacebookLog :%@ %@", user.username, user.email);
                    [user saveEventually];
                    [self performSegueWithIdentifier:@"loginSuccess" sender:self];
                }
             }];
        }
        
    }];
}

//Method peut etre a virer dans la superclass
- (IBAction)login:(id)sender
{
    
    if (self.isRegistering == YES)
        [self registering];
    else
    {
        NSString *error = nil;
        self.hud.labelText = @"Connecting";
        if ((error = [super validateFormLogin]))
        {
            FUIAlertView *alertView = [AlertView getDefaultAlertVIew:@"Oops !" message:error];
            
            [alertView show];
            return;
        }
        else
        {
            self.hud.hidden = FALSE;
            [PFUser logInWithUsernameInBackground:self.textFieldLogin.text password:self.textFieldPassword1.text block:^(PFUser *user, NSError *error) {
                self.hud.hidden = TRUE;
                if (error)
                    [super connectionFailed:[error localizedDescription]];
                else
                {
                    //RegisterChannel for this user
                    PFInstallation *currentInstallation = [PFInstallation currentInstallation];
                    NSString *channel = [CHANNELUSERPREFIX stringByAppendingString:user.objectId];
                    [currentInstallation setChannels:[NSArray arrayWithObject:channel]];
                    [currentInstallation saveInBackground];
                    NSLog(@"User successfully signin");
                    [self performSegueWithIdentifier:@"loginSuccess" sender:self];
                }
            }];
        }
    }
}

- (IBAction)registerUser:(id)sender
{
    
    if (self.isRegistering == NO)
    {
        [super setAnimationForRegistersOutlet:^(BOOL completed) {
            
        }];
    }
    else
    {
        [super removeRegisterFields];
    }
    
    /* static int i = 0;
     NSString *error = nil;
     
     if (i == 0)
     {
     [self.buttonOutletRegister setTitle:@"Register !" forState:UIControlStateNormal];
     self.textFieldPassword2.hidden = FALSE;
     self.textFieldEmail.hidden = FALSE;
     self.buttonResetPassword.hidden = true;
     i = 1;
     return;
     }
     
     self.hud.labelText = @"Registering";
     
     
     if ((error = [super validateFormRegister]))
     {
     FUIAlertView *alertView = [AlertView getDefaultAlertVIew:@"Oops !" message:error];
     
     [alertView show];
     return;
     }
     else
     {
     self.hud.hidden = FALSE;
     PFUser *user = [[PFUser alloc] init];
     
     user.email = self.textFieldEmail.text;
     user.username = self.textFieldLogin.text;
     user.password = self.textFieldPassword1.text;
     [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error)
     {
     self.hud.hidden = TRUE;
     if (error)
     [super connectionFailed:[error localizedDescription]];
     else
     {
     NSLog(@"User successfully signup");
     //RegisterChannel for this user
     PFInstallation *currentInstallation = [PFInstallation currentInstallation];
     currentInstallation.channels = @[ @"global", [CHANNELUSERPREFIX stringByAppendingString:user.objectId]];
     [currentInstallation saveEventually];
     // [WPHelperConstant saveUserCredentialsToKeyChain:user.username password:user.password];
     [self performSegueWithIdentifier:@"loginSuccess" sender:self];
     }
     }];
     }*/
    
}

- (IBAction)loginFaceBook:(id)sender {
}


/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
