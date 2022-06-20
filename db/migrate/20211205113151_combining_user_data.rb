class CombiningUserData < ActiveRecord::Migration[5.2]
  disable_ddl_transaction!

  def up
    accounts = Account.all
    @current = 0
    @total = accounts.size
    accounts.each do |account|
      users = account.users
      standard_user = users.find { |u| u.provider.nil? }.presence || users.last
      users.filter { |u| u.provider.present? }.each do |user|
        add_user_social_network(user, standard_user)
        user.delete if user != standard_user
      end
      move_to_user(standard_user, account)
      update_user_data(standard_user, account)
      print_info
    end
  end

  def down; end

  private

  def print_info
    @current = @current.next
    say("#{@total}/#{@current}")
  end

  def move_to_user(user, account)
    %i[chapters chapter_links elements news notifications reviews serials videos].each do |k|
      account.public_send(k).update_all(user_id: user.id, account_id: nil)
    end
  end

  def add_user_social_network(user, standard_user)
    UserSocialNetwork.create(user_id: standard_user.id, provider: user.provider, uid: user.uid)
  end

  def update_user_data(user, account)
    user.nickname = account.nickname if account.nickname.present?
    user.is_admin = account.is_admin unless user.is_admin?
    user.is_admin = account.is_admin unless user.is_admin?
    user.is_editor = account.is_admin unless user.is_admin?
    user.is_moderator = account.is_admin unless user.is_admin?
    user.save(validate: false) if user.changed?
  end
end
