
#import "SNTextFieldLimit.h"

@implementation SNTextFieldLimit
@synthesize limit,limitdelegate;

//- (id)initWithFrame:(CGRect)frame
//{
//    self = [super initWithFrame:frame];
//    if (self) {
//        limit=10;// -- Default limit
//        [super setDelegate:(id<SNTextFieldLimitDelegate,UITextFieldDelegate>)self];
//    }
//    return self;
//}
//
//- (id)initWithCoder:(NSCoder *)inCoder {
//    self = [super initWithCoder:inCoder];
//    if (self) {
//        limit=10;// -- Default limit
//        [super setDelegate:(id<SNTextFieldLimitDelegate,UITextFieldDelegate>)self];
//    }
//    return self;
//}

-(long)limit {
    return limit;
}


-(void)setLimit:(long)theLimit {
    limit=theLimit;
    [self textField:self shouldChangeCharactersInRange:NSMakeRange(0, 0) replacementString:@""];
}



- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    long MAXLENGTH=limit;
    NSString *newText = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if(newText.length==MAXLENGTH)
    {//Did reach limit
        if([self.limitdelegate respondsToSelector:@selector(textFieldLimit:didReachLimitWithLastEnteredText:inRange:)]) {
            [self.limitdelegate textFieldLimit:self didReachLimitWithLastEnteredText:string inRange:NSMakeRange(range.location, string.length)];
        }
    }
    if(newText.length>MAXLENGTH)
    {
        if([self.limitdelegate respondsToSelector:@selector(textFieldLimit:didWentOverLimitWithDisallowedText:inDisallowedRange:)]) {
            [self.limitdelegate textFieldLimit:self didWentOverLimitWithDisallowedText:string inDisallowedRange:NSMakeRange(range.location, string.length)];
        }
        if([self.delegate respondsToSelector:@selector(textField:shouldChangeCharactersInRange:replacementString:)]) {
            return [self.delegate textField:self shouldChangeCharactersInRange:range replacementString:string];
        }
        return NO;
    }
    
    if([self.delegate respondsToSelector:@selector(textField:shouldChangeCharactersInRange:replacementString:)]) {
        return [self.delegate textField:self shouldChangeCharactersInRange:range replacementString:string];
    }
    
    return YES;
}

//-(void)textFieldDidEndEditing:(UITextField *)textField {
//    if([self.delegate respondsToSelector:@selector(textFieldDidEndEditing:)]) {
//        [self.delegate textFieldDidEndEditing:self];//UITextFieldDelegate
//    }
//}
//-(void)textFieldDidBeginEditing:(UITextField *)textField {
//    if([self.delegate respondsToSelector:@selector(textFieldDidBeginEditing:)]) {
//        [self.delegate textFieldDidBeginEditing:self];//UITextFieldDelegate
//    }
//}
//
//
//
////UITextFieldDelegate
//-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
//    if([self.delegate respondsToSelector:@selector(textFieldShouldBeginEditing:)]) {
//        return [self.delegate textFieldShouldBeginEditing:self];
//    }
//    return YES;
//}
//-(BOOL)textFieldShouldClear:(UITextField *)textField {
//    if([self.delegate respondsToSelector:@selector(textFieldShouldClear:)]) {
//        return [self.delegate textFieldShouldClear:self];
//    }
//    return YES;
//}
//-(BOOL)textFieldShouldEndEditing:(UITextField *)textField {
//    if([self.delegate respondsToSelector:@selector(textFieldShouldEndEditing:)]) {
//        return [self.delegate textFieldShouldEndEditing:self];
//    }
//    return YES;
//}
//-(BOOL)textFieldShouldReturn:(UITextField *)textField {
//    if([self.delegate respondsToSelector:@selector(textFieldShouldReturn:)]) {
//        return [self.delegate textFieldShouldReturn:self];
//    }
//    return YES;
//}

@end
