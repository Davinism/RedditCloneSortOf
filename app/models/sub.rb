class Sub < ActiveRecord::Base
  validates :title, :description, :user_id, presence: true

  belongs_to :moderator,
    primary_key: :id,
    foreign_key: :user_id,
    class_name: :User

  has_many :posts,
    primary_key: :id,
    foreign_key: :sub_id,
    class_name: :Post

  has_many :post_subs
end
