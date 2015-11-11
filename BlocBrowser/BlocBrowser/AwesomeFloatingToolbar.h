//
//  AwesomeFloatingToolbar.h
//  BlocBrowser
//
//  Created by Eric Chamberlin on 11/9/15.
//  Copyright © 2015 Eric Chamberlin. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AwesomeFloatingToolbar;

@protocol AwesomeFloatingToolbarDelegate <NSObject>

@optional

- (void) floatingToolbar:(AwesomeFloatingToolbar *)toolbar didSelectButtonWithTitle:(NSString *)title;
-(void) panToolbar:(UIPanGestureRecognizer *)recognizer;

//defined pinch gesture here...

-(void) pinchToolbar:(UIPinchGestureRecognizer *)pinch;


@end

@interface AwesomeFloatingToolbar : UIView

- (instancetype) initWithFourTitles:(NSArray *)titles;

- (void) setEnabled:(BOOL)enabled forButtonWithTitle:(NSString *)title;

@property (nonatomic, weak) id <AwesomeFloatingToolbarDelegate> delegate;

@end
