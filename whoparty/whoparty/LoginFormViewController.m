//
//  LoginFormViewController.m
//  whoparty
//
//  Created by Werck Ayrton on 01/03/2015.
//  Copyright (c) 2015 Nyu Web Developpement. All rights reserved.
//

#import "LoginFormViewController.h"
#import "Animations.h"

@interface LoginFormViewController ()


@end

@implementation LoginFormViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.hud.hidden = TRUE;
    
    self.textFieldPassword2.hidden = true;

    // Do any additional setup after loading the view.
}

#pragma mark ->Validate forms

- (NSString *)validateFormLogin
{
    NSString *errorMessage = nil;
    
    if (![self.textFieldEmail.text isValidEmail])
        errorMessage = @"Please enter a valid email";
    else if (![self.textFieldPassword1.text isValidPassword])
        errorMessage = @"Please enter a valid password";
    return errorMessage;
}

- (NSString*)validateFormRegister
{
    NSString *errorMessage = nil;
    
    if (![self.textFieldEmail.text isValidEmail])
        errorMessage = @"Please enter a valid email";
    else if (![self.textFieldPassword1.text isValidPassword])
        errorMessage = @"Please enter a valid password";
    else if (![self.textFieldPassword1.text isEqualToString:self.textFieldPassword2.text])
        errorMessage = @"Both password must match";
    return errorMessage;
}



//fail to established connection with the server
- (void) connectionFailed:(NSString *)error
{
    [Animations addShakingAnimation:self.textFieldEmail];
    [Animations addShakingAnimation:self.textFieldPassword1];
    NSLog(@"Connection Fail, reason: %@", error);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
