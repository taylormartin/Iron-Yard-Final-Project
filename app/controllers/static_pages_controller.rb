class StaticPagesController < ApplicationController

  def home
    @artists = Songkick.get_events(4120,Date.today,Date.today)
  end

end
