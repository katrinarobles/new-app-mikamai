class ArticlePolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      # scope.all
      scope.where(user: user)
    end
  end

  def create?
    true
  end

  def show?
    true
  end

  def update?
    user_admin_or_owner?
  end

  def destroy?
    user_admin_or_owner?
  end

  private

  def user_admin_or_owner?
    user == record.user || user.admin
  end
end
