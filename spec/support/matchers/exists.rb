Spec::Matchers.define :exists do |expected|
  match do |actual|
    actual.exists?(expected)
  end
end
