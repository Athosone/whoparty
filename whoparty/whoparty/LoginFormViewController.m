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
    
    self.textFieldEmail.hidden = true;
    self.textFieldPassword2.hidden = true;

    // Do any additional setup after loading the view.
}

#pragma mark ->Validate forms

- (NSString *)validateFormLogin
{
    NSString *errorMessage = nil;
    
    if (![self.textFieldLogin.text isValidName])
        errorMessage = @"Please enter a valid login";
    else if (![self.textFieldPassword1.text isValidPassword])
        errorMessage = @"Please enter a valid password";
    return errorMessage;
}

- (NSString*)validateFormRegister
{
    NSString *errorMessage = nil;
    
    if (![self.textFieldEmail.text isValidEmail])
        errorMessage = @"Please enter a valid email";
    if (![self.textFieldLogin.text isValidName])
        errorMessage = @"Your username must contains at least 5 characters";
    else if (![self.textFieldPassword1.text isValidPassword])
        errorMessage = @"Your password must contains at least 5 characters";
    else if (![self.textFieldPassword1.text isEqualToString:self.textFieldPassword2.text])
        errorMessage = @"Both password must match";
    return errorMessage;
}


- (IBAction)buttonResetPasswordOnClick:(id)sender
{
    __block NSString *mail;
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Resetting password !" message:@"Enter the mail you provided when you have registered please" preferredStyle:UIAlertControllerStyleAlert];

    UIAlertAction* ok = [UIAlertAction
                         actionWithTitle:@"OK"
                         style:UIAlertActionStyleDefault
                         handler:^(UIAlertAction * action)
                         {
                             UITextField *tF = (UITextField*)[alert.textFields objectAtIndex:0];
                             mail = tF.text;
                             if (mail.length > 0)
                                 [PFUser requestPasswordResetForEmailInBackground:mail];
                            [alert dismissViewControllerAnimated:YES completion:nil];
                         }];
    [alert addAction:ok];
    UIAlertAction* cancel = [UIAlertAction
                             actionWithTitle:@"Cancel"
                             style:UIAlertActionStyleDefault
                             handler:^(UIAlertAction * action)
                             {
                                 [alert dismissViewControllerAnimated:YES completion:nil];
                             }];
    [alert addAction:cancel];
    [alert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder = @"Enter your group name";
    }];
    [self presentViewController:alert animated:YES completion:nil];
}

//fail to established connection with the server
- (void) connectionFailed:(NSString *)error
{
    [Animations addShakingAnimation:self.textFieldLogin];
    [Animations addShakingAnimation:self.textFieldPassword1];
    [Animations addShakingAnimation:self.textFieldEmail];
    [Animations addShakingAnimation:self.textFieldPassword2];
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
