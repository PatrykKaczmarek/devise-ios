#
#  Podfile
#
#  Copyright (c) 2014 Netguru Sp. z o.o. All rights reserved.
#

# Pod sources
source 'https://github.com/CocoaPods/Specs.git'

# Initial configuration
platform :ios, '7.1'
inhibit_all_warnings!

# Framework dependencies
pod 'AFNetworking', '~> 2.5'
pod 'UICKeyChainStore', '~> 1.1'

# Unit tests exclusive dependencies
target 'Tests', exclusive: true do link_with 'Devise Tests'
  pod 'Kiwi', '~> 2.3'
  pod 'OHHTTPStubs', '~> 3.1'
end
