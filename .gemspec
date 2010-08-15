spec = Gem::Specification.new do |s|
  s.name = 'tankobon'
  s.version = '0.1a'
  s.summary = "Converts manga scans"
  s.description = %{Tools for resizing manga scans for the e-book readers}
  s.files = Dir['lib/**/*.rb'] + Dir['test/**/*.rb']
  s.require_path = 'lib'
  s.has_rdoc = false
  #s.extra_rdoc_files = Dir['[A-Z]*']
  #s.rdoc_options << '--title' <<  'Tankobon'
  s.author = "Stefano Pigozzi"
  s.email = "stefano.pigozzi@gmail.com"
  s.homepage = "http://stefanopigozzi.com"
end
