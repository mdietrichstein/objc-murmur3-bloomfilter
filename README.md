# Objective-C Bloom Filter implementation

An Objective-C Bloom Filter implementation using 128 Bit (x64) Murmur3 Hashing. Hashes are generated using the Double Hashing Methond described in [Less Hashing, Same Performance: Building a Better Bloom Filter](https://www.eecs.harvard.edu/~michaelm/postscripts/tr-02-05.pdf). 

## Usage

```objc
NSUInteger expectedNumberOfItems = 10000;
double falsePositiveRate = 0.01;
uint32_t seed = 1234;
    
BloomFilter *bloomFilter = [[BloomFilter alloc] initWithExceptedNumberOfItems:expectedNumberOfItems falsePositiveRate:falsePositiveRate seed:seed];

// Containment
NSString *containedId = [[NSUUID UUID] UUIDString];
NSData *containedData = [containedId dataUsingEncoding:NSUTF8StringEncoding];
 
[bloomFilter add:containedData];
NSAssert([bloomFilter contains:containedData] == YES);

NSString *invalidId = [[NSUUID UUID] UUIDString];
NSData *invalidData = [containedId dataUsingEncoding:NSUTF8StringEncoding];
NSAssert([bloomFilter contains:invalidData] == NO);

// Serialization

BloomFilter *deserializedBloomFilter = [[BloomFilter alloc] initWithData:bloomFilter.data exceptedNumberOfItems:expectedNumberOfItems falsePositivePercentage:falsePositiveRate seed:seed];

NSAssert([deserializedBloomFilter contains:containedData] == YES);
NSAssert([deserializedBloomFilter contains:invalidData] == NO);
```

## Resources

* [Bloom Filter (Wikipedia)](https://en.wikipedia.org/wiki/Bloom_filter)
* [Murmur3 hash implementation (C++)](https://github.com/aappleby/smhasher/blob/master/src/MurmurHash3.cpp)
* [Less Hashing, Same Performance: Building a Better Bloom Filter (pdf)](https://www.eecs.harvard.edu/~michaelm/postscripts/tr-02-05.pdf)

