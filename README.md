#AFHTTPSessionManager-RACExtensions
AFHTTPSessionManager usage via ReactiveCocoa (ReactiveCocoa + AFNetworking)


## Contents
- [Description](#description)
- [Usage](#usage)
- [Example](#example)
- [Contact](#contact)
- [License](#license)

## Description
Inspired by [AFNetworking-RACExtensions](https://github.com/CodaFi/AFNetworking-RACExtensions)

It takes functionallity from [this](https://github.com/CodaFi/AFNetworking-RACExtensions/blob/master/RACAFNetworking/AFHTTPSessionManager%2BRACSupport.m)
and change it code to make more readable and open for change. Simple and helpful, enjoy.

Using
[AFNetworking (3.1.0)](https://github.com/AFNetworking/AFNetworking/tree/3.1.0)
[ReactiveCocoa (2.5)](https://github.com/ReactiveCocoa/ReactiveCocoa/tree/v2.5)

##Usage
Normally, we create a network layer manager and configure it to use AFNetworking :

```Objective-C
- (instancetype) init
{
    self                              = [super init];
    NSURL *baseURL                    = [NSURL URLWithString:kBaseURL];
    _sessionManager                   = [[AFHTTPSessionManager alloc] initWithBaseURL:baseURL];
    _sessionManager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    return self;
}
```

Nothing specific.
Next step is to have your net methods in NetworkManager.h 
Just like this:

```Objective-C
@interface NetworkManager : NSObject

+ (instancetype)sharedManager;

- (RACSignal *)postAdWithTitle:(NSString *)title
                   description:(NSString *)description
                        cityId:(NSNumber *)cityId
                          cost:(NSNumber *)cost
                    currencyId:(NSNumber *)currencyId
                      imageIds:(NSArray *)imageIds;
@end
```
Then you go to implement them (in NetworkManager.m) :

```Objective-C
@interface NetworkManager ()
@property (strong, nonatomic) AFHTTPSessionManager *sessionManager;

@end

static NSString * const kBaseURL           = @"http://<#your-api-base-url#>";
static NSString * const kPostNewAd         = @"advertisement/postAd";

@implementation NetworkManager

#pragma mark - Initialization

+ (instancetype)sharedManager
{
    static NetworkManager *sharedManager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [self new];
    });
    
    return sharedManager;
}

- (instancetype) init
{
    self                              = [super init];
    NSURL *baseURL                    = [NSURL URLWithString:kBaseURL];
    _sessionManager                   = [[AFHTTPSessionManager alloc] initWithBaseURL:baseURL];
    _sessionManager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    return self;
}

#pragma mark - Adverts

- (RACSignal *)postAdWithTitle:(NSString *)title
                   description:(NSString *)description
                        cityId:(NSNumber *)cityId
                          cost:(NSNumber *)cost
                    currencyId:(NSNumber *)currencyId
                         years:(NSNumber *)years
                      imageIds:(NSArray *)imageIds
{
    NSDictionary *parameters = @{@"title" : title,
                                 <#all other parameters#>
                                 };
    
    NSLog(@"NetworkManager post ad with parameters : %@",parameters);
    
    return [_sessionManager rac_requestWithMethod:POST
                                              URL:kPostNewAd
                                       parameters:parameters];
}
@end
```
So, next step is to use it:

```Objective-C
[[NetworkManager sharedManager] postAdWithTitle:_title
                                    description:_descr
                                         cityId:_city.id
                                           cost:_cost
                                     currencyId:_currencyId
                                       imageIds:imageIds] 
     subscribeNext:^(id x) {
         NSLog(@"testPostAd : %@",x);
     }
     error:^(NSError *error) {
         NSLog(@"Error testPostAd : %@", error);
     }];
```
##Example
You can find real usage example in [PixabayTest app](https://github.com/Maxatma/Pixabay), it's really simple, but hope useful.

Just go into [/PixabayTest/Model/Network/PBApiManager](https://github.com/Maxatma/Pixabay/blob/master/PixabayTest/Model/Network/PBApiManager.m)

You also can download and play with it

##Contact

Aleksandr Zaporozhchenko
[[github]](https://github.com/Maxatma)  [[gmail]](mailto:maxatma.ids@gmail.com)  [[fb]](https://www.facebook.com/profile.php?id=100008291260780)  [[in]](https://www.linkedin.com/in/maxatma/)


## License

AFHTTPSessionManager-RACExtensions is released under the MIT license. See LICENSE for details.
