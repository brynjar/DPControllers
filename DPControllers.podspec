Pod::Spec.new do |s|
    s.name          =   "DPControllers"
    s.version       =   "0.0.2"
    s.summary    =   "DP fancy Controllers"
    s.license        =   "MIT"
    s.author         =   { "Govi" => "govi@email.com"}
    s.source         =   { :git => 'https://github.com/brynjar/DPControllers' }
    s.platform       =   :ios, '5.0'
    s.source_files  =   'DPControllers', 'DPControllers/**/*.{h,m}'
    s.resources     =   'res/**/*.png', 'DPControllers/**/*.xib'
    s.frameworks   =   'CoreGraphics','UIKit','QuartzCore'
    s.requires_arc  =   true
    s.homepage     =   'https://github.com/govi/DPControllers'
end