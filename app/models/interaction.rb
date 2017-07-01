class Interaction < ApplicationRecord
  belongs_to :substance_a, class_name: :Drug
  belongs_to :substance_b, class_name: :Drug

  def self.find_any_interaction(substance_a, substance_b)
    interaction = find_by(substance_a: substance_a, substance_b: substance_b)
    return interaction if interaction
    find_by(substance_a: substance_b, substance_b: substance_a)
  end

  def message
    message = "Probably #{status}"
    message += "- #{notes}" if notes
    message
  end
end
