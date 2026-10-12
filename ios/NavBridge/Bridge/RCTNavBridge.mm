#import <ReactCodegen/NavBridgeSpec/NavBridgeSpec.h>
#import <React-RCTAppDelegate/RCTDefaultReactNativeFactoryDelegate.h>
#import "NavBridge-Swift.h"

@interface RCTNavBridge : NativeNavBridgeSpecBase <NativeNavBridgeSpec>
@end

@implementation RCTNavBridge

RCT_EXPORT_MODULE(NativeNavBridge)

- (instancetype)init
{
  self = [super init];
  if (self) {
    __weak RCTNavBridge *weakSelf = self;
    [[NavBridgeSessionService shared] setUpdateHandler:^(NSDictionary<NSString *, id> *snapshot) {
      [weakSelf emitOnSessionUpdate:snapshot];
    }];
  }
  return self;
}

- (void)getSnapshot:(RCTPromiseResolveBlock)resolve
             reject:(RCTPromiseRejectBlock)reject
{
  [[NavBridgeSessionService shared] getSnapshotWithResolve:resolve reject:reject];
}

- (void)dispatchCommand:(JS::NativeNavBridge::NativeSessionCommand &)command
                resolve:(RCTPromiseResolveBlock)resolve
                 reject:(RCTPromiseRejectBlock)reject
{
  id latitude = command.latitudeDeg() ? @(command.latitudeDeg().value()) : NSNull.null;
  id longitude = command.longitudeDeg() ? @(command.longitudeDeg().value()) : NSNull.null;
  id heading = command.headingDeg() ? @(command.headingDeg().value()) : NSNull.null;
  id sessionId = command.sessionId() ?: NSNull.null;
  id origin = command.origin() ?: NSNull.null;

  NSDictionary *nativeCommand = @{
    @"kind": command.kind(),
    @"requestId": command.requestId(),
    @"sessionId": sessionId,
    @"latitudeDeg": latitude,
    @"longitudeDeg": longitude,
    @"headingDeg": heading,
    @"origin": origin,
  };
  [[NavBridgeSessionService shared] dispatchCommand:nativeCommand resolve:resolve reject:reject];
}

- (std::shared_ptr<facebook::react::TurboModule>)getTurboModule:
    (const facebook::react::ObjCTurboModule::InitParams &)params
{
  return std::make_shared<facebook::react::NativeNavBridgeSpecJSI>(params);
}

@end
