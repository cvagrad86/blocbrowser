//
//  ViewController.m
//  BlocBrowser
//
//  Created by Eric Chamberlin on 11/5/15.
//  Copyright © 2015 Eric Chamberlin. All rights reserved.
//

#import "ViewController.h"
#import <WebKit/WebKit.h>
#import "AwesomeFloatingToolbar.h"


#define kWebBrowserBackString NSLocalizedString(@"Back", @"Back command")
#define kWebBrowserForwardString NSLocalizedString(@"Forward", @"Forward command")
#define kWebBrowserStopString NSLocalizedString(@"Stop", @"Stop command")
#define kWebBrowserRefreshString NSLocalizedString(@"Refresh", @"Reload command")

@interface ViewController () <WKNavigationDelegate, UITextFieldDelegate, AwesomeFloatingToolbarDelegate>

@property (nonatomic, strong) WKWebView *webView;
@property (nonatomic, strong) UITextField *textField;
//@property (nonatomic, strong) UIButton *backButton;
//@property (nonatomic, strong) UIButton *forwardButton;
//@property (nonatomic, strong) UIButton *stopButton;
//@property (nonatomic, strong) UIButton *reloadButton;
@property (nonatomic, strong) UIActivityIndicatorView *activityIndicator;
@property (nonatomic, strong) AwesomeFloatingToolbar *awesomeToolbar;


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
    self.textField.placeholder = NSLocalizedString(@"WebsiteURL", @"You can also enter a search phrase here");
    self.textField.backgroundColor = [UIColor colorWithWhite:220/225.0f alpha:1];
    self.textField.delegate = self;
    
    //organizes the buttons
    /* old code before we made our own custom buttons
    self.backButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.backButton setEnabled:NO];
    
    self.forwardButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.forwardButton setEnabled:NO];
    
    self.stopButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.stopButton setEnabled:NO];
    
    self.reloadButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.reloadButton setEnabled:NO];
     */
    
    self.awesomeToolbar = [[AwesomeFloatingToolbar alloc] initWithFourTitles:@[kWebBrowserBackString, kWebBrowserForwardString, kWebBrowserStopString, kWebBrowserRefreshString]];
    self.awesomeToolbar.delegate = self;
    
    
    /*
    [self.backButton setTitle:NSLocalizedString(@"Back", @"Back command") forState:UIControlStateNormal];
    
    
    [self.forwardButton setTitle:NSLocalizedString(@"Forward", @"Forward command") forState:UIControlStateNormal];
    
    
    [self.stopButton setTitle:NSLocalizedString(@"Stop", @"Stop command") forState:UIControlStateNormal];
    
    
    [self.reloadButton setTitle:NSLocalizedString(@"Refresh", @"Reload command") forState:UIControlStateNormal];
   
    
    [self addButtonTargets];
     */
    
    
    //hardcoding to a website
    //NSString *urlString = @"http://www.bloc.io";
    //NSURL *url = [NSURL URLWithString:urlString];
    //NSURLRequest *request = [NSURLRequest requestWithURL:url];
    //[self.webView loadRequest:request];
    
    
    //tighter code replacing the old code
    
    for (UIView *viewToAdd in @[self.webView, self.textField, self.awesomeToolbar]) {
        [mainView addSubview:viewToAdd];
    }
    
    self.view = mainView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    self.activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.activityIndicator];
    
    //moved here as it conflicted with pinching in layoutSubViews - which is called when a subview is resized
    self.awesomeToolbar.frame = CGRectMake(20, 100, 280, 60);
}

-(void) viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    //self.webView.frame = self.view.frame;
    
    static const CGFloat itemHeight = 50;
   // CGFloat width = CGRectGetWidth(self.view.bounds);
    CGFloat browserHeight = CGRectGetHeight(self.view.bounds) - itemHeight;
    //CGFloat buttonWidth = CGRectGetWidth(self.view.bounds)/4;
    
    
    self.textField.frame = CGRectMake(0, 0, 600, itemHeight);
    self.webView.frame = CGRectMake(0, CGRectGetMaxY(self.textField.frame), 600, browserHeight);
    
    //positions buttons
    
    //CGFloat currentButtonX = 0;
    
    //for (UIButton *thisButton in @[self.backButton, self.forwardButton, self.stopButton, self.reloadButton]) {
    //    thisButton.frame = CGRectMake(currentButtonX, CGRectGetMaxY(self.webView.frame), buttonWidth, itemHeight);
    //    currentButtonX += buttonWidth;
    
}



