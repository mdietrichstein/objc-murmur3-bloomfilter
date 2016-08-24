#import <Foundation/Foundation.h>

@interface BloomFilter : NSObject

@property (readonly) uint32_t seed;
@property (readonly) NSUInteger expectedNumberOfItems;
@property (readonly) double falsePositivePercentage;
@property (readonly) NSUInteger numberOfBits;
@property (readonly) NSUInteger numberHashes;

- (id)initWithExceptedNumberOfItems:(NSUInteger)expectedNumberOfItems falsePositiveRate:(double)falsePositiveRate seed:(uint32_t)seed;
- (id)initWithData:(NSData *) data exceptedNumberOfItems:(NSUInteger)expectedNumberOfItems falsePositivePercentage:(double)falsePositiveRate seed:(uint32_t)seed;
- (void) add:(NSData *)data;
- (BOOL) contains:(NSData *)data;
- (NSData *)data;

@end