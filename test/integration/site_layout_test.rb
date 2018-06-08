require 'test_helper'

class SiteLayoutTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:michael)
  end

  test "layout links without logged in user" do
    get root_path
    assert_template 'static_pages/home'
    assert_select 'div.stats', count: 0
    assert_select "a[href=?]", root_path, count: 2
    assert_select "a[href=?]", help_path
    assert_select "a[href=?]", users_path, count: 0
    assert_select "a[href=?]", login_path
    assert_select "a[href=?]", users_path, count: 0
    assert_select "a[href=?]", about_path
    assert_select "a[href=?]", contact_path
    get contact_path
    assert_select "title", full_title("Contact")
    get signup_path
    assert_select "title", full_title("Sign up")
  end

  test "layout links with logged in user" do
    log_in_as @user
    get root_path
    assert_template "static_pages/home"
    assert_select 'div.stats'
    assert_select "a[href=?]",   followers_user_path(@user)
    assert_match @user.followers.count.to_s, response.body
    assert_select "a[href=?]",   following_user_path(@user)
    assert_match @user.following.count.to_s, response.body
    assert_select "a[href=?]",   users_path
    assert_select "a[href=?]",   login_path, count: 0
    assert_select "a[href=?]",   user_path(@user)
    assert_select "a[href=?]",   edit_user_path(@user)
    assert_select "a[href=?]",   logout_path
  end
end
