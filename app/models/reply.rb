class Reply < ApplicationRecord
  validates_presence_of :comment
  validates_length_of :comment, maximum: 300

  belongs_to :user
  belongs_to :post, counter_cache: true
  
end
