class UpdateColumnsOnUsers < ActiveRecord::Migration[5.2]
  disable_ddl_transaction!

  def up
    update_users
    remove_column :users, :provider
    remove_column :users, :uid
  end

  def down
    add_column :users, :provider, :string
    add_column :users, :uid, :string
  end

  private

  def update_users
    User.all.find_in_batches do |user_group|
      user_group.each do |user|
        nickname, email_right_part = user.email.split('@')
        email_domen, provider = email_right_part.split('-')
        user = combine_users_by_email(user, [nickname, email_domen].join('@')) if provider.present?
        user.nickname = nickname if user.nickname.blank?
        user.save(validate: false) if user.changed?
      end
    end
  end

  def combine_users_by_email(user, dup_email)
    dup_users = User.where('email ILIKE ?', "%#{dup_email}%")
    if dup_users.size > 1
      user = dup_users.find { |u| u.provider.nil? }.presence || dup_users.last
      move_dup_users_data(user, dup_users)
    end
    user.email = dup_email if user.email != dup_email
    user
  end

  def move_dup_users_data(user, dup_users)
    dup_users.filter { |dup_user| user.id != dup_user.id }.each do |dup_user|
      %i[chapters chapter_links elements news notifications reviews serials videos social_networks].each do |k|
        dup_user.public_send(k).update_all(user_id: user.id)
      end
      dup_user.delete
    end
  end
end
