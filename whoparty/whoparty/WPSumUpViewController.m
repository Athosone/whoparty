//
//  WPSumUpViewController.m
//  whoparty
//
//  Created by Werck Ayrton on 17/03/2015.
//  Copyright (c) 2015 Nyu Web Developpement. All rights reserved.
//

#import "WPSumUpViewController.h"
#import "WPHelperConstant.h"
#import "WPAddFriendsViewController.h"
#import "WPSelectFriendsViewController.h"

@interface WPDescriptionCell : UITableViewCell<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *textFieldDescription;
@property (weak, nonatomic) IBOutlet UITextField *textFieldNameEvent;

@end

@implementation WPDescriptionCell

- (void) initWPDescriptionCell
{
    self.textFieldDescription.delegate = self;
    self.textFieldDescription.returnKeyType = UIReturnKeyDone;
    self.textFieldNameEvent.delegate = self;
    self.textFieldNameEvent.returnKeyType = UIReturnKeyDone;
    [self bringSubviewToFront:self.textFieldNameEvent];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [textField resignFirstResponder];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (NSString*) getDesc
{
    return self.textFieldDescription.text;
}

- (NSString*) getName
{
    return self.textFieldNameEvent.text;
}

@end

#pragma mark -WPSumUpViewController

@interface WPSumUpViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *tutoView;
@property (weak, nonatomic) IBOutlet UILabel *labelTuto;
@property (weak, nonatomic) IBOutlet UIButton *buttonValidate;
@property (strong, nonatomic) NSMutableArray *friends;

@property (weak, nonatomic) IBOutlet UIButton *buttonAddFriends;
@property (weak, nonatomic) WPDescriptionCell *cell;
@property (weak, nonatomic) IBOutlet UILabel *labelButtonAddFriends;

@end

@implementation WPSumUpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [WPHelperConstant setBGWithImageForView:self.view image:@"lacBG"];
    [WPHelperConstant setBlurForView:self.tutoView];

    self.buttonValidate.layer.borderWidth = 2.0f;
    self.buttonValidate.layer.borderColor = [UIColor whiteColor].CGColor;
    self.buttonValidate.layer.cornerRadius = 6.0f;
    [self.tutoView bringSubviewToFront:self.labelTuto];
    [self.tutoView bringSubviewToFront:self.buttonAddFriends];
    [self.tutoView bringSubviewToFront:self.labelButtonAddFriends];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.friends = nil;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger lRet = 3;
    
    return lRet;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    NSInteger row = indexPath.row;
    
    switch (row)
    {
        case 0:
        {
            cell.imageView.image = [UIImage imageNamed:@"calendar"];
            cell.textLabel.text = [WPHelperConstant getDateStringFromDate:self.selectedDate];
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setTimeZone:[NSTimeZone localTimeZone]];
            [dateFormatter setDateFormat:@"hh:mm"];
            [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
            cell.detailTextLabel.text = [dateFormatter stringFromDate:self.selectedDate];
            break;
        }
        case 1:
        {
            cell.imageView.image = [UIImage imageNamed:@"map"];
            cell.textLabel.text = self.selectedPlace.name;
            cell.detailTextLabel.text = self.selectedPlace.address;
            break;
        }
        case 2:
        {
            WPDescriptionCell *cellDesc = [tableView dequeueReusableCellWithIdentifier:@"WPDescriptionCell"];
            cellDesc.backgroundColor = [UIColor clearColor];
            [cellDesc initWPDescriptionCell];
            self.cell = cellDesc;
            return cellDesc;
        }
        default:
            return cell;
    }
    cell.backgroundView.backgroundColor = [UIColor clearColor];
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.detailTextLabel.textColor = [UIColor whiteColor];
    return cell;
}

- (IBAction)buttonAddFriendsOnClic:(id)sender
{
    NSString *desc = [self.cell getDesc];
    NSString *name = [self.cell getName];
    
    if (desc.length == 0 || name.length == 0)
    {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:@"You must provide a description and a name for the event" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *ok = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            [alert dismissViewControllerAnimated:YES completion:nil];
        }];
        [alert addAction:ok];
        [self presentViewController:alert animated:YES completion:nil];
    }
    else
        [self performSegueWithIdentifier:@"WPSelectFriendsViewController" sender:self];
}


#pragma mark ->Cells Delegate

- (void) didClickOnButton:(id)sender
{
    WPAddFriendsViewController *vc = [[WPAddFriendsViewController alloc] init];
    
    vc.view.frame = self.view.frame;
    vc.definesPresentationContext = YES;
    vc.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    [self.navigationController pushViewController:vc animated:YES];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"WPSelectFriendsViewController"])
    {
        NSString *desc = [self.cell getDesc];
        NSString *name = [self.cell getName];
        WPSelectFriendsViewController *destVC = [segue destinationViewController];
        
        destVC.comment = desc;
        destVC.name = name;
        destVC.currentAddress = self.selectedPlace;
        destVC.selectedDate = self.selectedDate;
        
    }

}


@end
