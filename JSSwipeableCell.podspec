Pod::Spec.new do |s|
    s.name                  = 'JSSwipeableCell'
    s.version               = '1.1.0'
    s.summary               = 'Transform UICollectionViewCell to be swipeable.'
    s.description           = <<-DESC
                              This framework can transform 'UICollectionViewCell' to be swipeable.
                              DESC
    s.homepage              = 'https://github.com/wlsdms0122/JSSwipeableCell'
    s.screenshots           = ''
    s.license               = { :type => 'MIT', :file => 'LICENSE' }
    s.author                = { 'JSilver' => 'wlsdms0122@gmail.com' }
    s.source                = { :git => 'https://github.com/wlsdms0122/JSSwipeableCell.git', :tag => s.version.to_s }
    
    s.swift_versions         = '5'
    s.ios.deployment_target = '10.0'
    s.source_files          = 'JSSwipeableCell/Source/*.swift'
end
