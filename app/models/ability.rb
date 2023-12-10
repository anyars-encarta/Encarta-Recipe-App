class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new

    can :destroy, Recipe, user_id: user.id

    return unless user.persisted?

    can :manage, Recipe, user_id: user.id

    can :read, Recipe, public: true
  end
end
