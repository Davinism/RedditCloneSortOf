class Post < ActiveRecord::Base
  validates :title, :sub, :author, presence: true

  belongs_to :sub,
    primary_key: :id,
    foreign_key: :sub_id,
    class_name: :Sub

  belongs_to :author,
    primary_key: :id,
    foreign_key: :user_id,
    class_name: :User

  # has_many :post_subs




end
