module CsvHelper
  require 'csv'

  # extract inputs from csv file for recommendation reward calculation
  def recommendation_csv_inputs csv_path
    valid_inputs = []

    CSV.foreach(csv_path, {headers: true, header_converters: :symbol}) do |row|
      row = row.to_h
      valid_inputs << row if valid_recommendation_hash?(row)
    end

    valid_inputs

    rescue => e
      valid_inputs
  end

  private

  # RECOMMEND_ACTION should contain both params: customer_name and invitee_name params
  # ACCEPT_ACTION should contain customer_name param
  def valid_recommendation_hash? input
    (input[:action] == RECOMMEND_ACTION && input[:customer_name] && input[:invitee_name]) ||
      (input[:action] == ACCEPT_ACTION && input[:customer_name])
  end
end
