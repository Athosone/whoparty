//
//  MarkerView.h
//  whoparty
//
//  Created by Werck Ayrton on 11/03/2015.
//  Copyright (c) 2015 Nyu Web Developpement. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MarkerView : UIView<UITableViewDelegate, UITableViewDataSource>

- (void) initViewWithMarker:(GMSMarker*)marker;
@property (strong, nonatomic) NSArray  *usersConcerned;
@property (strong, nonatomic) NSArray  *usersAccepted;
@property (strong, nonatomic) NSArray  *usersDeclined;


@end
