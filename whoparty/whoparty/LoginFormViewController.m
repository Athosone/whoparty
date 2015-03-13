//
//  LoginFormViewController.m
//  whoparty
//
//  Created by Werck Ayrton on 01/03/2015.
//  Copyright (c) 2015 Nyu Web Developpement. All rights reserved.
//

#import "LoginFormViewController.h"
#import "Animations.h"
#import "ConstraintHelper.h"


#define DURATIONANIMATIONREGISTER 0.7f

@interface LoginFormViewController ()

@property (weak, nonatomic) IBOutlet UILabel *labelAccount;
@property (readwrite, nonatomic) BOOL needToLayout;
@property (strong, nonatomic) IBOutlet UIImageView *imageViewBG;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *constraintUsernameToPwd1;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *constraintPwd1ToSigninButton;
- (void) initUI;
- (void) addRegisterFields:(CGPoint)emailPos password2Point:(CGPoint)password2Pos completedAnim:(void(^)(BOOL completed))completedAnim;
- (void) removeAllConstraint;

@end

@implementation LoginFormViewController

- (void) addCenterConstraintForViews
{
    for (UIView *v in self.view.subviews)
    {
        NSLayoutConstraint *centerConstraint = [ConstraintHelper getAlignementXForView:self.view viewToCenter:v];
        
        [self.view addConstraint:centerConstraint];
    }
}

- (void) addConstraintToEmailTF
{
    //Email down constraint
    NSLayoutConstraint *constraintEmailToPass1 = [NSLayoutConstraint constraintWithItem:self.textFieldEmail
                                                                  attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual
                                                                     toItem:self.textFieldPassword1 attribute:NSLayoutAttributeTop multiplier:1 constant:-2];
   
    //Email top constraint
    NSLayoutConstraint *constraintEmailToLoginTF = [NSLayoutConstraint constraintWithItem:self.textFieldLogin
                                                                               attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.textFieldEmail attribute:NSLayoutAttributeTop multiplier:1 constant:-2];
    
    //Pass2 down constraint
    NSLayoutConstraint *constraintPass2ToSignin = [NSLayoutConstraint constraintWithItem:self.textFieldPassword2
                                                                               attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.buttonOutletLogin attribute:NSLayoutAttributeTop multiplier:1 constant:-8];

    NSLayoutConstraint *constraintPass1ToPass2 = [NSLayoutConstraint constraintWithItem:self.textFieldPassword1 attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.textFieldPassword2 attribute:NSLayoutAttributeTop multiplier:1 constant:-2];
    
    
    NSLayoutConstraint *constraintCenterEmail = [ConstraintHelper getAlignementXForView:self.textFieldEmail viewToCenter:self.view];
    NSLayoutConstraint *constraintCenterPassword2 = [ConstraintHelper getAlignementXForView:self.textFieldPassword2 viewToCenter:self.view];
    
    
    [self.view addConstraint:constraintCenterEmail];
    [self.view addConstraint:constraintCenterPassword2];
    
    [self.view addConstraint:constraintEmailToPass1];
   [self.view addConstraint:constraintEmailToLoginTF];
   [self.view addConstraint:constraintPass1ToPass2];
    [self.view addConstraint:constraintPass2ToSignin];
    
}

- (void) adjustConstraintForLoginView
{
}

- (void) addRegisterFields:(CGPoint)emailPos password2Point:(CGPoint)password2Pos completedAnim:(void(^)(BOOL completed))completedAnim
{
    self.textFieldEmail.layer.position = emailPos;
    
    self.textFieldPassword2.layer.position = password2Pos;
    [CATransaction begin];
    
    CABasicAnimation *fadInEmail = [Animations getFadeAnimation:0.0f end:0.3f];
    fadInEmail.duration = 1.0f;
    fadInEmail.fillMode = kCAFillModeForwards;
    self.textFieldEmail.layer.opacity = 0.3f;
    [self.textFieldEmail.layer addAnimation:fadInEmail forKey:@"fadeinemail"];
    
    CABasicAnimation *fadeInPassword2 = [Animations getFadeAnimation:0.0f end:0.3f];
    fadeInPassword2.duration = 1.0f;
    fadeInPassword2.fillMode = kCAFillModeForwards;
    self.textFieldPassword2.layer.opacity = 0.3f;
    [self.textFieldPassword2.layer addAnimation:fadeInPassword2 forKey:@"fadeinpassword"];
    
    
    
    [CATransaction setCompletionBlock:^{
        self.textFieldEmail.hidden = false;
        self.textFieldPassword2.hidden = false;
        
        [self.view removeConstraint:self.constraintPwd1ToSigninButton];
        [self.view removeConstraint:self.constraintUsernameToPwd1];
        self.isRegistering = YES;
        [self.buttonOutletRegister setTitle:@"Cancel" forState:UIControlStateNormal];
        [self.buttonOutletLogin setTitle:@"Signup" forState:UIControlStateNormal];
        
        [self addConstraintToEmailTF];
        completedAnim(YES);
    }];
    [CATransaction commit];
}

