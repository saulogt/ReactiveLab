//
//  BasicLoginFormViewController.m
//  ReactiveLab
//
//  Created by Saulo G Tauil on 27/07/14.
//  Copyright (c) 2014 Saulo G Tauil. All rights reserved.
//

#import "BasicLoginFormViewController.h"
#import <ReactiveCocoa.h>
#import <RACEXTScope.h>

@interface BasicLoginFormViewController ()
@property (weak, nonatomic) IBOutlet UITextField *txtLogin;
@property (weak, nonatomic) IBOutlet UITextField *txtPassword;
@property (weak, nonatomic) IBOutlet UIButton *btnSubmit;

@end

#define MINIMUMLOGINSIZE 5

@implementation BasicLoginFormViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void) setupSignals
{
    RACSignal* loginTextSignal = self.txtLogin.rac_textSignal;
    RACSignal* passwordTextSignal = self.txtPassword.rac_textSignal;
    
    RACSignal* loginFormatIsOk = [loginTextSignal map:^NSNumber*(NSString* value) {
        
        if ([value length] < 5)
            return @(NO);
        
        NSError *error = NULL;
        NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"\\b[A-Z0-9._%+-]+@[A-Z0-9.-]+\\.[A-Z]{2,4}\\b"
                                                                               options:NSRegularExpressionCaseInsensitive
                                                                                 error:&error];
        
        NSUInteger numberOfMatches = [regex numberOfMatchesInString:value
                                                            options:0
                                                              range:NSMakeRange(0, [value length])];

        return (numberOfMatches == 1 ? @(YES) : @(NO));
        
    }];
    
    RACSignal* passwordIsOk = [passwordTextSignal map:^NSNumber*(NSString* value) {
        
        if ([value length] < 5)
            return @(NO);
        return @(YES);
    }];

    
    
    RACSignal* formValid =
    [RACSignal
     combineLatest:@[loginFormatIsOk, passwordIsOk] reduce:^id( NSNumber* loginOk,
                                                              NSNumber* pwdOk){
         return @([loginOk boolValue] && [pwdOk boolValue]);
         
     }];
    
    // Use a command to encapsulate the validity and in-flight check.
	RACCommand *doNetworkStuff = [[RACCommand alloc] initWithEnabled:formValid signalBlock:^RACSignal *(id input) {
        // Wait 3 seconds and then send a random YES/NO.
        return [[[RACSignal interval:3 onScheduler:[RACScheduler currentScheduler]] take:1] flattenMap:^RACStream *(id value) {
            BOOL success = arc4random() % 2;
            return [RACSignal return:@(success)];
        }];
    }];



	RACSignal *networkResults = [[doNetworkStuff.executionSignals
                                  // -addSignalBlock: returns a signal of signals. We only care about the
                                  // latest (most recent).
                                  switchToLatest]
                                 deliverOn:RACScheduler.mainThreadScheduler];

    
    self.btnSubmit.rac_command = doNetworkStuff;
    
    [networkResults subscribeNext:^(id x) {
        //
        NSLog(@"next : %@", x);
    } error:^(NSError *error) {
        //
        NSLog(@"error : %@", error);
    } completed:^{
        //
        NSLog(@"completed");
    }];
    
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setupSignals];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
