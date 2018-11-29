class DashboardController < ApplicationController
  def index
  end

  def import
    csv = params[:csv]
    redirect_to(root_url, notice: "Please import a valid csv") && return unless csv

    @customer_result = RewardLogic.new(csv).calculate
  end
end
