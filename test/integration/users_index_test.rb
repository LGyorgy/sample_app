require 'test_helper'

class UsersIndexTest < ActionDispatch::IntegrationTest
  def setup
    @admin         = users(:michael)
    @non_admin     = users(:archer)
    @inactive_user = users(:lana)
  end

  test "index including pagination and delete links" do
    log_in_as(@admin)
    get users_path
    assert_template "users/index"
    assert_select "div.pagination", count: 2
    User.where(activated: true).paginate(page: 1).each do |user|
      assert_select "a[href=?]", user_path(user), text: user.name
      unless user == @admin
        assert_select "a[href=?]", user_path(user), text: 'delete'
      end
    end
    assert_difference "User.count", -1 do
      delete user_path(@non_admin)
    end
  end

  test "show page for inactive user returns to root" do
    get user_path(@inactive_user)
    follow_redirect!
    assert_template "static_pages/home"
  end

  test "show page for active user" do
    get user_path(@non_admin)
    assert_template "users/show"
  end

  test "index as non-admin" do
    log_in_as(@non_admin)
    get users_path
    assert_select "a", text: "delete", count: 0
  end
end
