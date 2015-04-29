//
//  PCMarker.m
//  Patient_Care
//
//  Created by Paresh on 29/04/15.
//  Copyright (c) 2015 JoseAlvarado. All rights reserved.
//

#import "PCMarker.h"

@implementation PCMarker

-(BOOL)isEqual:(id)object{
    PCMarker *otherMarker = (PCMarker *)object;
    if(self.objectDate == otherMarker.objectDate ) {
        return YES;
    }
    return NO;
}

-(NSUInteger)hash{
    return [self.objectDate hash];
}
@end
