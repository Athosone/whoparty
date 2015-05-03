//
//  WPAccountInformationViewController.m
//  whoparty
//
//  Created by Werck Ayrton on 04/04/2015.
//  Copyright (c) 2015 Nyu Web Developpement. All rights reserved.
//

#import <Parse/Parse.h>
#import <MBProgressHUD/MBProgressHUD.h>

#import "WPAccountInformationViewController.h"
#import "NSString+FormValidation.h"
#import "ManagedParseUser.h"

@interface WPAccountInformationViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *imageProfile;
@property (weak, nonatomic) IBOutlet UILabel *labelNameUser;
@property (weak, nonatomic) IBOutlet UITextField *textFieldEmail;
@property (weak, nonatomic) IBOutlet UIButton *resetPassword;
@property (readwrite, nonatomic) BOOL isModifying;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *leftBarButtonItem;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *rightBarButtonItem;
@property (strong, nonatomic) MBProgressHUD *hud;
@property (weak, nonatomic) IBOutlet UIButton *changeImageButton;

@end

@implementation WPAccountInformationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:NO];
    self.hud.labelText = @"";
    self.hud.hidden = true;
    self.isModifying = FALSE;
    PFUser *user = [PFUser currentUser];
    
    self.labelNameUser.text = user.username;
    self.textFieldEmail.text = user.email;
    self.imageProfile.image = [UIImage imageNamed:@"noav"];
    self.imageProfile.layer.masksToBounds = YES;
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    
    if ([user objectForKey:@"profilePictureFile"])
    {
        PFFile *image = [user objectForKey:@"profilePictureFile"];
        
        [image getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
            
            self.imageProfile.image = [UIImage imageWithData:data];
        }];
    }
    else
    {
        [ManagedParseUser userWithUserName:user.username completionBlock:^(PFObject *object) {
            if (object && [object objectForKey:@"profilePictureFile"])
            {
                PFFile *image = [object objectForKey:@"profilePictureFile"];
                
                [image getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
                    self.imageProfile.image = [UIImage imageWithData:data];
                }];
            }
        }];
    }
        // Do any additional setup after loading the view.
}

- (IBAction)changeImageButtonOnClick:(id)sender
{
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    imagePickerController.delegate = self;
    [self presentViewController:imagePickerController animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    //You can retrieve the actual UIImage
    __block UIImage *image = [info valueForKey:UIImagePickerControllerOriginalImage];
    //Or you can get the image url from AssetsLibrary
//    NSURL *path = [info valueForKey:UIImagePickerControllerReferenceURL];
    
    [picker dismissViewControllerAnimated:YES completion:^{
        PFFile *imageFile = [PFFile fileWithData:UIImageJPEGRepresentation(image, 0.8f)];
        [[PFUser currentUser] setObject:imageFile forKey:@"profilePictureFile"];
        [imageFile saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (succeeded)
            {
                [[PFUser currentUser] setObject:imageFile.url forKey:@"profilePicture"];
                [[PFUser currentUser] saveEventually:^(BOOL succeeded, NSError *error) {
                    NSLog(@"UsersPicture image updated");
                }];
            }
        }];
        self.imageProfile.image = image;
    }];
}


- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.imageProfile.layer.cornerRadius = self.imageProfile.frame.size.width / 2;

    [self addObserver:self forKeyPath:@"isModifying" options:NSKeyValueObservingOptionNew context:nil];
}

- (void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self removeObserver:self forKeyPath:@"isModifying"];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"isModifying"])
    {
        if (self.isModifying == FALSE)
        {
            self.leftBarButtonItem.title = @"Back";
            self.rightBarButtonItem.title = @"Modify";
        }
        else
        {
            self.rightBarButtonItem.title = @"Save";
            self.leftBarButtonItem.title = @"Cancel";
        }
    }
}

- (NSString *) checkValidChanges
{
    NSString *errorMessage = nil;
    
    if (![self.textFieldEmail.text isValidEmail])
        errorMessage = @"Please enter a valid email";
     return errorMessage;
}

- (IBAction)rightBarButtonOnClick:(id)sender
{
    if (self.isModifying == FALSE)
    {
        self.isModifying = TRUE;
        self.textFieldEmail.enabled = true;
    }
    else
    {
        NSString *errorMessage = [self checkValidChanges];
        if (errorMessage == nil)
        {
            NSString *newEmail = self.textFieldEmail.text;
            self.hud.hidden = false;
            [ManagedParseUser isEmailExist:self.textFieldEmail.text completionBlock:^(bool exist) {
                self.hud.hidden = true;
                if (exist)
                {
                    UIAlertController *alertExist = [UIAlertController alertControllerWithTitle:@"Oops !" message:@"Email is already taken" preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction *okExist = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                        [alertExist dismissViewControllerAnimated:YES completion:nil];
                    }];
                    [alertExist addAction:okExist];
                    [self presentViewController:alertExist animated:YES completion:nil];

                }
                else
                {
                    PFUser *user = [PFUser currentUser];
                    user.email = newEmail;
                    [user saveEventually:^(BOOL succeeded, NSError *error) {
                        NSLog(@"Users updated");
                        self.isModifying = FALSE;
                        self.textFieldEmail.enabled = FALSE;
                    }];
                }
                
            }];
        }
        else
        {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Oops !" message:errorMessage preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *ok = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                [alert dismissViewControllerAnimated:YES completion:nil];
            }];
            [alert addAction:ok];
            [self presentViewController:alert animated:YES completion:nil];
        }
        
    }
}

- (IBAction)leftBarButtonOnClick:(id)sender
{
    if (self.isModifying == FALSE)
        [self.navigationController popToRootViewControllerAnimated:YES];
    else
    {
        self.isModifying = FALSE;
        PFUser *user = [PFUser currentUser];
        self.textFieldEmail.text = user.email;
        self.textFieldEmail.enabled = FALSE;
    }
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
