//
//  SendView.h
//  whoparty
//
//  Created by Werck Ayrton on 08/03/2015.
//  Copyright (c) 2015 Nyu Web Developpement. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SendViewProtocol <NSObject>

- (void) didClickOnSendViewButton:(id)sender;

@end

@interface SendView : UIView

@property (weak, nonatomic) id<SendViewProtocol> delegate;

- (void) fadeIn;
- (void) fadeOut;
- (void) startAi;
- (void) stopAi;
- (void) initView;

@end
