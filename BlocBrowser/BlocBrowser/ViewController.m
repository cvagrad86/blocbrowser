//
//  ViewController.m
//  BlocBrowser
//
//  Created by Eric Chamberlin on 11/5/15.
//  Copyright © 2015 Eric Chamberlin. All rights reserved.
//

#import "ViewController.h"
#import <WebKit/WebKit.h>

@interface ViewController () <WKNavigationDelegate, UITextFieldDelegate>

@property (nonatomic, strong) WKWebView *webView;
@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) UIButton *backButton;
@property (nonatomic, strong) UIButton *forwardButton;
@property (nonatomic, strong) UIButton *stopButton;
@property (nonatomic, strong) UIButton *reloadButton;



@end

@implementation ViewController

#pragma mark - UIViewController

-(void) loadView {
    UIView *mainView = [UIView new];
    
    self.webView = [[WKWebView alloc] init];
    self.webView.navigationDelegate = self;
    
    self.textField = [[UITextField alloc] init];
    self.textField.keyboardType = UIKeyboardTypeURL;
    self.textField.returnKeyType = UIReturnKeyDone;
    self.textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    self.textField.autocorrectionType = UITextAutocorrectionTypeNo;
    self.textField.placeholder = NSLocalizedString(@"WebsiteURL", @"Placeholder text for web browser URL field");
    self.textField.backgroundColor = [UIColor colorWithWhite:220/225.0f alpha:1];
    self.textField.delegate = self;
    
    //organizes the buttons
    
    self.backButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.backButton setEnabled:NO];
    
    self.forwardButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.forwardButton setEnabled:NO];
    
    self.stopButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.stopButton setEnabled:NO];
    
    self.reloadButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.reloadButton setEnabled:NO];
    
    [self.backButton setTitle:NSLocalizedString(@"Back", @"Back command") forState:UIControlStateNormal];
    [self.backButton addTarget:self.webView action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    
    [self.forwardButton setTitle:NSLocalizedString(@"Forward", @"Forward command") forState:UIControlStateNormal];
    [self.forwardButton addTarget:self.webView action:@selector(goForward) forControlEvents:UIControlEventTouchUpInside];
    
    [self.stopButton setTitle:NSLocalizedString(@"Stop", @"Stop command") forState:UIControlStateNormal];
    [self.stopButton addTarget:self.webView action:@selector(stopLoading) forControlEvents:UIControlEventTouchUpInside];
    
    [self.reloadButton setTitle:NSLocalizedString(@"Refresh", @"Reload command") forState:UIControlStateNormal];
    [self.reloadButton addTarget:self.webView action:@selector(reload) forControlEvents:UIControlEventTouchUpInside];

    
    //hardcoding to a website
    //NSString *urlString = @"http://www.bloc.io";
    //NSURL *url = [NSURL URLWithString:urlString];
    //NSURLRequest *request = [NSURLRequest requestWithURL:url];
    //[self.webView loadRequest:request];
    
    
    //tighter code replacing the old code
    
    for (UIView *viewToAdd in @[self.webView, self.textField, self.backButton, self.forwardButton, self.stopButton, self.reloadButton]) {
        [mainView addSubview:viewToAdd];
    }
    
    self.view = mainView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.edgesForExtendedLayout = UIRectEdgeNone;

}

-(void) viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    //self.webView.frame = self.view.frame;
    
    static const CGFloat itemHeight = 50;
    CGFloat width = CGRectGetWidth(self.view.bounds);
    CGFloat browserHeight = CGRectGetHeight(self.view.bounds) - itemHeight - itemHeight;
    CGFloat buttonWidth = CGRectGetWidth(self.view.bounds)/4;
    
    
    self.textField.frame = CGRectMake(0, 0, width, itemHeight);
    self.webView.frame = CGRectMake(0, CGRectGetMaxY(self.textField.frame), width, browserHeight);
    
    //positions buttons
    
    CGFloat currentButtonX = 0;
    
    for (UIButton *thisButton in @[self.backButton, self.forwardButton, self.stopButton, self.reloadButton]) {
        thisButton.frame = CGRectMake(currentButtonX, CGRectGetMaxY(self.webView.frame), buttonWidth, itemHeight);
        currentButtonX += buttonWidth;
    }
}
//adds the ability to enter websites

#pragma  mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    
    NSString *URLString = textField.text;
    
    NSURL *URL = [NSURL URLWithString:URLString];
    
    if (!URL.scheme) {
        URL = [NSURL URLWithString:[NSString stringWithFormat:@"http://", URLString]];
    }
    
    if (URL) {
        NSURLRequest *request = [NSURLRequest requestWithURL:URL];
        [self.webView loadRequest:request];
    }
    
    return NO;
}

- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *) navigation withError:(NSError *)error {
    [self webView:webView didFailNavigation:navigation withError:error];
}

//this handles errors in web loading

#pragma  mark - WKNavigattionDelegate

- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error
{
    if (error.code != NSURLErrorCancelled) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Error", @"Error")
                                                                       message:[error localizedDescription]
                                                                preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"OK", nil)
                                                           style:UIAlertActionStyleCancel handler:nil];
        
        [alert addAction:okAction];
        
        [self presentViewController:alert animated:YES completion:nil];
    }
}



@end
