//
//  WPChooseDateViewController.m
//  whoparty
//
//  Created by Werck Ayrton on 15/03/2015.
//  Copyright (c) 2015 Nyu Web Developpement. All rights reserved.
//

#import <JTCalendarMenuMonthView.h>
#import "WPChooseDateViewController.h"
#import "WPHelperConstant.h"
#import "SelectPlaceViewController.h"

@interface WPChooseDateViewController ()
@property (strong, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (strong, nonatomic) NSDate *currentDate;
@property (weak, nonatomic) IBOutlet JTCalendarContentView *jtcalendarcontentview;
@property (weak, nonatomic) IBOutlet JTCalendarMenuView *jtcalendarmenuview;
@property (strong, nonatomic) JTCalendar    *calendar;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *rightBarButtonItem;
@property (weak, nonatomic) IBOutlet UIView *tutoView;
@property (strong, nonatomic) IBOutlet UILabel *labelTuto;

@end

@implementation WPChooseDateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [WPHelperConstant setBGWithImageForView:self.view image:@"lacBG"];
  }

- (void)observeValueForKeyPath:(NSString *)keyPath  ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    
    if ([keyPath isEqual:@"currentDate"])
    {
        if (self.currentDate != nil)
        {
            self.rightBarButtonItem.title = @"Next";
            self.rightBarButtonItem.enabled = TRUE;//  self.rightBarButtonItem.title = @"Next";
        }
        else
        {
            self.rightBarButtonItem.title = @"";
            self.rightBarButtonItem.enabled = false;
        }
    }
}

- (void) viewWillDisappear:(BOOL)animated
{
    [self removeObserver:self forKeyPath:@"currentDate"];
    [super viewWillDisappear:animated];
    self.jtcalendarmenuview.hidden = YES;
    self.jtcalendarcontentview.hidden = YES;
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.currentDate = nil;
    self.calendar = [JTCalendar new];
    self.rightBarButtonItem.title = @"";
    self.rightBarButtonItem.enabled = FALSE;
    self.calendar.calendarAppearance.menuMonthTextColor = [UIColor whiteColor];
    self.calendar.calendarAppearance.dayTextColorSelected = [UIColor whiteColor];
    self.calendar.calendarAppearance.dayTextColor = [UIColor whiteColor];
    [self.calendar setMenuMonthsView:self.jtcalendarmenuview];
    [self.calendar setContentView:self.jtcalendarcontentview];
    [self.calendar setDataSource:self];
    [self.calendar reloadData];
    self.jtcalendarcontentview.backgroundColor = [UIColor clearColor];
    self.jtcalendarmenuview.backgroundColor = [UIColor clearColor];

    [self addObserver:self forKeyPath:@"currentDate" options:NSKeyValueObservingOptionNew context:nil];
    [WPHelperConstant setBlurForView:self.tutoView];
    [self.tutoView bringSubviewToFront:self.labelTuto];
}


- (void)viewDidLayoutSubviews
{
    [self.calendar repositionViews];
}

- (BOOL)calendarHaveEvent:(JTCalendar *)calendar date:(NSDate *)date
{
    return NO;
}

- (void)calendarDidDateSelected:(JTCalendar *)calendar date:(NSDate *)date
{

    if (self.currentDate == date)
    {
        [calendar setCurrentDateSelected:nil];
        [calendar reloadData];
        self.currentDate = nil;
    }
    else
    {
        self.currentDate = date;
    }
    NSLog(@"%@", calendar.currentDateSelected);

    //self.currentDate = [date dateByAddingTimeInterval:60*60*24*1];
    //NSLog(@"%@", self.currentDate);
    
    
}
- (IBAction)nextOnClick:(id)sender
{
    UIAlertController *alertError = [UIAlertController alertControllerWithTitle:@"Oops !" message:@"Select a valid date" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [alertError dismissViewControllerAnimated:YES completion:nil];
    }];
    
    [alertError addAction:ok];

    
    
    if (self.currentDate == nil)
    {
        [self.navigationController presentViewController:alertError animated:YES completion:nil];
        return;
    }
    
    
    NSDate *date1 = nil;
    NSDate *date2 = nil;
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSInteger comps = (NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear);
    
    NSDateComponents *date1Components = [calendar components:comps
                                                    fromDate: self.currentDate];
    NSDateComponents *date2Components = [calendar components:comps
                                                    fromDate: [NSDate date]];
    
    date1 = [calendar dateFromComponents:date1Components];
    date2 = [calendar dateFromComponents:date2Components];

    
    if ([date1 compare:date2] == NSOrderedAscending)
        [self.navigationController presentViewController:alertError animated:YES completion:nil];
    else
        [self performSegueWithIdentifier:@"SelectPlace" sender:self];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//To not forget else it crashes
- (void) dealloc
{
    self.jtcalendarcontentview.delegate = nil;
    self.jtcalendarmenuview.delegate = nil;
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"SelectPlace"])
    {
        //UINavigationController *navVC = [segue destinationViewController];
        SelectPlaceViewController *vc = [segue destinationViewController];//[navVC.viewControllers objectAtIndex:0];
        vc.selectedDate = self.currentDate;
    }
    
}


@end
