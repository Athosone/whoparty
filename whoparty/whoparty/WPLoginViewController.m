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

#define LEFTVIEWWIDTH 25

@interface WPLoginViewController ()

- (IBAction)login:(id)sender;
- (IBAction)registerUser:(id)sender;


@end

@implementation WPLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receivePushNotification:) name:HASRECEIVEDPUSHNOTIFICATION object:nil];
    //TO DELETE
    self.textFieldPassword1.text = @"12345";
    self.textFieldEmail.text = @"toto@gmail.com";
    // Do any additional setup after loading the view.
}

#pragma mark ->Receive Notification Push

- (void) receivePushNotification:(NSDictionary*) userInfo
{
    NSLog(@"Login-ViewController-userinfo receive push notification: %@", userInfo);
}

#pragma mark ->Design

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    CGRect frame1 = CGRectMake(0, 0, LEFTVIEWWIDTH, self.textFieldEmail.frame.size.height - 5);
    CGRect frame2 = CGRectMake(0, 0, LEFTVIEWWIDTH, self.textFieldEmail.frame.size.height - 5);
    CGRect frame3 = CGRectMake(0, 0, LEFTVIEWWIDTH, self.textFieldEmail.frame.size.height - 5);

    UIImageView *field1 = [[UIImageView alloc] initWithFrame:frame1];
    UIImageView *field2 = [[UIImageView alloc] initWithFrame:frame2];
    UIImageView *field3 = [[UIImageView alloc] initWithFrame:frame3];
    
    field1.image = [UIImage imageNamed:@"accountLogin"];
    field2.image = [UIImage imageNamed:@"passwordCadenas"];
    field3.image = [UIImage imageNamed:@"passwordCadenas"];
    
    self.textFieldEmail.leftView = field1;
    self.textFieldPassword1.leftView = field2;
    self.textFieldPassword2.leftView = field3;

    self.textFieldEmail.leftViewMode = UITextFieldViewModeAlways;
    self.textFieldPassword1.leftViewMode = UITextFieldViewModeAlways;
    self.textFieldPassword2.leftViewMode = UITextFieldViewModeAlways;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//Method peut etre a virer dans la superclass
- (IBAction)login:(id)sender
{
    NSString *error = nil;
    self.hud.labelText = @"Connecting";
    if ((error = [super validateFormLogin]))
    {
        [[[UIAlertView alloc] initWithTitle:nil message:error delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Ok", nil] show];
        return;
    }
    else
    {
        self.hud.hidden = FALSE;
        [PFUser logInWithUsernameInBackground:self.textFieldEmail.text password:self.textFieldPassword1.text block:^(PFUser *user, NSError *error) {
            self.hud.hidden = TRUE;
            if (error)
                [super connectionFailed:[error localizedDescription]];
            else
            {
                //RegisterChannel for this user
                PFInstallation *currentInstallation = [PFInstallation currentInstallation];
                currentInstallation.channels = @[ @"global", [CHANNELUSERPREFIX stringByAppendingString:user.objectId]];
                [currentInstallation saveInBackground];

                NSLog(@"User successfully signin");
                [self performSegueWithIdentifier:@"loginSuccess" sender:self];
            }
        }];
    }
}
- (IBAction)registerUser:(id)sender
{
    static int i = 0;
    NSString *error = nil;
    
    if (i == 0)
    {
        [self.buttonOutletRegister setTitle:@"Register !" forState:UIControlStateNormal];
        self.textFieldPassword2.hidden = FALSE;
        i = 1;
        return;
    }
    
    self.hud.labelText = @"Registering";
    
    
    if ((error = [super validateFormRegister]))
    {
        [[[UIAlertView alloc] initWithTitle:nil message:error delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Ok", nil] show];
        return;
    }
    else
    {
        self.hud.hidden = FALSE;
        PFUser *user = [[PFUser alloc] init];

        user.email = self.textFieldEmail.text;
        user.username = user.email;
        user.password = self.textFieldPassword1.text;
        [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error)
        {
            self.hud.hidden = TRUE;
            if (error)
                [super connectionFailed:[error localizedDescription]];
            else
            {
                 NSLog(@"User successfully signup");
                [self performSegueWithIdentifier:@"loginSuccess" sender:self];
            }
        }];
    }
  
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
