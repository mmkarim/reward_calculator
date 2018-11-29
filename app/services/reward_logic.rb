class RewardLogic
  include CsvHelper

  def initialize(csv)
    @csv = csv
  end

  # Get all valid input lines from csv and act based on the action param
  def calculate
    recommendation_csv_inputs(@csv.path)
  end
end
