class DemoPartialsController < ApplicationController
  def new
    @zone = "Zone new action"
    @date = Time.zone.now
  end

  def edit
    @zone = "Zone edit action"
    @date = Time.zone.now - 4.days
  end
end
