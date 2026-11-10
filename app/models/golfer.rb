class Golfer < ApplicationRecord
  attribute :front_net, :integer

  def reset_limited
    puts "You got here"
  end
end
