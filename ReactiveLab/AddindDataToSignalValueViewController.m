//
//  AddindDataToSignalValueViewController.m
//  ReactiveLab
//
//  Created by Saulo G Tauil on 12/08/14.
//  Copyright (c) 2014 Saulo G Tauil. All rights reserved.
//

#import "AddindDataToSignalValueViewController.h"
#import <RACEXTScope.h>
#import <ReactiveCocoa.h>

@interface AddindDataToSignalValueViewController ()
@property (weak, nonatomic) IBOutlet UITextField *txtInput;
@property (weak, nonatomic) IBOutlet UIButton *btnOriginalSignal;
@property (weak, nonatomic) IBOutlet UIButton *btnExtendedSignal;
@property (weak, nonatomic) IBOutlet UILabel *lblResult;

@end

@implementation AddindDataToSignalValueViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(RACSignal*) simpleSignalThatReturnsTheNumberOfCaracteres: (NSString*) input
{
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        
        [subscriber sendNext: @(input.length)];
        
        return [RACDisposable disposableWithBlock:^{
            //
        }];
    }];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    RACSignal* textSinal = [self.txtInput rac_textSignal];
    RACSignal* notEmpty = [textSinal map:^NSNumber*(NSString* value) {
        return @(![value isEqualToString:@""]);
    }];
    
    self.btnOriginalSignal.rac_command = [[RACCommand alloc] initWithEnabled:notEmpty signalBlock:^RACSignal *(id input) {
        
        [[self simpleSignalThatReturnsTheNumberOfCaracteres: self.txtInput.text]
        subscribeNext:^(NSNumber* x) {
            //
            
            self.lblResult.text = [x stringValue];
        
        } error:^(NSError *error) {
            //
        } completed:^{
            //
        }];
        
        return [RACSignal empty];
    }];
    
    
    
    self.btnExtendedSignal.rac_command = [[RACCommand alloc] initWithEnabled:notEmpty signalBlock:^RACSignal *(id input) {
        
        id text = self.txtInput.text;
        [[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
          
            [[self simpleSignalThatReturnsTheNumberOfCaracteres: text]
             subscribeNext:^(NSNumber* x) {
                 //
                 
                 [subscriber sendNext: x];
                 
             } error:^(NSError *error) {
                 //
                 [subscriber sendError:error];
             } completed:^{
                 //
                 [subscriber sendCompleted];
             }];
    
            
            return nil;
        }]
        subscribeNext:^(id x) {
            //
            self.lblResult.text = [NSString stringWithFormat:@"N=%@  input=%@", x, text];
        }];
        
        
        return [RACSignal empty];
    }];
 
    
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
