//
//  MarkerView.m
//  whoparty
//
//  Created by Werck Ayrton on 11/03/2015.
//  Copyright (c) 2015 Nyu Web Developpement. All rights reserved.
//

#import <GoogleMaps/GoogleMaps.h>
#import "WPHelperConstant.h"
#import "MarkerView.h"

@interface MarkerView ()

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSString *sectionTitle;
@end

@implementation MarkerView


- (id) init
{
    self = [[[NSBundle mainBundle] loadNibNamed:@"MarkerView" owner:nil options:nil] objectAtIndex:0];
    return self;
}
- (void) initViewWithMarker:(GMSMarker*)marker
{
    self.sectionTitle = marker.title;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.backgroundColor = [UIColor clearColor];
    NSLog(@"Frame : %d", self.frame.size.height);
    [self.tableView reloadData];
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger lRet = 0;
    
    lRet = self.usersConcerned.count;
    return lRet;
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *sectionName;
    switch (section)
    {
        case 0:
            sectionName = self.sectionTitle;
              default:
            sectionName = @"";
            break;
    }
    return sectionName;
}

- (UITableViewCell*) tableView:(UITableView *)mtableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell   = [mtableView dequeueReusableCellWithIdentifier:@"Cell"];
    cell.backgroundColor    = [UIColor clearColor];
    NSString        *user   = [self.usersConcerned objectAtIndex:indexPath.row];
    
    if (!cell)
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    cell.textLabel.text = user;
    if ([self.usersAccepted containsObject:user])
        cell.imageView.image = [UIImage imageWithColor:DEFAULTACCEPTCOLOR cornerRadius:6.0f];
    else if ([self.usersDeclined containsObject:user])
        cell.imageView.image = [UIImage imageWithColor:DEFAULTDECLINECOLOR cornerRadius:6.0f];

    else
        cell.imageView.image = [UIImage imageWithColor:[UIColor cloudsColor] cornerRadius:6.0f];
    cell.backgroundColor = [UIColor clearColor];
    return cell;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
