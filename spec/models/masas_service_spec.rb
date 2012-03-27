require 'spec_helper'

describe MasasService do

  it '.all' do
    describes_class.all.should =~ [CmsService, ExerciseHub, SandboxHub, LiveHub]
  end

end
