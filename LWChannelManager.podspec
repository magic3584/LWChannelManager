Pod::Spec.new do |s|


  s.name         = "LWChannelManager"
  s.version      = "2.0.5"
  s.summary      = "LWChannelManager"


  s.description  = "A simple channel manager"
  s.homepage     = "https://github.com/magic3584/LWChannelManager"

  s.license      = { :type => "MIT", :file => "LICENSE" }

  s.author             = { "magic3584" => "xuewuzhiyuan@sina.com" }
  s.social_media_url   = "http://lugick.com"


  s.platform     = :ios, "8.0"

  s.source       = { :git => "https://github.com/magic3584/LWChannelManager.git", :tag => s.version }


  # ――― Source Code ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  CocoaPods is smart about how it includes source code. For source files
  #  giving a folder will include any swift, h, m, mm, c & cpp files.
  #  For header files it will include any header in the folder.
  #  Not including the public_header_files will make all headers public.
  #

  s.source_files  = "navi/LWChannelManager/*.{swift}"


  # s.exclude_files = "Classes/Exclude"
  # s.public_header_files = "Classes/**/*.h"


  # ――― Resources ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  A list of resources included with the Pod. These are copied into the
  #  target bundle with a build phase script. Anything else will be cleaned.
  #  You can preserve files from being cleaned, please don't preserve
  #  non-essential files like tests, examples and documentation.
  #

  # s.resource  = "icon.png"
  # s.resources = "Resources/*.png"

  # s.preserve_paths = "FilesToSave", "MoreFilesToSave"


  # ――― Project Linking ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  Link your library with frameworks, or libraries. Libraries do not include
  #  the lib prefix of their name.
  #

   s.frameworks = "UIKit"

  # s.library   = "iconv"
  # s.libraries = "iconv", "xml2"



  # s.xcconfig = { "HEADER_SEARCH_PATHS" => "$(SDKROOT)/usr/include/libxml2" }
  # s.dependency "JSONKit", "~> 1.4"
  # pod spec lint Peanut.podspec
end