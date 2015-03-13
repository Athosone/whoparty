//
//  LoginFormViewController.h
//  whoparty
//
//  Created by Werck Ayrton on 01/03/2015.
//  Copyright (c) 2015 Nyu Web Developpement. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MBProgressHUD/MBProgressHUD.h>
#import <Parse/Parse.h>
#import "NSString+FormValidation.h"

@interface LoginFormViewController : UIViewController

@property (strong, nonatomic) IBOutlet UITextField *textFieldLogin;
@property (strong, nonatomic) IBOutlet UITextField *textFieldPassword1;
@property (strong, nonatomic) IBOutlet UIButton *buttonOutletLogin;
@property (strong, nonatomic) IBOutlet UIButton *buttonOutletRegister;
@property (strong, nonatomic) MBProgressHUD *hud;
@property (strong, nonatomic) IBOutlet UIButton *buttonResetPassword;
@property (strong, nonatomic) IBOutlet UIButton *buttonSigninFB;
@property (strong, nonatomic) IBOutlet UIImageView *viewOrview;
@property (readwrite, nonatomic) BOOL    isRegistering;
@property (strong, nonatomic) IBOutlet UITextField *textFieldEmail;
@property (strong, nonatomic) IBOutlet UITextField *textFieldPassword2;

- (void) initRegistersOutlets;
- (void) setAnimationForRegistersOutlet:(void(^)(BOOL completed))completedAnim;
- (NSString*) validateFormLogin;
- (NSString*) validateFormRegister;
- (void) connectionFailed:(NSString *)error;

@end
