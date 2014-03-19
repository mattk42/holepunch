class Ability
  include CanCan::Ability

  def initialize(user)

    #Basic rights that all registered users have
    if user != nil
        can :create, AwsAccount
        can [:read,:update,:destroy, :instances], AwsAccount, :account_id=>user.account_id

        can :create, Reservation
        can [:read,:update,:destroy], Reservation, :user_id=>user.id
	
	    #Admin only rights
	    if user.admin == true
		can [:read,:create,:update,:destroy], User, :account_id=>user.account_id
	    end
    end

    #Rights that all users have, even if not yet signed in
    can [:read,:create,:update,:destroy], Account

    # Define abilities for the passed in user here. For example:
    #
    #   user ||= User.new # guest user (not logged in)
    #   if user.admin?
    #     can :manage, :all
    #   else
    #     can :read, :all
    #   end
    #
    # The first argument to `can` is the action you are giving the user 
    # permission to do.
    # If you pass :manage it will apply to every action. Other common actions
    # here are :read, :create, :update and :destroy.
    #
    # The second argument is the resource the user can perform the action on. 
    # If you pass :all it will apply to every resource. Otherwise pass a Ruby
    # class of the resource.
    #
    # The third argument is an optional hash of conditions to further filter the
    # objects.
    # For example, here the user can only update published articles.
    #
    #   can :update, Article, :published => true
    #
    # See the wiki for details:
    # https://github.com/ryanb/cancan/wiki/Defining-Abilities
  end
end
