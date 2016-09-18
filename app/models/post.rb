class Post < ActiveRecord::Base
  validates :title, :author, presence: true

  belongs_to :author,
    primary_key: :id,
    foreign_key: :user_id,
    class_name: :User

  has_many :post_subs

  has_many :subs,
  through: :post_subs,
  source: :sub




end
