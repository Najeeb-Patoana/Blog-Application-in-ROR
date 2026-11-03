class PostPolicy < ApplicationPolicy

  def index?
    true
  end

  def show?
    true
  end

  def create?
    user.present?
  end

  def new?
    create?
  end

  def update?
    user.present? && (user.admin? || record.user_id == user.id)
  end

  def edit?
    update?
  end

  def destroy?
    update?
  end

end