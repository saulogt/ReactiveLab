//
//  SerializedTasksViewController.m
//  ReactiveLab
//
//  Created by Saulo G Tauil on 30/07/14.
//  Copyright (c) 2014 Saulo G Tauil. All rights reserved.
//

#import "SerializedTasksViewController.h"
#import <ReactiveCocoa.h>
#import <RACEXTScope.h>

@interface SerializedTasksViewController ()
@property (weak, nonatomic) IBOutlet UIButton *btnStart;
@property (weak, nonatomic) IBOutlet UIButton *btnStrtInterruptedByError;

@property (weak, nonatomic) IBOutlet UITextView *txtLog;

@property (nonatomic) RACDisposable* operation;

@end

@implementation SerializedTasksViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (void)addLog:(NSString *)log
{
    @weakify(self);
    dispatch_async(dispatch_get_main_queue(), ^{
        @strongify(self);
        [self.txtLog setText:[NSString stringWithFormat:@"%@\n%@", self.txtLog.text, log]];
    });
}

-(void) setupSignals
{
    @weakify(self);
    [[self.btnStart rac_signalForControlEvents:UIControlEventTouchUpInside]
     subscribeNext:^(id x) {
         @strongify(self);
         [self addLog:@"start btn clicked"];
         //
         
         [[[self mainTask: NO] concat] subscribeNext:^(id x) {
             [self addLog: [NSString stringWithFormat: @"mainSubscription next: %@", x]];
         } error:^(NSError *error) {
             [self addLog: [NSString stringWithFormat: @"mainSubscription error: %@", error]];
         } completed:^{
             [self addLog: @"mainSubscription completed"];
         }];
         
     }];
    
    [[self.btnStrtInterruptedByError rac_signalForControlEvents:UIControlEventTouchUpInside]
     subscribeNext:^(id x) {
         @strongify(self);
         [self addLog:@"start btn clicked"];
         //
         
         [[[self mainTask: YES] concat] subscribeNext:^(id x) {
             [self addLog: [NSString stringWithFormat: @"mainSubscription next: %@", x]];
         } error:^(NSError *error) {
             [self addLog: [NSString stringWithFormat: @"mainSubscription error: %@", error]];
         } completed:^{
             [self addLog: @"mainSubscription completed"];
         }];
         
     }];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self addLog:@"view loaded\nwaiting for start..."];
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

-(RACSignal*) task1
{
    @weakify(self);
    return[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        @strongify(self);
        //
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
            sleep(2);
            [subscriber sendNext: @"task1 data"];
            [subscriber sendCompleted];
            
        });
        return [RACDisposable disposableWithBlock:^{
            
        }];
        
    }];
}


-(RACSignal*) task2
{
    @weakify(self);
    return[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        @strongify(self);
        //
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
            sleep(1);
            [subscriber sendNext: @"task2 data"];
            [subscriber sendCompleted];
        });
        
        return [RACDisposable disposableWithBlock:^{
            
        }];
        
    }];
}

-(RACSignal*) task3
{
    @weakify(self);
    return[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        @strongify(self);
        //
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
            sleep(0);
            [subscriber sendNext: @"task3 data"];
            [subscriber sendCompleted];
        });
        return [RACDisposable disposableWithBlock:^{
            
        }];
        
    }];
}

-(RACSignal*) task4
{
    @weakify(self);
    return[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        @strongify(self);
        //
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
            sleep(3);
            [subscriber sendNext: @"task4 data"];
            [subscriber sendCompleted];
        });
        return [RACDisposable disposableWithBlock:^{
            
        }];
        
    }];
}


-(RACSignal*) taskWithError
{
    @weakify(self);
    return[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        @strongify(self);
        //
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
            sleep(3);
            [subscriber sendError:[NSError errorWithDomain:@"teste" code:1000 userInfo:nil]];
        });
        
        return [RACDisposable disposableWithBlock:^{
            
        }];
        
    }];
}



-(RACSignal*) mainTask : (BOOL) withError
{
    @weakify(self);
    
    return[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        //
        @strongify(self);
        [subscriber sendNext: [self task1]];
        if (withError)
        {
            [subscriber sendNext: [self taskWithError]];
        }
        [subscriber sendNext: [self task2]];
        [subscriber sendNext: [self task3]];
        [subscriber sendNext: [self task4]];
        [subscriber sendCompleted];
        
        return [RACDisposable disposableWithBlock:^{
            [self addLog:@"mainTask about to dispose"];
        }];
        
    }];
    
}

@end
