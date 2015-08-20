Pod::Spec.new do |s|

  s.name         = "MDPSplitView"
  s.version      = "1.0.2"
  s.summary      = "An NSSplitView subclass that animates and works with Auto Layout"
  s.homepage     = "https://github.com/mdiep/MDPSplitView"
  s.license      = { :type => "MIT" }
  s.author       = { "Matt Diephouse" => "matt@diephouse.com" }
  s.source       = { :git => "https://github.com/mdiep/MDPSplitView.git", :tag => "1.0.2" }

  s.source_files = "MDPSplitView.{h,m}"
  s.requires_arc = true

  s.osx.platform = :osx, "10.8"
  s.osx.deployment_target = "10.8"

end
