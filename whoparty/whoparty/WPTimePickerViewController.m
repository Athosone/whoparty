//
//  WPTimePickerViewController.m
//  whoparty
//
//  Created by Werck Ayrton on 28/03/2015.
//  Copyright (c) 2015 Nyu Web Developpement. All rights reserved.
//

#import "WPTimePickerViewController.h"
#import "SelectPlaceViewController.h"
#import "WPHelperConstant.h"

@interface WPTimePickerViewController ()
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (weak, nonatomic) IBOutlet UIView *tutoView;
@property (weak, nonatomic) IBOutlet UILabel *labelTuto;

@end

@implementation WPTimePickerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [WPHelperConstant setBGWithImageForView:self.view image:@"lacBG"];
    [WPHelperConstant setBlurForView:self.tutoView];
    [self.tutoView bringSubviewToFront:self.labelTuto];
    NSDate *date = self.selectedDate;

    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier: NSCalendarIdentifierGregorian];
    NSDateComponents *components = [gregorian components: NSUIntegerMax fromDate: date];
    [components setHour: 23];
    [components setMinute: 59];
    [components setSecond: 59];
        
   // self.datePicker.datePickerMode = UIDatePickerModeTime;
    self.datePicker.timeZone = [NSTimeZone localTimeZone];
    //self.datePicker.locale = [NSLocale systemLocale];
   // self.datePicker.minimumDate = self.selectedDate;
   // self.datePicker.maximumDate = newDate;
    self.datePicker.tintColor = [UIColor whiteColor];
    [self.datePicker setValue:[UIColor whiteColor] forKeyPath:@"textColor"];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)nextBarButtonOnClick:(id)sender
{
    [self performSegueWithIdentifier:@"SelectPlace" sender:self];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"SelectPlace"])
    {
        SelectPlaceViewController *vc = [segue destinationViewController];
        vc.selectedDate = self.datePicker.date;
        /*
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd 'at' HH:mm:ss"];
        [dateFormatter setTimeZone:[NSTimeZone localTimeZone]];
        
        NSLog(@"%@ date %@", vc.selectedDate, [dateFormatter stringFromDate:vc.selectedDate]);*/
 
    }
}


@end
