class TopController < ApplicationController
  def top
    render 'top', layout: nil
  end
end
