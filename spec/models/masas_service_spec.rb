require 'spec_helper'

describe MasasService do

  it '.all' do
    MasasService.all.should =~ [CmsService, ExerciseHub, SandboxHub, LiveHub]
  end

  it '.position' do
    MasasService.position(CmsService).should eql 0
  end

end