//adds the ability to enter websites

#pragma  mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    
    NSString *URLString = textField.text;
    
    //this is my attempt to get Google to search when a phrase is entered in the search bar - it works
    // but it loads safari and completes the search
    
    //NSString *searchString=textField.text;
    //NSString *urlAddress = [NSString stringWithFormat:@"http://www.google.com/search?q=%@",searchString];
    //[[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlAddress]];
    
    NSURL *URL = [NSURL URLWithString:URLString];
    
    if (!URL.scheme) {
        URL = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@", URLString]];
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

-(void) webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    [self updateButtonsandTitle];
}
- (void) webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    [self updateButtonsandTitle];

}

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
    
    [self updateButtonsandTitle];
    
}

# pragma mark - Miscellaneous

-(void) updateButtonsandTitle {
    
    NSString *webpageTitle = [self.webView.title copy];
    if ([webpageTitle length]) {
        self.title = webpageTitle;
    
    } else {
        self.title = self.webView.URL.absoluteString;
    }
    
    if (self.webView.isLoading) {
        [self.activityIndicator startAnimating];
    } else {
        [self.activityIndicator stopAnimating];
    }
    //self.backButton.enabled = [self.webView canGoBack];
    //self.forwardButton.enabled = [self.webView canGoForward];
    //self.stopButton.enabled = self.webView.isLoading;
    //self.reloadButton.enabled = !self.webView.isLoading;
    //self.reloadButton.enabled = !self.webView.isLoading && self.webView.URL;
    
    [self.awesomeToolbar setEnabled:[self.webView canGoBack] forButtonWithTitle:kWebBrowserBackString];
    [self.awesomeToolbar setEnabled:[self.webView canGoForward] forButtonWithTitle:kWebBrowserForwardString];
    [self.awesomeToolbar setEnabled:[self.webView isLoading] forButtonWithTitle:kWebBrowserStopString];
    [self.awesomeToolbar setEnabled:![self.webView isLoading] && self.webView.URL forButtonWithTitle:kWebBrowserRefreshString];
}

- (void) resetWebView {
    [self.webView removeFromSuperview];
    
    WKWebView *newWebView = [[WKWebView alloc] init];
    newWebView.navigationDelegate = self;
    [self.view addSubview:newWebView];
    
    self.webView = newWebView;
    
    //[self addButtonTargets];
    
    self.textField.text = nil;
    //[self updateButtonsAndTitle];
}




#pragma mark - AwesomeFloatingToolbarDelegate

- (void) floatingToolbar:(AwesomeFloatingToolbar *)toolbar didSelectButtonWithTitle:(NSString *)title {
    if ([title isEqual:NSLocalizedString(@"Back", @"Back command")]) {
        [self.webView goBack];
    } else if ([title isEqual:NSLocalizedString(@"Forward", @"Forward command")]) {
        [self.webView goForward];
    } else if ([title isEqual:NSLocalizedString(@"Stop", @"Stop command")]) {
        [self.webView stopLoading];
    } else if ([title isEqual:NSLocalizedString(@"Refresh", @"Reload command")]) {
        [self.webView reload];
    }
}

- (void)  panToolbar:(UIPanGestureRecognizer *)recognizer {
    CGPoint startingPoint = recognizer.view.frame.origin;
    CGPoint translation = [recognizer translationInView:recognizer.view];
    CGPoint newPoint = CGPointMake(startingPoint.x + translation.x, startingPoint.y + translation.y);
    
    CGRect potentialNewFrame = CGRectMake(newPoint.x, newPoint.y, CGRectGetWidth(recognizer.view.frame), CGRectGetHeight(recognizer.view.frame));
    
    if (CGRectContainsRect(self.view.bounds, potentialNewFrame)) {
      recognizer.view.frame = potentialNewFrame;
    }
}

-(void) pinchToolbar:(UIPinchGestureRecognizer *)pinch {
    CGAffineTransform transform = CGAffineTransformMakeScale(pinch.scale, pinch.scale);

    UIView *testGig = [[UIView alloc] initWithFrame:self.awesomeToolbar.frame];

    testGig.transform = transform;
    
    if (CGRectContainsRect(self.view.bounds, testGig.frame)){
        pinch.view.transform = transform;
    }
}
@end
