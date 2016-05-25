//
//  HFAnnotationView.m
//  FindDoctor
//
//  Created by ZhuHaoRan on 16/5/24.
//  Copyright © 2016年 li na. All rights reserved.
//

#define minHitWidth 44
#define minHitHeight 44

#import "HFAnnotationView.h"

@implementation HFAnnotationView


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (id)initWithAnnotation:(id<BMKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    if (self) {

        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(updateAction)];
        [self addGestureRecognizer:tap];
    }
    return self;
}

- (void)updateAction{
    NSDictionary * dict = @{@"annotationView":self};
    [[NSNotificationCenter defaultCenter] postNotificationName:@"update" object:nil userInfo:dict];
    NSLog(@"不服啊");
}

- (BOOL)pointInside:(CGPoint)point withEvent:(nullable UIEvent *)event {
    CGRect rect = [self HitTestingBounds:self.bounds withWidth:minHitWidth withHeight:minHitHeight];
    NSLog(@"%d", CGRectContainsPoint(rect, point));
    
    NSString *str = NSStringFromCGRect(self.frame);
    NSLog(@"%@",str);
    return CGRectContainsPoint(rect, point);
}

- (CGRect)HitTestingBounds:(CGRect)bounds withWidth:(CGFloat)width withHeight:(CGFloat)height {
    CGRect hitTestingBounds = bounds;
    if (width > bounds.size.width) {
        hitTestingBounds.size.width = width;
        hitTestingBounds.origin.x -= (hitTestingBounds.size.width - bounds.size.width)/2;
    }
    if (height > bounds.size.height) {
        hitTestingBounds.size.height = height;
        hitTestingBounds.origin.y -= (hitTestingBounds.size.height - bounds.size.height)/2;
    }
    return hitTestingBounds;
}


@end
