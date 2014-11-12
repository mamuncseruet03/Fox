#import <Cedar/Cedar.h>
#import "PBT.h"
#import "PBTSpecHelper.h"
#import "PBTArrayGenerators.h"

using namespace Cedar::Matchers;
using namespace Cedar::Doubles;


SPEC_BEGIN(PBTArraySpec)

describe(@"PBTArray", ^{
    it(@"should be able to shrink to an empty array", ^{
        PBTRunnerResult *result = [PBTSpecHelper shrunkResultForAll:PBTArray(PBTInteger())];
        result.succeeded should be_falsy;
        result.smallestFailingValue should equal(@[]);
    });

    it(@"should be able to shrink elements of the array", ^{
        PBTRunnerResult *result = [PBTSpecHelper resultForAll:PBTArray(PBTInteger()) then:^BOOL(NSArray *values) {
            return [values count] <= 2;
        }];
        result.succeeded should be_falsy;
        result.smallestFailingValue should equal(@[@0, @0, @0]);
    });

    it(@"should be able to shrink elements of the nested array", ^{
        PBTRunnerResult *result = [PBTSpecHelper resultForAll:PBTArray(PBTArray(PBTInteger())) then:^BOOL(NSArray *values) {
            return [values count] <= 1;
        }];
        result.succeeded should be_falsy;
        result.smallestFailingValue should equal(@[@[], @[]]);
    });

    it(@"should be able to return arrays of any size", ^{
        NSMutableSet *sizesSeen = [NSMutableSet set];
        PBTRunnerResult *result = [PBTSpecHelper resultForAll:PBTArray(PBTInteger()) then:^BOOL(id value) {
            BOOL isValid = YES;
            for (id element in value) {
                if (![element isKindOfClass:[NSNumber class]]) {
                    isValid = NO;
                }
            }
            [sizesSeen addObject:@([value count])];
            return isValid;
        }];
        result.succeeded should be_truthy;
        sizesSeen.count should be_greater_than(1);
    });

    it(@"should be able to return arrays of a given size", ^{
        PBTRunnerResult *result = [PBTSpecHelper resultForAll:PBTArray(PBTInteger(), 5) then:^BOOL(id value) {
            return [value count] == 5;
        }];
        result.succeeded should be_truthy;
    });

    it(@"should be able to return arrays of a given size range", ^{
        PBTRunnerResult *result = [PBTSpecHelper resultForAll:PBTArray(PBTInteger(), 5, 10) then:^BOOL(id value) {
            NSUInteger count = [value count];
            return count >= 5 && count <= 10;
        }];
        result.succeeded should be_truthy;
    });
});

SPEC_END