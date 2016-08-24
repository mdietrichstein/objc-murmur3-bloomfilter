#import <XCTest/XCTest.h>
#import "BloomFilter.h"

@interface Murmur3BloomFilterTestCase : XCTestCase

@end

@implementation Murmur3BloomFilterTestCase

- (void)testInsertAndFind {
    NSUInteger expectedNumberOfItems = 1000;
    double falsePositiveRate = 0.01;
    uint32_t seed = 1234;
    
    BloomFilter *bloomFilter = [[BloomFilter alloc] initWithExceptedNumberOfItems:expectedNumberOfItems falsePositiveRate:falsePositiveRate seed:seed];
    
    NSMutableSet *included = [NSMutableSet new];
    for(NSUInteger i = 0; i < 100; i ++) {
        [included addObject:[[[NSUUID UUID] UUIDString] dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
    for(NSData *uuid in included) {
        [bloomFilter add:uuid];
    }
    
    for(NSData *uuid in included) {
        XCTAssertTrue([bloomFilter contains:uuid]);
    }
}

// Should (probably ;)) fail
- (void) testFalsePositive {
    NSUInteger expectedNumberOfItems = 100;
    double falsePositiveRate = 0.2;
    uint32_t seed = 1234;
    
    BloomFilter *bloomFilter = [[BloomFilter alloc] initWithExceptedNumberOfItems:expectedNumberOfItems falsePositiveRate:falsePositiveRate seed:seed];
    
    NSMutableSet *included = [NSMutableSet new];
    for(NSUInteger i = 0; i < 100; i ++) {
        [included addObject:[[[NSUUID UUID] UUIDString] dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
    NSMutableSet *excluded = [NSMutableSet new];
    for(NSUInteger i = 0; i < 500; i ++) {
        [excluded addObject:[[[NSUUID UUID] UUIDString] dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
    for(NSData *uuid in included) {
        [bloomFilter add:uuid];
    }
    
    for(NSData *uuid in included) {
        XCTAssertTrue([bloomFilter contains:uuid]);
    }
    
    NSUInteger numberOfFalsePositives = 0;
    
    for(NSData *uuid in excluded) {
        if([bloomFilter contains:uuid]) {
            numberOfFalsePositives++;
        }
    }
    
    XCTAssertNotEqual(numberOfFalsePositives, 0);
}


- (void) testSerialization {
    NSUInteger expectedNumberOfItems = 10000;
    double falsePositiveRate = 0.01;
    uint32_t seed = 1234;
    
    BloomFilter *bloomFilter = [[BloomFilter alloc] initWithExceptedNumberOfItems:expectedNumberOfItems falsePositiveRate:falsePositiveRate seed:seed];
    
    NSMutableSet *included = [NSMutableSet new];
    for(NSUInteger i = 0; i < 100; i ++) {
        [included addObject:[[[NSUUID UUID] UUIDString] dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
    NSMutableSet *excluded = [NSMutableSet new];
    for(NSUInteger i = 0; i < 100; i ++) {
        [excluded addObject:[[[NSUUID UUID] UUIDString] dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
    for(NSData *uuid in included) {
        [bloomFilter add:uuid];
    }
    
    for(NSData *uuid in included) {
        XCTAssertTrue([bloomFilter contains:uuid]);
    }
    
    for(NSData *uuid in excluded) {
        XCTAssertFalse([bloomFilter contains:uuid]);
    }
    
    BloomFilter *deserializedBloomFilter = [[BloomFilter alloc] initWithData:bloomFilter.data exceptedNumberOfItems:expectedNumberOfItems falsePositivePercentage:falsePositiveRate seed:seed];
    
    for(NSData *uuid in included) {
        XCTAssertTrue([deserializedBloomFilter contains:uuid]);
    }
    
    for(NSData *uuid in excluded) {
        XCTAssertFalse([deserializedBloomFilter contains:uuid]);
    }
}

@end
