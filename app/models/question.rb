class Question < ActiveRecord::Base
  belongs_to :user
  validates :category, :text, presence: true
  validates_inclusion_of :answer, :in => [true, false]

  def self.pick
    Question.first
  end

end