- (void) setAnimationForRegistersOutlet:(void(^)(BOOL completed))completedAnim
{
    
    [CATransaction begin];
    //Slide password field to put email field
    CGPoint originPassTF = self.textFieldPassword1.layer.position;
    CGPoint destPassTF = CGPointMake(originPassTF.x, self.textFieldPassword1.layer.position.y
                               + self.textFieldPassword1.frame.size.height + 6);
    
    float   currentYToAdd = self.textFieldPassword1.frame.size.height * 2 + 6;
    
    CABasicAnimation *slideDownPassword = [Animations getSlideAnimationOnY:originPassTF end:destPassTF];
    slideDownPassword.duration = DURATIONANIMATIONREGISTER;
    slideDownPassword.fillMode = kCAFillModeForwards;
    [self.textFieldPassword1.layer addAnimation:slideDownPassword forKey:@"slidedownpassword"];
    self.textFieldPassword1.layer.position = destPassTF;

    //Slide Signin button to put password field2
    CGPoint originSignin = self.buttonOutletLogin.layer.position;
    CGPoint destSignin = CGPointMake(originSignin.x, (self.buttonOutletLogin.layer.position.y
                                     + currentYToAdd));
   
    CABasicAnimation *slideDownSignin = [Animations getSlideAnimationOnY:originSignin end:destSignin];
    slideDownSignin.duration = DURATIONANIMATIONREGISTER;
    slideDownSignin.fillMode = kCAFillModeForwards;
    [self.buttonOutletLogin.layer addAnimation:slideDownSignin forKey:@"slidedownsignin"];
    self.buttonOutletLogin.layer.position = CGPointMake(originSignin.x, destSignin.y);
    
    //Slide label
    CGPoint  originLabel = self.labelAccount.layer.position;
    CGPoint  destLabel = CGPointMake(originLabel.x,
                                     self.labelAccount.layer.position.y + currentYToAdd);
    
    CABasicAnimation *slideDownLabel = [Animations getSlideAnimationOnY:originLabel end:destLabel];
    slideDownLabel.duration = DURATIONANIMATIONREGISTER;
    slideDownLabel.fillMode = kCAFillModeForwards;
    [self.labelAccount.layer addAnimation:slideDownLabel forKey:@"slidedownlabel"];
    self.labelAccount.layer.position = CGPointMake(originLabel.x, destLabel.y);
    
    
    //Set button register
    CGPoint originRegister = self.buttonOutletRegister.layer.position;
    CGPoint destRegister = CGPointMake(originRegister.x, originRegister.y + currentYToAdd);
    CABasicAnimation *slideDownRegister = [Animations getSlideAnimationOnY:originRegister end:destRegister];
    slideDownRegister.duration = DURATIONANIMATIONREGISTER;
    slideDownRegister.fillMode = kCAFillModeForwards;
    [self.buttonOutletRegister.layer addAnimation:slideDownRegister forKey:@"slidedownregister"];
    self.buttonOutletRegister.layer.position = CGPointMake(destRegister.x, destRegister.y);
    self.buttonOutletRegister.layer.position = CGPointMake(self.buttonOutletRegister.layer.position.x, destLabel.y);
    [CATransaction setCompletionBlock:^{
        [self addRegisterFields:CGPointMake(originPassTF.x, originPassTF.y + 2)
                 password2Point:CGPointMake(destPassTF.x, destPassTF.y + self.textFieldPassword1.frame.size.height + 4)
                  completedAnim:completedAnim];
    }];
    [CATransaction commit];
}

- (void) initRegistersOutlets
{
    self.textFieldEmail = [[UITextField alloc] initWithFrame:self.textFieldPassword1.frame];
    self.textFieldEmail.backgroundColor = self.textFieldLogin.backgroundColor;
    self.textFieldEmail.layer.cornerRadius = 6.0f;
    
    
    self.textFieldPassword2 = [[UITextField alloc] initWithFrame:self.textFieldPassword1.frame];
    self.textFieldPassword2.backgroundColor = self.textFieldPassword1.backgroundColor;
    self.textFieldPassword2.layer.cornerRadius = 6.0f;
    self.textFieldPassword2.secureTextEntry = YES;
    self.textFieldEmail.hidden = true;
    self.textFieldPassword2.hidden = true;
    
    [self.view addSubview:self.textFieldEmail];
    [self.view addSubview:self.textFieldPassword2];
}


- (void) initUI
{
    [self.viewOrview setImage:[UIImage imageNamed:@"orView"]];
    self.viewOrview.backgroundColor = [UIColor clearColor];
    self.buttonOutletLogin.layer.cornerRadius = 6.0f;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.needToLayout = YES;
    [self initUI];
    self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.hud.hidden = TRUE;
    self.view.translatesAutoresizingMaskIntoConstraints = YES;
    self.textFieldEmail.hidden = true;
    self.textFieldPassword2.hidden = true;
    self.isRegistering = NO;
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self initRegistersOutlets];
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
