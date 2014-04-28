//
//  CalcTableViewController.m
//  BTU-Calc-Air-Conditioner
//
//  Created by HP Developer on 27/04/14.
//  Copyright (c) 2014 Morbix. All rights reserved.
//

#import "CalcTableViewController.h"
#import "NSString+Common.h"
#import "GAI.h"
#import "GAIFields.h"
#import "GAIDictionaryBuilder.h"

@interface CalcTableViewController () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *textFieldMetros;
@property (weak, nonatomic) IBOutlet UITextField *textFieldPessoas;
@property (weak, nonatomic) IBOutlet UITextField *textFieldEletronicos;
@property (weak, nonatomic) IBOutlet UISwitch *switchSol;
@property (weak, nonatomic) IBOutlet UILabel *labelBTU;
@end

@implementation CalcTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.labelBTU.text = @"n/a";
    self.textFieldMetros.delegate = self;
    self.textFieldPessoas.delegate = self;
    self.textFieldEletronicos.delegate = self;
}

-(void)viewDidAppear:(BOOL)animated
{
    id tracker = [[GAI sharedInstance] defaultTracker];
    
    [tracker set:kGAIScreenName
           value:@"Main Screen"];
    
    [tracker send:[[GAIDictionaryBuilder createAppView] build]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Métodos
- (void)tryCalc
{
    self.labelBTU.text = @"n/a";
    
    if (self.textFieldMetros.text.isBlank) {
        return;
    }
    
    if (self.textFieldPessoas.text.isBlank) {
        return;
    }
    
    if (self.textFieldEletronicos.text.isBlank) {
        return;
    }
    
    int intResultMetros = 0;
    int intResultPessoas = 0;
    int intResultEletronicos = 0;
    int intResultSol = 0;
    @try {
        intResultMetros = self.textFieldMetros.text.intValue * 600;
        
        if (self.textFieldPessoas.text.intValue > 1) {
            intResultPessoas = (self.textFieldPessoas.text.intValue-1)*600;
        }else{
            intResultPessoas = 0;
        }
        
        intResultEletronicos = self.textFieldEletronicos.text.intValue * 600;
        
        if (self.switchSol.on) {
            intResultSol = 800;
        }else{
            intResultSol = 0;
        }
    }
    @catch (NSException *exception) {
        return;
    }
    
    int intResult = intResultMetros+intResultPessoas+intResultEletronicos+intResultSol;
    self.labelBTU.text = [NSString stringWithFormat:@"%d",intResult];
    
    // May return nil if a tracker has not already been initialized with a property
    // ID.
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    
    [tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"Calc"     // Event category (required)
                                                          action:@"Calc"  // Event action (required)
                                                           label:@""          // Event label
                                                           value:[NSNumber numberWithInt:intResult]] build]];    // Event value
}


#pragma mark - IBAction
- (IBAction)switchValueChanged:(id)sender
{
    [self tryCalc];
}

#pragma mark - UITextFieldDelegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == self.textFieldMetros) {
        [self.textFieldPessoas becomeFirstResponder];
    }else if (textField == self.textFieldPessoas) {
        [self.textFieldEletronicos becomeFirstResponder];
    }else if (textField == self.textFieldEletronicos) {
        [self.textFieldEletronicos resignFirstResponder];
    }
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [self tryCalc];
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (range.length > 0) {//Deletando caracteres
        textField.text = [textField.text stringByReplacingCharactersInRange:range
                                                                 withString:@""];
    }else{//Inserindo caracteres
        
        int intTest;
        @try {
            intTest = string.intValue;
        }
        @catch (NSException *exception) {
            return NO;
        }
        @finally {
            string = [NSString stringWithFormat:@"%d",intTest];
        }
        
        NSString *sStart = [textField.text substringToIndex:range.location];
        NSString *sEnd   = [textField.text substringFromIndex:range.location];
        
        textField.text = [NSString stringWithFormat:@"%@%@%@", sStart, string, sEnd];
    }
    
    return NO;
}

@end
