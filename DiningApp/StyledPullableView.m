
#import "StyledPullableView.h"

/**
 @author Fabio Rodella fabio@crocodella.com.br
 */

@implementation StyledPullableView

- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        
        UIImageView *imgView = [[UIImageView alloc] init];
        CGRect currentScreen = [[UIScreen mainScreen] bounds];

        if (currentScreen.size.height==568.000000) {
            imgView.frame = CGRectMake(0,0,240,320);
            imgView.image = [UIImage imageNamed:@"pullable320.png"];
            
        } else {
            imgView.frame = CGRectMake(0, 0, 240, 240);
            imgView.image = [UIImage imageNamed:@"pullable240.png"];
        }

        
        [self addSubview:imgView];
        [imgView release];
    }
    return self;
}

@end
