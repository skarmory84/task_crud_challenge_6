# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new

    can :read, Task

    if user.editor?
      can :create, Task
      can :update, Task
    end
    
    if user.admin?
      can :manage, Task
    end
  end
end
