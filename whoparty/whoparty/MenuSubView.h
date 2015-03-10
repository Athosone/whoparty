//
//  MenuSubView.h
//  whoparty
//
//  Created by Werck Ayrton on 09/03/2015.
//  Copyright (c) 2015 Nyu Web Developpement. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    kMenuLogout,
    kMenuAbout,
} subTypeMenu;


@interface MenuSubView : UITableViewCell

@property (readwrite, nonatomic) subTypeMenu type;

@end
