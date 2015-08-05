
#import "Activity.h"

@implementation Activity

-(id) initWithDict:(NSDictionary *)json {
    self = [super initWithDict: json];
    if(self) {
        self.type = [json objectForKey:@"type"];
        NSDictionary *user = [json objectForKey:@"creator"];
        User *creator = [[User alloc]initWithDict:user];
        self.creator = creator;
    }
    return self;
}
    
-(NSDictionary*) convertToDict {
    NSMutableDictionary *dict = [super convertToDict].mutableCopy;
    [dict setObject:self.type forKey:@"type"];
    NSDictionary *creator = [self.creator convertToDict];
    [dict setObject:creator forKey:@"creator"];
    return dict;
}

@end