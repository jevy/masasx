module MasasService

  extend self

  def all
    [CmsService, ExerciseHub, SandboxHub, LiveHub]
  end

  def position service
    all.index(service)
  end

end
