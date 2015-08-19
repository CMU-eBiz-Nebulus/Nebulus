
#import "Activity.h"

//activity = {
//    "creator": <user>,
//    "data": <object(see below)> | optional({}),
//    "pictureUpdateTime": <time> | optional(0),
//    "recordingDuration": <int> | optional(0),
//    "recordingId": <ObjectID of recording> | optional(null),
//    "tags": <array of strings>,
//    "text": <string>,
//    "title": <string>,
//    "type": <enum(see below)>
//}

@implementation Activity

-(NSNumber *)pictureUpdateTime{
    if(!_pictureUpdateTime) _pictureUpdateTime = [[NSNumber alloc]initWithInt:0];
    return _pictureUpdateTime;
}

-(NSArray *)tags{
    if(!_tags) _tags = @[];
    return _tags;
}

-(NSNumber *)recordingDuration{
    if (!_recordingDuration) _recordingDuration = [[NSNumber alloc]initWithInt:0];;
    return _recordingDuration;
}

-(NSString *)recordingId{
    if(!_recordingId) _recordingId = [NSNull null];
    return _recordingId;
}

-(id) initWithDict:(NSDictionary *)json {
    self = [super initWithDict: json];
    if(self) {
        NSDictionary *user = [json objectForKey:@"creator"];
        User *creator = [[User alloc]initWithDict:user];
        self.creator = creator;
        self.pictureUpdateTime = [json objectForKey:@"pictureUpdateTime"];
        self.recordingDuration = [json objectForKey:@"recordingDuration"];
        self.recordingId = [json objectForKey:@"recordingId"];
        self.tags = [json objectForKey:@"tags"];
        self.text = [json objectForKey:@"text"];
        self.title = [json objectForKey:@"title"];
        self.type = [json objectForKey:@"type"];
        if ([self.type isEqualToString:@"projectClassified"] || [self.type isEqualToString:@"userClassified"]) {
            NSNumber *fullfuilled = [json objectForKey:@"fullfuilled"];
            self.fullfuilled = fullfuilled;
        } else if ([self.type isEqualToString:@"projectShare"]) {
            self.editors = [User dictToArray:json withObjectName:@"editors"];
        }

        
    }
    return self;
}
    
-(NSDictionary*) convertToDict {
    NSMutableDictionary *dict = [super convertToDict].mutableCopy;

    NSDictionary *creator = [self.creator convertToDict];
    [dict setObject:creator forKey:@"creator"];
    [dict setObject:self.pictureUpdateTime forKey:@"pictureUpdateTime"];
    [dict setObject:self.recordingDuration forKey:@"recordingDuration"];
    [dict setObject:self.recordingId forKey:@"recordingId"];
    [dict setObject:self.tags forKey:@"tags"];
    [dict setObject:self.text forKey:@"text"];
    [dict setObject:self.title forKey:@"title"];
    [dict setObject:self.type forKey:@"type"];
    
    if ([self.type isEqualToString:@"projectClassified"] || [self.type isEqualToString:@"userClassified"]) {
        NSNumber *fullfuilled = [[NSNumber alloc]initWithBool: self.fullfuilled];
        [self setValue:fullfuilled forKey:@"fullfuilled"];
    } else if ([self.type isEqualToString:@"projectShare"]) {
        
        NSMutableArray *editors = [[NSMutableArray alloc]init];
        for (User *editor in self.editors) {
            [editors addObject:[editor convertToDict]];
        }
        [dict setObject:editors forKey:@"editors"];
    }
    return dict;
}

@end