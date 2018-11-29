class RewardLogic
  include CsvHelper

  def initialize(csv)
    @customer = Hash.new # will contain points and inviter name of a customer
    @invitation = Hash.new # will store first invitation when somebody recommends
    @csv = csv
  end

  # Get all valid input lines from csv and act based on the action param
  def calculate
    recommendation_csv_inputs(@csv.path).each do |input|
      if input[:action] == RECOMMEND_ACTION
        add_recommendation input[:customer_name], input[:invitee_name]
      elsif input[:action] == ACCEPT_ACTION
        execute_accept_invitation_process input[:customer_name]
      end
    end

    get_result
  end

  private

  # Create a invitatin entry if no invitation already exists with that invitee_name
  # if the inviter does't have a customer entry, create one
  def add_recommendation customer_name, invitee_name
    return unless customer_name && invitee_name

    if @invitation[invitee_name].nil?
      @invitation[invitee_name] = customer_name
      create_new_customer(customer_name) if @customer[customer_name].nil?
    end
  end

  def create_new_customer customer_name, inviter_name = nil, reward = 0
    @customer[customer_name] = {name: customer_name, reward: reward, inviter_name: inviter_name}
  end

  # Create a new customer entry if an invitation exists for that name
  # distrubute reward points to the inviter of all level
  def execute_accept_invitation_process customer_name
    if @customer[customer_name].nil? && @invitation[customer_name].present?
      create_new_customer(customer_name, @invitation[customer_name])
      distribute_reward_point @invitation[customer_name], 0
    end
  end

  # Recursively find each inviter and add reward according to the level
  def distribute_reward_point customer_name, level
    return if customer_name.nil?
    @customer[customer_name][:reward] += BASE_POINT ** level
    distribute_reward_point @customer[customer_name][:inviter_name], level + 1
  end

  # Retrive all customers and prepare the result hash for view files
  def get_result
    result_hash = Hash.new
    @customer.each do |key, value_hash|
      result_hash[key] = value_hash[:reward]
    end
    result_hash
  end
end
